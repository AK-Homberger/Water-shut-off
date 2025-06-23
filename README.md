# Water leakage shut-off with ZigBee and ioBroker

A water damage following a burst pipe or other leak is always unpleasant. Especially when it happens while you're on vacation and no one notices the damage, but the water just keeps flowing. A simple project to shut off the house's water supply when a leak is detected can help. The detection is done with the Ikea BADRING water detector, and the shutdown is done with a 12-volt cordless screwdriver controlled by an Ikea TRETAKT switch. I implemented the logic and alarm system using the ioBroker smart home system and the ZigBee software Zigbee2MQTT. ioBroker also sends notifications via email and calls to your mobile phone. 

![Shut-off](https://github.com/AK-Homberger/Wasserabschalter/blob/main/Bilder/Aufmacher1.jpg)

# Summary
- Domestic water shut-off via cordless screwdriver with torque adjustment 
- Leakage detection via Ikea ZigBee water detector BADRING 
- Control of the cordless screwdriver via Ikea ZigBee switch TRETAKT 
- Any number of sensors can be integrated 
- Adapter plate for handwheel as 3D printing template (customizable) 
- Cardan joint as axis shift compensation 
- Alerts via email and phone call (requires Fritzbox) 
- Control via script in IoBroker on a Raspberry. 
- ZigBee integration in ioBroker via Zigbee2MQTT. 

# Hardware
For the mechanical shut-off of the domestic water, I use a simple 12-volt hand drill with a torque setting. I had initially considered using a gear motor. But I couldn't find the necessary torque clutch anywhere at a reasonable price. It's standard on cordless drills, however. The [list of parts](https://github.com/AK-Homberger/Wasserabschalter/blob/main/README.md#sources) includes a link to [Amazon](https://www.amazon.de/Akkuschrauber-Lithium-family-tech-112-Valex-1429400/dp/B077YSQW1Z). A simple drill for under €20 is sufficient here.

Here is a short [video](https://www.dropbox.com/scl/fi/2sde03j0u3wew94bmh6hg/Abschalter.mov?rlkey=7kxjaejoa726u7x39rb6fkuw9&dl=0), that shows the function.

The drill is connected to the water valve's handwheel via a universal joint and an adapter plate. The universal joint is designed to compensate for slight axis shifts. It would probably work without this joint as well.

![Adapter](https://github.com/AK-Homberger/Wasserabschalter/blob/main/Bilder/Adapter1.jpg)

The adapter plate and mounting ring are available in the SCAD directory as OpenSCAD and STL files. The adapter plate should fit most handwheels. However, if necessary, the plate can easily be adapted to the current handwheel using OpenSCAD. 

![Adapterplate](https://github.com/AK-Homberger/Wasserabschalter/blob/main/SCAD/Adapterplatte.stl) / ![Ring](https://github.com/AK-Homberger/Wasserabschalter/blob/main/SCAD/Befestigungsring.stl)

### Important! Non-rising spindle
The shutoff only works with valves with a ["non-rising"](https://www.gep24.de/installation/ventile/schraegsitzventil/nicht-steigende-spindel/) spindel. With valves with a "rising" spindle, the handwheel shaft rotates into the valve when shutting off. This would cause the distance to the drill to steadily increase until there is no longer any connection. Therefore, check beforehand whether a valve with a "non-rising" spindle is installed. The valves/upper parts can also be easily replaced. Your local plumber can help with this if necessary.

To easily mount the cordless screwdriver, I use so-called [Thermohalter](https://alufensterbaenke.de/thermohalter) for window sills.

![Halter](https://github.com/AK-Homberger/Wasserabschalter/blob/main/Bilder/Thermohalter.jpg)

Simply slide two of these brackets together to create a square box. The advantage of this solution is the variable distance from the wall, which can be easily adjusted by shortening the aluminum profiles to the required length. 

# Software
The water shut-off switch is controlled using a Raspberry Pi and two software components: the [ioBroker](https://www.iobroker.net/) smart home system and the [Zigbee2Mqtt](https://github.com/Koenkk/zigbee2mqtt) software. ioBroker handles automation via script, and Zigbee2Mqtt connects the Ikea ZigBee components TRETAKT (switch) and BADRING (leakage detector).

For reliable operation of the system, at least a Raspberry 4 with 2 GB of RAM is required. A complete bundle is available [here](https://www.reichelt.de/de/de/shop/produkt/das_reichelt_raspberry_pi_4_b_2_gb_all-in-bundle-263082?PROVID=2788&gQT=2), for example.

## Installing Raspberry OS and ioBroker
To prepare the installation, you first need the "Raspberry Pi Imager," which is available for download [here](https://www.raspberrypi.com/software/).

As the operating system for ioBroker, I recommend the OSLite version for the Raspberry Pi without a graphical desktop. ioBroker and Zigbee2mqtt are operated via a browser. However, other versions of the operating system will also work. 

For easy replication, I've listed all the commands here. They can be copied and pasted into the Raspberry Terminal. 

Before installing the software, the [Sonoff ZigBee-Adapter](https://sonoff.tech/product/gateway-and-sensors/sonoff-zigbee-3-0-usb-dongle-plus-p/) should be plugged into a USB port.

![Sonoff-Dongle](https://github.com/AK-Homberger/Wasserabschalter/blob/main/Bilder/Sonoff-ZigBee-Adapter.jpg)

Important: There are two versions of the ZigBee adapter, SBDongle-P and ZBDongle-E, with different chipsets. For this project, the "P" dongle with the "CC2652P" chipset is required. The other version should also work. However, some configuration settings will need to be changed.
For a better wireless connection, it has proven useful not to plug the dongle directly into the Raspberry, but to place it some distance away from the Raspberry using a USB extension cable.

## Installation

- Start Rapberry Imager as administrator (at least under Windows 11; otherwise, the antivirus will block copying of some components)
- Select 64-bit OSLite
- Set hostname and password
- Select SD card and write image
- Insert SD card into Raspberry and start
- Log in. Either locally with keyboard and screen or via SSH. Find out the IP address via the router! I recommend using [Putty](https://www.putty.org/) as an SSH client.

Update Raspberry OS first:
```
sudo apt update
sudo apt upgrade

sudo raspi-config - Filesystem expand und Logging aus.
```

Install ioBroker with: 
```
curl -sLf https://iobroker.net/install.sh | bash - 
```


Open ioBroker in your browser: http://IP-Adresse:8081

Set basic ioBroker settings. Do not run Discover.

Install the following adapters in ioBroker:
- Email
- Javascript
- Tr-064
- Zigbee2Mqtt

To do this, simply search for the adapter names and install and configure the instance using "Info" (three dots icon) and "+." To change the configuration, go to "Instances" and select the wrench icon.

Configure zigbee2mqtt.0:
For "Websocket IP Address" and "WebUi Address" specify the Raspberry's own IP address (command "ifconfig" helps).
Select "Create a dummy MQTT server for Zigbee2MQTT" and specify port "1887." Leave the other settings as they are and save.

## Installation Zigbee2Mqtt

Detailed information can be found here: https://www.zigbee2mqtt.io/guide/installation/01_linux.html

However, the following commands are sufficient:
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

Adjust the "configuration.yaml" file: 

```
nano /opt/zigbee2mqtt/data/configuration.yaml
```
Insert the following text: 
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
Exit with Ctrl-X and write with "Y".

Test with:
```
pnpm start
```
Cancel execution with Ctrl-C.

Start as a service:

Start the editor and create the file "zigbee2mqtt.service" with the following content.

```
sudo nano /etc/systemd/system/zigbee2mqtt.service
```
Insert the following text: 
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
Exit with Ctrl-X and write with "Y". Due to missing components in my Raspberry version (Bookworm), I had to comment out:
```
#Type=notify
```
and
```
#WatchdogSec=10s
```
Otherwise, starting via Systemctl didn't work properly (crashes). Other users have also encountered this [error](https://github.com/Koenkk/zigbee2mqtt/issues/21463). 

Now start the service and check status. If status OK enable automatic start after re-boot.
```
sudo systemctl start zigbee2mqtt
systemctl status zigbee2mqtt.service
sudo systemctl enable zigbee2mqtt.service
```
Now the Raspberry can be restarted with "sudo reboot".

Open ioBroker in your browser: http://IP-Adresse:8081

Then switch to the Zigbee2MQTT tab and add the [TRETAKT](https://www.zigbee2mqtt.io/devices/E22x4.html#ikea-e22x4) switch and at leats one leakage sensor [BADRING](https://www.zigbee2mqtt.io/devices/E2202.html#ikea-e2202). 

![Tretakt](https://www.zigbee2mqtt.io/images/devices/E22x4.png)
![Badring](https://www.zigbee2mqtt.io/images/devices/E2202.png)

To do this, select "Activate pairing (all)." For the TRETAKT switch, the small button in the recess below the power button must be pressed for approximately 2 seconds to pair. For the BADRING sensor, the pairing button is located under the battery cover. The button must be pressed four times in succession.

The components should now appear in the list.

![Z2M](https://github.com/AK-Homberger/Wasserabschalter/blob/main/Bilder/ioBroker-Zigbee2mqtt.png)

In the next step we create the script to control the cordless screwdriver and for notification.

To do this, select "Scripts" in the ioBroker menu on the left, create a new script with "+" and click "JS" for JavaScript. Name it "Water Switch." Then insert the following text:

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

The unique names of the ZigBee components "Switch" and "Sensor_1/2" still need to be adjusted in the script. The correct names can be found and inserted using the "Insert Object ID" function with the clipboard icon in the top right corner. The "Phone Number" also needs to be adjusted.
Then select "Save." As long as no error messages appear, you can test it. Incidentally, the leak sensor also reacts to wet fingers.
When triggered, the water should be turned off and an email should be sent. If a Fritzbox is present, the phone with the specified number should also ring. If no Fritzbox is present, please comment out the lines "setState("tr-064.0.states.ring", "Telephone number");".

# Sources:

- Raspberry Pi 4 Kit [Reichelt.de](https://www.reichelt.de/de/de/shop/produkt/das_reichelt_raspberry_pi_4_b_2_gb_all-in-bundle-263082)
- SONOFF Zigbee 3.0 USB Dongle [Amazon.com](https://www.amazon.de/SONOFF-Gateway-CC2652P-Assistant-Zigbee2MQTT/dp/B09KXTCMSC)
- Ikea Zigbee switch TRETAKT [Ikea](https://www.ikea.com/de/de/p/tretakt-steckdose-smart-80540349/)
- Ikea Zigbee leakage sensor BADRING [Ikea](https://www.ikea.com/de/de/p/badring-wasserlecksensor-smart-60504352/)
- Valex Akkuschrauber [Amazon.com](https://www.amazon.de/Akkuschrauber-Lithium-family-tech-112-Valex-1429400/dp/B077YSQW1Z)
- Thermohalter (2 pieces) [Alufensterbaenke.de](https://alufensterbaenke.de/thermohalter)
- Cardan joint [Amzon.com](https://www.amazon.de/bis-Durchmesser-drehbar-Kardangelenk-RC-Modellflugzeug/dp/B00O9YGCKU)
- 12 Volt 10 A Trafo [Amazon.com](https://www.amazon.de/Netzteil-Spannungswandler-Netzadapter-Transformator-Stromversorgung-schwarz/dp/B0D9S8N8TT)
- Clips [Amazon.com](https://www.amazon.de/Multimeter-Messleitungen-Bananenstecker-Krokodilklemme-Messspitzen/dp/B0D39WQZ9M)
