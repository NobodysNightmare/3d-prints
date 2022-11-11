height = 4;
thickness = 5;
diameter = 25;
gripDistance = 22;

handleLength = 50;
handleWidth = 14;

$fa = 0.2;
$fs = 0.2;

module tool() {
    linear_extrude(height) {
        toolHead();
        
        translate([0, diameter / 2])
        toolHandle();
    }
}

module toolHead() {
    difference() {
        offset(thickness)
        circle(d = diameter);
        
        circle(d = diameter);
    }
    
    intersection() {
        union() {
            translate([(diameter + gripDistance) / 2, 0])
            square([diameter, diameter], center = true);
            
            translate([-(diameter + gripDistance) / 2, 0])
            square([diameter, diameter], center = true);
        }
        
        offset(4)
        circle(d = diameter);
    }
}

module toolHandle() {
    hull() {
        translate([0, 0.1])
        square([handleWidth, 0.1], center = true);
        
        translate([0, handleLength])
        circle(d = handleWidth);
    }
}

tool();