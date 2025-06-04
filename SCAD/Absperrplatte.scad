// Runde Grundplatte
highth = 8;
diameter = 50;

// Sechskannt-Aussparung
highth2 = 5.5;
width = 4.9;
hole = 5;

// Zapfen
pin = 10;
hole_distance = 20;
highth3 = 8;



difference(){
    
    cylinder(highth, r1 = diameter/2, r2 = diameter/2, $fn=200);    
    translate ([0, 0, -1]){
    cylinder(highth+2, r1 = hole/2, r2 = hole/2, $fn=200);  
    }
    translate ([0, 0, highth]){
        hexagon(width, highth2, true);
        
    }
}

translate ([0, hole_distance, highth]){
   cylinder(highth3, r1 = pin/2, r2 = pin/2, $fn=200);  
}
   
rotate([0, 0, 120])


translate ([0, hole_distance, highth]){
    cylinder(highth3, r1 = pin/2, r2 = pin/2, $fn=200);  
    
}

rotate([0, 0, 240])

translate ([0, hole_distance, highth]){
    cylinder(highth3, r1 = pin/2, r2 = pin/2, $fn=200);  
}


module hexagon(side, height, center) {
  length = sqrt(3) * side;
  translate_value = center ? [0, 0, 0] :
                             [side, length / 2, height / 2];
  translate(translate_value)
    for (r = [-60, 0, 60])
      rotate([0, 0, r])
        cube([side, length, height], center=true);
}


module hexagon_inscribed(radius, height, center) {
  hexagon(2 * radius / sqrt(3), height, center);
}