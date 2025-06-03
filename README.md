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
Für die mechanische Abschaltung des Hauwassers verwende eine einfache 12 Volt Handbohrmashine mit Drehmomenteinstellung. Ich hatte erst über einen Getriebemotor nachgedacht. Aber die notendige Drehmomentkupplung habe ich nirgends günstig gefunden. Bei Akku-Bohrmschinen ist sie dagegen Standard. Bei der [Liste der benötigten](https://github.com/AK-Homberger/Wasserabschalter/blob/main/README.md#bezugsquellen) Teile ist ein Link zu [Amazon](https://www.amazon.de/Akkuschrauber-Lithium-family-tech-112-Valex-1429400/dp/B077YSQW1Z) dabei. Die einfache Bohrmaschine für unter 20 Euro reicht hier aus. 

Die Bohrmaschine wird über ein Kardangelenk und eine Adapterplatte mit dem Handrad des Wasserventils verbunden. Das Kardangelenk soll leichte Achsverschiebungen ausgleichen. Wahrscheinlich würde es auch ohne dieses Gelenk funktionieren.

Die Adapterplatte und der Befestigungsring sind im Verzeichnis SCAD als OpenSCAD- und STL-Datei vorhanden. Die Adapterplatte sollte für die meisten Handräder passen. Bei Bedarf kann man die Platte aber mit OpenSCAD einfach an das aktuelle Handrad anpassen.

![Adapterplatte](https://github.com/AK-Homberger/Wasserabschalter/blob/main/SCAD/Absperrplatte2.stl) ![Ring](https://github.com/AK-Homberger/Wasserabschalter/blob/main/SCAD/Absperrplatte2-Ring.stl)

Zur einfachen Montage des Akkuschraubers verwende ich sogenannte [Thermohalter](https://alufensterbaenke.de/thermohalter) für Fensterbänke. 

![Halter](https://alufensterbaenke.de/media/catalog/product/cache/2ad09310492482b8dd76867023a48036/0/1/01_thermohalter_anwendung_mg.jpg)

Der Vorteil dieser Lösung ist der variable Abstand zur Wand, der einfach durch kürzen der Alu-Profile auf die benötigte Länge erfolgt.

# Software
Die Steuerung des Wasserabschalters erfolgt mit einem Raspberry und zwei Software-Komponenten. Einmal dem Smarthome-System [ioBroker](https://www.iobroker.net/) und zum Zweiten die Software [Zigbee2Mqtt](https://github.com/Koenkk/zigbee2mqtt). ioBroker übernimmt dabei die Automatisierung per Script und Zigbee2mqtt die Anbindung der Ikea Zigbee-Komponenten Tertakt (Schalte) und Bdring (Leckage Detektor).

Für die verlässliche Funktion des Systems ist mindestens ein Raspberry 4 mit 2 GB RAM erforderlich. Ein komplettes Bundle ist zum Beispiel [hier](https://www.reichelt.de/de/de/shop/produkt/das_reichelt_raspberry_pi_4_b_2_gb_all-in-bundle-263082?PROVID=2788&gQT=2) verfügbar.

## Installation Raspberry OS und ioBroker
Zur Vorbereitung der Installation benötigen wir zuerst des "Raspberry Pi Imager" der [hier](https://www.raspberrypi.com/software/) zum Download bereitsteht.
Als Betriebssystem für ioBroker empfehele ich die OSLite-Version für den Raspberry ohne grafischen Desktop. Die Bedienung von ioBroker und Zigbee2mqtt erfolgt per Browser. Es funktionieren aber auch andere Versionen des Betriebssystems. Zum Schreiben des Betriebssytems auf die SD-Karte wird ein entsprechnder [Adapter](https://www.amazon.de/dp/B00FQFYOM4) benötigt. 

Für den einfachen Nachbau habe ich alle Kommandos hier aufgeführt. Sie können eineln kopiert und im Raspberry Terminal eingefügt werden. Das spart mühsame Tipperei.

Vor der Intallation der Software sollte der [Sonoff-Zigbee-Adapter](https://sonoff.tech/product/gateway-and-sensors/sonoff-zigbee-3-0-usb-dongle-plus-p/) in eine USB-Buchse eingesteckt werden. 

![Sonoff-Dongle](http://sonoff.tech/wp-content/uploads/2021/09/5-1.jpg)

Wichtig: Es gibt zwei Versionen des Zigbee-Adapters SBDongle-P und ZBDongle-E mit unterschiedlichen Chipsets. Für diese Projekt wird der Dongle "P" mit dem Chipset "CC2652P" benötigt. Der andere sollte auch funktionieren. Es müssen dann aber Einstellungen in der Konfiguration geändert werden.

Für eine bessere Funkverbindung hat es sich bewährt, den Dongle nicht direkt in den Raspberry zu stecken, sondern mit einem USB-Verlängerungskabel etwas entfernt vom Raspberry aufzustellen.

## Installation

- Rapberry Imager als Administrator starten (zumindest unter Windows 11; ansonsten sperrt der Virenschutz das Kopieren einiger Komponenten)
- 64 Bit OSLite auswählen
- Hostname und Passwort festlegen
- SD-Karte auswählen und Imge schreiben

- SD-Karte in Raspberry einlegen und starten
- Einloggen. Entweder lokal mit Tastatur und Bildschirm oder per SSH. IP-Adresse über den Router herausfinden! Als SSH-Client empfehle ich [Putty](https://www.putty.org/)

```
sudo apt update
sudo apt upgrade

sudo raspi-config - Filesystem expand und Logging aus.
```

ioBroker mit : 
```
curl -sLf https://iobroker.net/install.sh | bash - 
```

installieren.

ioBroker im Browser öffnen: http://IP-Adresse:8081

ioBroker Einstellungen festlegen.

Folgende Adapter in ioBroker installieren:
- Email
- Javascript
- Tr-064
- Zigbee2Mqtt

Zu "Instanzen" wechseln und Instanzen konfigurieren.

## Installation Zigbee2Mqtt

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
Folgenden Text einfügen:
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
Beenden mit Strg-X und Schreiben mit "Y".

Testen mit: 
```
pnpm start
```

Start als Service:

Editor starten und Datei "zigbee2mqtt.service" mit folgendem Inhalt erzeugen.
```
sudo nano /etc/systemd/system/zigbee2mqtt.service
```
Folgenden Text einfügen:
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
Beenden mit Strg-X und Schreiben mit "Y".
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
Jetzt kann der Raspberry mit "sudo reboot" neu gestartet werden. 

ioBroker im Browser öffnen: http://IP-Adresse:8081
Dann zum Tab Zigbee2MQTT wechseln und den Schalter [Tretakt](https://www.zigbee2mqtt.io/devices/E22x4.html#ikea-e22x4) und zumindest einen Leckage-Sensor [Badring](https://www.zigbee2mqtt.io/devices/E2202.html#ikea-e2202) hinzufügen. 

![Tretakt](https://www.zigbee2mqtt.io/images/devices/E22x4.png)
![Badring](https://www.zigbee2mqtt.io/images/devices/E2202.png)

Dazu "Anlernen aktivieren (alle)" auswählen. Beim Schalter Tretakt muss zum Pairen die kleine Taste in der Vertiefung unter dem Ein/Aus-Taster für ca. 2 Sekunden gedrückt werden. Beim Sensor Badring befindet sich der Pairing-Taster unter der Batterie-Abdeckung. Der Taster mus viermal hintereinander gedrückt werden.

Jetzt sollten die Komponenten in der Liste angezeigt werden.

Im nächsten Schritt erstellen wir das Script zum steueren des Akkuschraubers und zur Benachrichtigung.

Dazu links im ioBroker-Menü "Scripte" auswählen und ein neues Script mit "+" erzeugen. Als Namen "Wasserabschalter" wählen. Dann den folgenden Text einfügen:

```
var OffTime = 3; // Zeit zum Abdrehen in Sekunden

var Schalter = "zigbee2mqtt.0.0x881a14fffe2f0931.state";
var Sensor_1 = "zigbee2mqtt.0.0xc4d8c8fffeef649d.detected";
var Sensor_2 = "zigbee2mqtt.0.0xc4d8c8fffeff3b9f.detected";

// Motor ausschalten
function AbschaltungAus() {
    setState(Schalter, false);    
}

// Motor für "OffTime" einschalten
function AbschaltungAn() {
    setState(Schalter, true);
    setTimeout(AbschaltungAus, OffTime * 1000);	
}

AbschaltungAus();  // Abschalten beim Start des Scripts

// Heizung Sensor (Therme und Speicher)
on({id: Sensor_1}, async function (obj) {
          
    if (getState(Sensor_1).val == true) {
	    AbschaltungAn();
        sendTo("email.0", "Wassersensor Heizung: Feucht!"); // Sende email 
        setState("tr-064.0.states.ring", "Telefonnummer");    // Anrufen            
    }    
    else if (getState(Sensor_1).val == false) {
		sendTo("email.0", "Wassersensor Heizung: Trocken!");// Sende email         
    }    
});

// Keller Sensor
on({id: Sensor_2}, async function (obj) {
          
    if (getState(Sensor_2).val == true) {
	    AbschaltungAn();
        sendTo("email.0", "Wassersensor Keller: Feucht!");  // Sende email 
        setState("tr-064.0.states.ring", "Telefonnummer");    // Anrufen             
    }    
    else if (getState(Sensor_2).val == false) {
		sendTo("email.0", "Wassersensor Keller: Trocken!"); // Sende email       
    }    
});

// Abschaltung nach "OffTime" nach manuellem Anschalten zum Testen (Sensoren trocken)
on({id: Schalter}, async function (obj) {
          
    if ((getState(Schalter).val == true) && 
        (getState(Sensor_1).val == false) &&
        (getState(Sensor_2).val == false)) {
	    setTimeout(AbschaltungAus, OffTime * 1000);
    }             
});
```

Im Script müssen noch die eindeutigen Bezeichnungen der Zigbee-Komponenten "Schalter" und "Sensor_1/2" angepasst werden. 
Die richtigen Bezeichnungen können mit der Funktion "Objekt-ID einfügen" oben rechts mit dem Klemmbrett-Symbol herausgefunden und eingefügt werden.
Auch die "Telefonnummer" muss noch angepasst werden.

Dann "Speichern" wählen. Sofern keine Fehlermeldungen ausgegeben werden steht einem Test nichts im Wege. Der Lekagesensor reagiert übrigens auch auf "feuchte" Finger.

Beim Auslösen sollte nun das Wasser abgeschaltet werden und eine E-Mail versendet werden. Sofern eine Fritzbox vorhanden ist sollte auch das Telefon mit der angegebenen Nummer klingeln. Wenn keine Fritzbox vorhanden ist bitte die Zeilen "setState("tr-064.0.states.ring", "Telefonnummer");" auskommentieren.  


# Bezugsquellen:

- Raspberry Pi 4 Kit [Reichelt.de](https://www.reichelt.de/de/de/shop/produkt/das_reichelt_raspberry_pi_4_b_2_gb_all-in-bundle-263082)
- SONOFF Zigbee 3.0 USB Dongle [Amazon.com](https://www.amazon.de/SONOFF-Gateway-CC2652P-Assistant-Zigbee2MQTT/dp/B09KXTCMSC)
- Ikea Zigbee-Schalter TRETAKT [Ikea](https://www.ikea.com/de/de/p/tretakt-steckdose-smart-80540349/)
- Ikea Zigbee-Leckagesensor BADRING [Ikea](https://www.ikea.com/de/de/p/badring-wasserlecksensor-smart-60504352/)
- Valex Akkuschrauber [Amazon.com](https://www.amazon.de/Akkuschrauber-Lithium-family-tech-112-Valex-1429400/dp/B077YSQW1Z)
- Thermohalter (2 Stück) [Alufensterbaenke.de](https://alufensterbaenke.de/thermohalter)
- Kardangelenk [Amzon.com](https://www.amazon.de/bis-Durchmesser-drehbar-Kardangelenk-RC-Modellflugzeug/dp/B00O9YGCKU)
- 12 Volt 10 A Trafo [Amazon.com](https://www.amazon.de/Netzteil-Spannungswandler-Netzadapter-Transformator-Stromversorgung-schwarz/dp/B0D9S8N8TT)
- Krokodilklemmen [Amazon.com](https://www.amazon.de/Multimeter-Messleitungen-Bananenstecker-Krokodilklemme-Messspitzen/dp/B0D39WQZ9M)





