# Wasserabschalter mit Zigbee und ioBroker

Dieses Repository enthält zusätzliche Informationen zum Wasserabschalter aus dem Ikea-Sonderheft der Zeitschrift Make. 

Ein Wasserschaden nach einem Rohrbruch oder einer anderen Leckage ist immer eine unangenehme Sache. Speziell wenn dies im Urlaub passiert und niemand den Schaden bemerkt, und das Wasser einfach weiter fließt. Abhilfe schafft hier ein einfaches Projekt zur Abschaltung des Hauswasseranschlusses beim Erkennen einer Leckage. Die Erkennung erfolgt mit dem Ikea Wasserdetektor Badring und die Abschaltung erfolgt mit einem 12 Volt-Akkuschrauber, der über einen Ikea Schalter Tretakt geschaltet wird. Die Logik und Alarmierung habe ich mit dem Smarthome-System ioBroker und dem ZigBee-Modul Zigbee2MQTT realisiert. Mittels ioBroker erfolgt auch die Benachrichtigung per E-Mail und der Anruf auf das Mobiltelefon. Somit steht einem entspannten Urlaub nichts mehr im Wege.

![Abschalter](https://github.com/AK-Homberger/Wasserabschalter/blob/main/Bilder/Aufmacher1.png)

## Kurzinfo
- Hauswasserabschaltung über Akkuschrauber mit Drehmomenteinstellung
- Lekageerkennung über Ikea ZibBee-Wasserdetektor Badring
- Ansteuerung des Akkuschraubers über Ikea Zigbee-Schalter Tretakt
- Beliebig viele Sensoren integrierbar
- Adapterplatte für Handrad als 3D-Druck-Vorlage (anpassbar)
- Kardangelenk als Achsausgleich
- Alarmierung per E-Mail und Telefonanruf (erfordert Fritzbox)
- Steuerung über Script in IoBroker auf einem Raspberry. 
- ZigBee-Integration in ioBroker über ZigBee2MQTT.

# Hardware
Für die mechanische Abschaltung des Hauwassers verwende eine einfache 12 Volt Handbohrmashine mit Drehmomenteinstellung. Ich hatte erst über einen Getriebemotor nachgedacht. Aber die notendige Dremomentkupplung habe ich nirgends günstig gefunden. Bei Akku-Bohrmschinen ist sie dagegen Standard. Bei der Liste der benötigten Teile ist ein Link zu Amazon. Die einfache Bohrmasine für unter 20 Euro reicht hier aus. 

Die Bohrmaschine wird über ein Kardangelenk und deiner Adapterplatt mit dem Handrad des Wasserventils verbunden. Das Kardangelenk soll leicht Achsvershiebungen ausgleichen. Wahrscheinlich würde es auch ohne dieses Gelenk funktionieren.

##Wichtg!
Die Achaltung funktioniert nur mit "Nichtsteigenden" Ventilen. Bei "steigenden" Ventilen drcht sich die Welle des Handrads in das Ventil hinein. Dadurch würde sich der Abstand zur Bohrmaschibe stetig vergrössern bis keine Verbindung mehr gegeben ist. Daher vorher prüfen, ob ein "nichtstegendes" Ventil verbaut ist. Die Ventile kann auch wechseln. Der lokale Installatur kann hier bei Bedarf helfen. 






![Platte1](https://github.com/AK-Homberger/Wasserabschalter/blob/main/SCAD/Absperrplatte2.stl)

# Installation ioBroker

- Rapberry Imager als Administrator starten
- 64 Bit OSLite auswählen
- Hostname und Passwort festlegen
- SD-Karte schreiben

- SD-Karte in Raspberry einlegen und starten
- Einloggen. Entweder lokal mit Tastatur und Bildschirm oder per SSH. IP-Adresse über den Router herausfinden!

```
sudo apt update
sudo apt upgrade

sudo raspi-config - Filesystem expand unf Logging aus.
```

ioBroker mit : 
```
curl -sLf https://iobroker.net/install.sh | bash - 
```

installieren.

Open ioBroker: http://IP-Adresse:8081

ioBroker Einstellungen festlegen.

Folgende Adapter in ioBroker installieren:
- Email
- Javascript
- Tr-064
- Zigbee2Mqtt

Zu "Instanzen" wechseln und Instanzen konfigurieren.


# Installation Zigbee2Mqtt

Detaillierte Informationen sind hier zu finden: https://www.zigbee2mqtt.io/guide/installation/01_linux.html

Die folgenden Befehle reichen aber aus:
```
sudo curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs git make g++ gcc libsystemd-dev
sudo npm install -g pnpm

sudo mkdir /opt/zigbee2mqtt
sudo chown -R ${USER}: /opt/zigbee2mqtt

git clone --depth 1 https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt

cd /opt/zigbee2mqtt
pnpm i --frozen-lockfile
```

Datei "configuration.yaml" anpassen:

```
nano /opt/zigbee2mqtt/data/configuration.yaml
```
```
homeassistant:
  enabled: false
frontend:
  enabled: true
  port: 8080
  host: 0.0.0.0
mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://localhost:1887
serial:
  port: /dev/ttyUSB0
  adapter: zstack
advanced:
  cache_state: false
  output: json
  channel: 11
  transmit_power: 5
  homeassistant_legacy_entity_attributes: false
  homeassistant_legacy_triggers: false
  legacy_api: false
  legacy_availability_payload: false
  log_level: warning
device_options:
  legacy: false
availability:
  enabled: true
  active:
    timeout: 10
  passive:
    timeout: 1500
```

Testen mit: 
```
pnpm start
```

Start als Service:

Editor starten und Datei "zigbee2mqtt.service" mit folgendem Inhalt erzeugen.
```
sudo nano /etc/systemd/system/zigbee2mqtt.service
```
```
[Unit]
Description=zigbee2mqtt
After=network.target

[Service]
Environment=NODE_ENV=production
#Type=notify
ExecStart=/usr/bin/node index.js
WorkingDirectory=/opt/zigbee2mqtt
StandardOutput=inherit
#Or use StandardOutput=null if you don't want Zigbee2MQTT messages filling syslog, for more options see systemd.exec(5)
StandardError=inherit
#WatchdogSec=10s
Restart=always
RestartSec=10s
User=pi

[Install]
WantedBy=multi-user.target
```
Wegen eines Fehlers bei meiner Raspberry Version (Bookworm) musste ich die Zeilen 
```
#Type=notify
```
und
```
#WatchdogSec=10s
```
auskommentieren. Ansonsten funktionierte der Start über Systemctl nicht richtig (Abstürze). Der Fehler ist auch bei anderen Usern schon aufgetreten. 

```
sudo systemctl start zigbee2mqtt

systemctl status zigbee2mqtt.service

sudo systemctl enable zigbee2mqtt.service
```




