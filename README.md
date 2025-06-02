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
Für die mechanische Abschaltung des Hauwassers verwende eine einfache 12 Volt Handbohrmashine mit Drehmomenteinstellung. Ich hatte erst über einen Getriebemotor nachgedacht. Aber die notendige Drehmomentkupplung habe ich nirgends günstig gefunden. Bei Akku-Bohrmschinen ist sie dagegen Standard. Bei der Liste der benötigten Teile ist ein Link zu [Amazon](https://www.amazon.de/Akkuschrauber-Lithium-family-tech-112-Valex-1429400/dp/B077YSQW1Z/ref=sr_1_2?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=1KUMVWF6S6XDL&dib=eyJ2IjoiMSJ9.Z7QvFh3QlUaY3Bst_gR_wZVBd-SfqTbajSC_BgjRqhC9G0jxX-8GgQlIj6PsA9FpkYRIf6nCSvTxvuMmvbl0cwmKISCT01ukDAP02i-HGDCRs6VT3XKkeKYSREPxEdd4sIvwhpL-BLVbP30guOHyeorQf7o4_NQMcp3RbCfw2KNzKPWpuJcmjEPzT4dxtL4kZqv5a1wGUhFZN0jt7K9V8wkEEcbxLJpQ0WMfY9RYq-s.1rDC5TaB4mb1_-Yh5tY1ils7tcQ4ryG-p1tPP4Fmbds&dib_tag=se&keywords=12+Volt+akkuschrauber+valex&qid=1748876696&sprefix=12+volt+akkuschrauber+valex%2Caps%2C94&sr=8-2) dabei. Die einfache Bohrmaschine für unter 20 Euro reicht hier aus. 

Die Bohrmaschine wird über ein [Kardangelenk](https://www.amazon.de/Kardangelenke-Handgebrauch-Universal-Anschluss-Kupplung-mit-Inbusschl%C3%BCssel/dp/B08H4H9WP6?source=ps-sl-shoppingads-lpcontext&ref_=fplfs&psc=1&smid=A21Y3K2MLM0Y3I) und einer Adapterplatte mit dem Handrad des Wasserventils verbunden. Das Kardangelenk soll leichte Achsverschiebungen ausgleichen. Wahrscheinlich würde es auch ohne dieses Gelenk funktionieren.

## Wichtg! Nichtsteigende Spindel
Die Abschaltung funktioniert nur bei Ventilen mit "nichtsteigender" Spindel. Bei Ventilen mit "steigender" Spindel dreht sich die Welle des Handrads in das Ventil hinein. Dadurch würde sich der Abstand zur Bohrmaschine stetig vergrössern, bis keine Verbindung mehr gegeben ist. Daher vorher prüfen, ob ein Ventil mit "nichtstegender" Spindel verbaut ist. Die [Ventile/Oberteile](https://www.ew-haustechnik.com/JS-Fettkammer-Oberteil-KFR-Typ-1821-mit-nichtsteigender-Spindel-fuer-KFR-und-Freistromventile) kann auch wechseln. Der lokale Installatur kann hier bei Bedarf helfen. 

Die Adapterplatte und der Befestigungsring sind im Verzeichnis SCAD als OpenSCAD- und STL-Datei vorhanden. Die Adapterplatte sollte für die meisten Handräder passen. Bei Bedarf kann man die Platte aber mit OpenSCAD einfach an das aktuelle Handrad anpassen.

![Adapterplatte](https://github.com/AK-Homberger/Wasserabschalter/blob/main/SCAD/Absperrplatte2.stl) ![Ring](https://github.com/AK-Homberger/Wasserabschalter/blob/main/SCAD/Absperrplatte2-Ring.stl)

Zur Verbindung zwischen Kardangelenk aund Adapterplatt/Bohrmaschine eignen sich zwei 4 mm Schrauben (ca 20 mm Länge) eine mit Rundkopf und eine mit Sechskanntkopf und entsprechende Muttern. Zur Verbindung mit dem Kardagelenk muss die Spitze des 4 mm Gewindes etwas abgefeilt werden damit die Schraube im Kardangelenk mit der Madenschraube fixiert werden kann.

Dann ein 4 mm Loch durch das zentrum der Platte bohren. Ein etwas grösseres Sackloch zur Aufnahme des Schrubenkopfes in die Platte bohren. Aber nicht zu tief!

Die Schraube mit Rundkopf durch die Platte stecken sodass der Rundkopf in die Aussparung passt. Dann auf der entgegengesetzten Seite mit einer Mutter sichern. Eventuell mit einer zweiten Kontermutter sichern.

Zur Verbindung mit dem Akkuschrauber die zweite Schraube auch etwas abfeilen und mit der Madenschraube sichern. Der Sechskanntkopf kann damm im Bohrfutter des Akkuschraubers eingespannt werden. Zur besseren Verbindung habe ich noch zwei zusätzliche Muttern bis zum Kopf augeschraubt unf gekonntert.

Zur Verbindung der Adapterplatte mit dem Handrad muss zuerst das Handrad abgeschraubt werden. Dann die Adapterplatte auf der oberen Seite des Handrads platzieren und mit dem Ring auf der unteren Seite fixieren. In die drei Zapfen der Adapterplatt müssen zuvor noch kleine Löcher (2 mm) gebohrt werden. Der Ring wird mit drei kleinen Holz- oder Spax-Schrauben (3 mm) festgeschraubt damit die Adapterplatte fest mit dem Handrad vrbunden ist. Das Handrad mit der Adapterplatte und dem Kardangelenk kann nun auf den Vierkannt des Ventils aufgesteckt werden. Eine Verschraubung des Handrads mit dem Vierkannt ist nicht nötig, da der Abstand durch die spätere Montage des Akkuschrauber fixiert ist.

## Montage des Akkuschraubers

Zur einfachen Montage des Akkuschraubers verwende ich sogenannte [Thermohalter](https://alufensterbaenke.de/thermohalter) für Fensterbänke. 

![Halter](https://alufensterbaenke.de/media/catalog/product/cache/2ad09310492482b8dd76867023a48036/0/1/01_thermohalter_anwendung_mg.jpg)

Der Vorteil dieser Lösung ist der variable Abstand zur Wand, der einfach durch kürzen der Alu-Profile auf die benötigte Länge erfolgt.

Für die Verbindung zwischen Wand und Akkuschrauber werden einfach zwei dieser Halter so ineinander geschoben, dass sich viereckiger Kasten ergibt.
Der Abstand kann durch weniger oder mehr ineinanderschieben verändert werden. Ist der richtige Abstand gefunden, können die Profile mit einer Schraube fixiert werden. Eine Seite reicht dabei.

Für die Montage bleiben die vorbereiteten Profilhälften jedoch noch getrennt. 

Auf der Seite zur Wand werden zwei Löcher in die Alu-Profile gebohrt. Der Durchmesser richtet sich dabei nach den verwendeten Schrauben zur Befestigung in der Wand. 

Beim Profil zum Akkuschrauber wird der Akkuschrauber mit zwei Kabelbindern mit dem Profil befestigt. Das Bild oben zeigt wie es aussehen soll.

Das Bohrfutter des Akkuschraubers wird aufgedreht, sodass dir Sechkannt-Schraubenkopf von der Kardangelenk-Verlängerung locker hineinpasst.

Danach können die Profile ineinandergesteckt werden. Als Nächstes den Akkuschrauber positionieren und das Bohrfutter soweit festschrauben, dass eine sichere Verbinndung gegeben ist. Noch einmal die Achsausrichtung prüfen und eventuell korrigieren. Jetzt können die Bohrstellen mit einem Stift markiert werden.

Dann die Löcher mit einer Bohrmaschine bohren (6 mm sollten  reichen). Dann die Dübel einsetzen und das wandseitige Profil festschrauben. 
Eventuell die Profile dazu wieder trennen.

Jetzt kann alles fertig montiert werden. Dazu das Schrauberseitige Profil aufstecken und im richtigen Abstand einsetig fixieren. Dazu ein Loch durch beide Profilteile bohren und mit einer kleinen Schraube/Mutter fixieren. 

Jetzt sollte alles fertig moniert sein und im Prnzip so wie auf dem Bild oben aussehen.

## Prüfung der Funktion und Einstellung des Drehmoments
Der Akkuschrauber sollte jetzt auf rechtdrehen eingstellt sein. Mit einem Kabelbinder wird nun der Betätigungshebel ca. halb gedrückt befestigt. Die Drehmomenteinstellung wird auf Stellung 1 eingestellt. 

Jetzt die Spannugsverorgung vorbereiten und das 12 Volt Netzteil mit dem Akkuschraube verbinden. Das Netzteil aber noch nicht in die Steckdose einstecken. Ich nutze dazu kleine Krokodilklemmen. Aber auch ein Anlöten der Litzen wäre eine Möglichkeit. Wichtig: Auf die richtige Polarität achten, sonst könnte die Elektronik des Akkuschraubers zerstört werden. Beim Valex Akkuschrauber ist Plus zur Wand hin und Minus vorne.

Im nächsten Schritt wir der Stecker des Netzteils kurz in die Steckdose gesteckt. Der Akkuschrauber sollte sofort beginnen, das Handrad zu drehen. Nach ca 2 Sekunden sillte die Edstellung erreicht sein und die Drehmomentbegrenzung des Akkuschrauber eingreifen, sodass der Schrauber durchdreht. Jetzt kann der Stecker des Netzteil wieder entfernt werden.

Sollte bei Ihrem Ventil mehr Kraft nötig sein, kann die Drehmomenteinstellung erhöht werden. Eventuell muss auch der Kabelbinder beim Betätigungshebel noch weiter gespannt weren. Für die richtige Einstellung ist etwas Fingerspitzengefühl njötig. Ziel ist ein sicheres Abdrehen ohnn dass zu viel unnötige Kraft aufgewendet wird. Die Einschaltzeit kann später im Script angepass werden. Die Voreinstellung ist 3 Sekunden. 

Die Öffnung des Ventils muss manuell erfolgen. Ich hatte erst überlegt, auch eine automatische Öffnung vorzusehen. Da aber beim Verdacht einer Leckage sowiso eine Prüfung vor Ort nötig ist, habe ich mich dagegen etschieden. 

Zum Öffnen des Ventils einfach das Bohrfutter soweit aufdrehen, dass sich das Handrad ohne Widerstand drehen lässt. Dann vollständig aufdrehen und das Bohrfutter wieder festziehen. Das war es schon.

# Software

Die Steuerung des Wasserabschalters erfolgt mit einem Raspberry und zwei Software-Komponenten. Einmal dem Smarthome-System [ioBroker](https://www.iobroker.net/) und zum Zweiten die Software [Zigbee2Mqtt](https://github.com/Koenkk/zigbee2mqtt). ioBroker übernimmt dabei die Automatisierung per Script und Zigbee2mqtt die Anbindung der Ikea Zigbee-Komponenten Tertakt (Schalte) und Bdring (Leckage Detektor).

Viele Make Leser haben eventuell schon eine Smarthome-Lösung auf einem Raspberry im Einsatz. Dann erübrigt sich die Beschreibung zur Installation des Betriebssystems. Trotzdem beschreibe ich hier kurz die vollständige Installation aller drei Komponenten. Rapsberry OS, ioBroker und Zigbee2mqtt.

Übrigens: Falls Nutzer breits bas Smarthome-System Home Assistant nutzen, funktioniert die Steuerung über die Ikea-ZigBee-Komponenten ebenfalls. Auch für Home Assitant ist ein entprechender Adapter für Zigbee2Mqtt verfügbar. Hier wird jedoch die Realisierung mit ioBroker beschrieben.

Für die verlässliche Funktion des Systems ist mindestens eine Raspberry 4 mit 2 GB RAM erforderlich. Ein komplette Bundle ist zum Beispiel [hier](https://www.reichelt.de/de/de/shop/produkt/das_reichelt_raspberry_pi_4_b_2_gb_all-in-bundle-263082?PROVID=2788&gQT=2) verfügbar.



## Installation Raspberry OS und ioBroker
Zur Vorbereitung der Installation benötigen wir zuerst des "Raspberry Pi Imager" der [hier](https://www.raspberrypi.com/software/) zum Download bereitsteht.
Als Betriebssystem für ioBroker empfehele ich die OSLite-Version für den Raspberry ohne grafischen Desktop. Die Bedienung von ioBroker und Zigbee2mqtt erfolgt per Browser. Es funktionieren aber auch andere Versionen des Betriebssystems.

- Rapberry Imager als Administrator starten (zumindest unter Windows 11; ansonsten sperrt der Virenschutz das Kopieren einiger Komponenten)
- 64 Bit OSLite auswählen
- Hostname und Passwort festlegen
- SD-Karte schreiben

- SD-Karte in Raspberry einlegen und starten
- Einloggen. Entweder lokal mit Tastatur und Bildschirm oder per SSH. IP-Adresse über den Router herausfinden! Als SSH-Client empfehle ich [Putty](https://www.putty.org/)

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
