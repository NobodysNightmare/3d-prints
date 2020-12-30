thickness = 3;
width = 8;
length = 20;

$fs = 0.2;

use <modules/screw-hole.scad>

difference() {
    translate([0.4, 0.4, 0])
    scale([0.12, 0.12, 1]) {
        linear_extrude(3)
        import("yoshi-outline.svg");

        linear_extrude(4)
        import("yoshi.svg");
    }
    
    translate([27, 40, 3])
    screwHole(4, 8, 2);
}

translate ([27, 7, 0]) {
    cylinder(length, thickness, thickness);
    translate([0, 0, length - thickness])
    cylinder(thickness, thickness, thickness * 2);
}