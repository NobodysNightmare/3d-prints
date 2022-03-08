cutWidth = 40.4;
cutHeight = 12.504;

coverLength = 50;
coverWidth = 20;
coverHeight = 18;
coverThickness = 0.84;
coverHookLength = 5;
coverHookSpace = 1.2;

module openFrame() {
    difference() {
        union() {
            import("Inkplate_6_Case_Bottom.stl");
            
            translate([2, 32, -11.8])
            color("red")
            cube([100, 82, 1]);
            
            translate([20, 62, -11.8])
            color("green")
            cube([112, 62, 1]);
        }
        
        translate([57.4, 108.595, -15])
        cube([cutWidth, cutHeight, 10]);
        
        translate([30, 100, -10.799])
        cube([30, 21.09, 10]);
        
        translate([100, 100, -10.799])
        cube([30, 21.09, 10]);
        
        translate([3.41, 75, -10.799])
        cube([30, 21.09, 10]);
        
        translate([3.41, 32, -10.799])
        cube([30, 21.09, 10]);
    }
}

module sensorCover() {
    linear_extrude(coverLength)
    difference() {
        square([coverWidth, coverHeight]);
        
        offset(-coverThickness)
        square([coverWidth, coverHeight]);
    }
    
    translate([0, coverHeight, 0])
    cube([coverWidth, coverHookSpace, coverThickness]);
    
    translate([0, coverHeight + coverHookSpace, 0])
    cube([coverWidth, coverThickness, coverThickness + coverHookLength]);
}

sensorCover();