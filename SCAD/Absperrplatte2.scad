highth = 8;
diameter = 50;

highth2 = 6;
width = 6.5;

gap = 10;
hole_distance = 20;
highth3 = 8;



difference(){
    
    cylinder(highth, r1 = diameter/2, r2 = diameter/2, $fn=200);    
    hexagon(width, highth2, true);         
}

translate ([0, hole_distance, highth]){
   cylinder(highth3, r1 = gap/2, r2 = gap/2, $fn=200);  
}
   
rotate([0, 0, 120])


translate ([0, hole_distance, highth]){
    cylinder(highth3, r1 = gap/2, r2 = gap/2, $fn=200);  
    
}

rotate([0, 0, 240])

translate ([0, hole_distance, highth]){
    cylinder(highth3, r1 = gap/2, r2 = gap/2, $fn=200);  
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