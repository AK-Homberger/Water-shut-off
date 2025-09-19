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