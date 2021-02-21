radius = 50;
thickness = 1;
height = 9;
totalWidth = 18;

totalLength = thickness + height + radius;

$fa = 0.1;
$fs = 0.1;

use <modules/screw-hole.scad>

module wallPiece() {
    difference() {
        cube([totalLength, totalWidth, thickness]);
        
        translate([totalLength / 2, totalWidth / 2, 2])
        screwHole(4.2, 8, 2);
    }
}

difference() {
    union() {
        cube([totalLength, thickness, totalLength]);

        translate([0, totalWidth - thickness, 0])
        cube([totalLength, thickness, totalLength]);
    }
    
    translate([height + radius, totalWidth, height + radius])
    rotate([90, 0, 0])
    cylinder(r = radius, h = totalWidth);
}

wallPiece();

translate([0, 0, totalLength])
rotate([0, 90, 0])
wallPiece();
