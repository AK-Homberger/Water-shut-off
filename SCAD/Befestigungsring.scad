highth = 2;
diameter = 50;
hole_distance = 20;
gap = 3;


difference(){
    
    cylinder(highth, r1 = diameter/2, r2 = diameter/2, $fn=200); 
    
    translate ([0, 0, -1])
    cylinder(highth+2, r1 = diameter/2-10, r2 = diameter/2-10, $fn=200);    
    
    translate ([0, hole_distance, -1]){
    cylinder(highth+2, r1 = gap/2, r2 = gap/2, $fn=200);  
    }
    
    rotate([0, 0, 120])
    translate ([0, hole_distance, -1]){
        cylinder(highth+2, r1 = gap/2, r2 = gap/2, $fn=200);  
  
    }

     rotate([0, 0, 240])
     translate ([0, hole_distance, -1]){
        cylinder(highth+2, r1 = gap/2, r2 = gap      /2, $fn=200);  
    }


}

   

