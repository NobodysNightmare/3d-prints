outerRadius = 50;
innerRadius = 24;
baseStrength = 6;
armWidth = 30;
armRail = 15;
railSteepness = 0.8;
armStrength = 3;

screwRadius = 2;
screwHeadRadius = 4;
screwHeadHeight = 2;

$fa = 4;
$fs = 0.5;

use <modules/nn-logo.scad>;

module screwHole() {
    length = 100;
    translate([0, 0, -screwHeadHeight])
        cylinder(screwHeadHeight, screwRadius, screwHeadRadius);
    translate([0, 0, -0.01])
        cylinder(length, screwHeadRadius, screwHeadRadius);
    cylinder(length, screwRadius, screwRadius, true);
}

module holderBase() {
    difference() {    
        cylinder(baseStrength, outerRadius, outerRadius);
        translate([0, 0, -baseStrength / 2])
            cylinder(baseStrength * 2, innerRadius, innerRadius);
        
        for (rotation = [45:90:315]) {
            rotate([0, 0, rotation])
            translate([(2 * outerRadius + innerRadius) / 3, 0, baseStrength])
                    screwHole();
        }
    }
}

module holderArm() {
    difference() {
        length = baseStrength + armWidth;
        armRadius = innerRadius + armStrength;
        railRadius = armRadius + armRail;
        union() {
            cylinder(length, armRadius, armRadius);
            translate([0, 0, length]) {
                cylinder(armRail * railSteepness, armRadius, railRadius);
                translate([0, 0, armRail * railSteepness])
                cylinder(armStrength / 2, railRadius, railRadius);
            }
        }
        translate([0, 0, -length / 2])
            cylinder(length * 2, innerRadius, innerRadius);
        translate([-outerRadius, -outerRadius, 0])
            cube([outerRadius * 2, outerRadius, outerRadius * 2]);
        
        // screw holes aligned with holder base
        for (rotation = [45:90:315]) {
            rotate([0, 0, rotation])
            translate([(2 * outerRadius + innerRadius) / 3, 0, 2])
                    screwHole();
        }
    }
}


union() {
    holderBase();
    holderArm();
    nnLogo(39.6, baseStrength / 2);
}