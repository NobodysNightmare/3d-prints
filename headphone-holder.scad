thickness = 5;
width = 30;
length = 80;
alignerHeight = 16;
screwPlateWidth = 20;

armRadius = 75;
armWidth = 45;
armRailHeight = 20;
armBBWidth = 30;
armBBHeight = 50;

hookWidth = 10;
hookHeight = 10;

$fa = 4;
$fs = 0.5;  

module screwHole() {
    // 3.0 x 20 mm
    screwRadius = 1.5;
    screwHeadRadius = 3;
    screwHeadHeight = 1.5;
    
    length = 100;
    translate([0, 0, -screwHeadHeight])
        cylinder(screwHeadHeight, screwRadius, screwHeadRadius);
    translate([0, 0, -0.01])
        cylinder(length, screwHeadRadius, screwHeadRadius);
    cylinder(length, screwRadius, screwRadius, true);
}

difference() {    
    cube([thickness + screwPlateWidth, width, thickness]);
    translate([thickness + screwPlateWidth / 2, width / 2, 0])
    rotate([180, 0, 0])
        screwHole();
}
cube([thickness, width, thickness + alignerHeight]);

difference() {
    translate([0, 0, -length])
        cube([thickness, width, length]);
    rotate([0, -90, 0])
    translate([-armRadius - length + thickness, width / 2, 0])
    cylinder(armWidth * 4, armRadius, armRadius, true);
}

// Arm
intersection() {
    rotate([0, -90, 0])
    translate([-armRadius - length + thickness, width / 2, -thickness]) {
        difference() {
            union() {
                cylinder(armWidth + 2 * thickness, armRadius + thickness, armRadius + thickness);
                translate([0, 0, armWidth + thickness])
                cylinder(thickness, armRadius + thickness + armRailHeight, armRadius + thickness + armRailHeight);
            }
            cylinder(armWidth * 4, armRadius, armRadius, true);
        }
    }
    translate([-armWidth - thickness, (width - armBBWidth) / 2, -length - armBBHeight + 2 * thickness + armRailHeight])
        cube([armWidth * 2, armBBWidth, armBBHeight]);
}

// Hook
translate([thickness, (width - thickness) / 2, -length * 0.75]) {
    cube([thickness + hookWidth, thickness, thickness]);
    translate([hookWidth, 0, thickness])
        cube([thickness, thickness, hookHeight]);
}