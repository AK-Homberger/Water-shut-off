# Wasserabschalter mit Zigbee und ioBroker

Dieses Repository enthält zusätzliche Informationen zum Wasserabschalter aus dem Ikea-Sonderheft der Zeitschrift Make. 

Ein Wasserschaden nach einem Rohrbruch oder einer anderen Leckage ist immer eine unangenehme Sache. Speziell wenn dies im Urlaub passiert und niemand den Schaden bemerkt, und das Wasser einfach weiter fließt. Abhilfe schafft hier ein einfaches Projekt zur Abschaltung des Hauswasseranschlusses beim Erkennen einer Leckage. Die Erkennung erfolgt mit dem Ikea Wasserdetektor Badring und die Abschaltung erfolgt mit einem 12 Volt-Akkuschrauber, der über einen Ikea Schalter Tretakt geschaltet wird. Die Logik und Alarmierung habe ich mit dem Smarthome-System ioBroker und dem ZigBee-Modul Zigbee2MQTT realisiert. Mittels ioBroker erfolgt auch die Benachrichtigung per E-Mail und der Anruf auf das Mobiltelefon. Somit steht einem entspannten Urlaub nichts mehr im Wege.

![Abschalter](https://github.com/AK-Homberger/Wasserabschalter/blob/main/Bilder/Aufmacher1.png)

# Installation ioBroker

- Rapberry Imager als Administrator starten
- 64 Bit OSLite auswählen
- Hostname und Passwort festlegen
- SD-Karte schreiben

- SD-Karte in Raspberry einlegen und starten
- Einloggen (SSH)

sudo apt update
sudo apt upgrade

sudo raspi-config - Filesystem expand unf Logging aus.

ioBroker mit : 
	curl -sLf https://iobroker.net/install.sh | bash -
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

sudo curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs git make g++ gcc libsystemd-dev
sudo npm install -g pnpm

sudo mkdir /opt/zigbee2mqtt
sudo chown -R ${USER}: /opt/zigbee2mqtt

git clone --depth 1 https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt

cd /opt/zigbee2mqtt
pnpm i --frozen-lockfile

Testen mit: pnpm start

Start als Service:

sudo nano /etc/systemd/system/zigbee2mqtt.service

------
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
-------

sudo systemctl start zigbee2mqtt

systemctl status zigbee2mqtt.service

sudo systemctl enable zigbee2mqtt.service





