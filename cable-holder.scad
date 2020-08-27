baseRadius = 50;
baseShrink = 0.4;
armLength = 80;
armWidth = 40;
armStrength = 10;
armRotation = 15;
screwMargin = 10;

module screwHole(headRadius, bodyRadius) {
    length = 100;
    cylinder(length, headRadius, headRadius);
    cylinder(length, bodyRadius, bodyRadius, true, $fn = 16);
}

module holderBase() {
    difference() {    
        scale([1, 1, baseShrink])
            intersection() {
                sphere(baseRadius);
                translate([0, 0, baseRadius])
                    cube(baseRadius * 2, true);
            }
        
        for (rotation = [45:90:315]) {
            rotate([0, 0, rotation])
            translate([baseRadius - screwMargin, 0, 2])
                    screwHole(5, 2);
        }
    }
}

module holderArm() {
    translate([0, baseRadius / 3, baseRadius * baseShrink - 10])
    rotate([-armRotation, 0, 0])
        hull() {
            translate([-(armWidth / 2), 0, 0])
                cylinder(armLength, armStrength / 2, 1.5);
            translate([armWidth / 2, 0, 0])
                cylinder(armLength, armStrength / 2, 1.5);
        }
}

union() {
    holderBase();
    holderArm();
}