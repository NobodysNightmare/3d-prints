// Standing help for an EdgeRouter X

height = 70;
depth = 35;
thickness = 6;

legWidth = 30;
routerThickness = 23;

module stand() {
    linear_extrude(depth) {
        square([thickness, height]);
        
        translate([thickness + routerThickness, 0])
        square([thickness, height]);
        
        translate([thickness, 0])
        square([routerThickness, thickness]);
        
        translate([-legWidth, 0])
        leg();
        
        translate([2* thickness + routerThickness +legWidth, 0])
        scale([-1, 1])
        leg();
    }
}

module leg() {
    square([legWidth, thickness]);
    difference() {
        translate([0, thickness])
        square([legWidth, legWidth]);
        
        translate([0, thickness + legWidth])
        circle(r = legWidth, $fn = 256);
    }
}

stand();