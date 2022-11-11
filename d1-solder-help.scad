pinDistance = 22.86;
pinThickness = 2.5;
gripWidth = 20;
gripHeight = 5;
groundClearance = 15;

thickness = 1.2;

module solderHelp() {
    linear_extrude(thickness)
    square([pinDistance + pinThickness + 2 * thickness, gripWidth]);
    
    translate([0, 0, thickness]) {
        groundSpacer();
        
        translate([pinDistance, 0, 0])
        groundSpacer();
    }
    
    translate([0, 0, thickness + groundClearance]) {
        grip();
        
        translate([pinDistance, 0, 0])
        grip();
    }
}

module groundSpacer() {
    linear_extrude(groundClearance)
    square([2 * thickness + pinThickness, gripWidth]);
}

module grip() {
    linear_extrude(gripHeight) {
        square([thickness, gripWidth]);
        
        translate([thickness + pinThickness, 0])
        square([thickness, gripWidth]);
    }
}

solderHelp();