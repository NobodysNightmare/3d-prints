thickness = 6.4;
width = 35;
height = 70;

hookDepth = 40;
hookLength = 25;
hookTipWidth = 4;

hoolaDiameter = 40;

// TODO
screwDiameter = 4;
screwHeadDiameter = 8;
screwHeadHeight = 2;

hookThinning = (width - hookTipWidth) / 2;

$fn = 128;

use <modules/screw-hole.scad>

module hook() {
    base();
    
    translate([thickness, 0, 0])
    curveFit();
    
    singleHook();
    
    translate([thickness + hookDepth, 0, 0])
    singleHook();
}

module base() {
    difference() {
        cube([thickness, height, width]);
        
        translate([thickness, height - 1.5 *  screwHeadDiameter, width / 2])
        rotate([0, 90, 0])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
    }
}

module singleHook() {    
    translate([0, -thickness, 0]) {
        cube([2 * thickness + hookDepth, thickness, width]);
    }
    
    translate([2 * thickness + hookDepth, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(thickness)
    polygon([
        [0, 0],
        [width, 0],
        [width - hookThinning, hookLength],
        [hookThinning, hookLength]
    ]);
}

module curveFit() {
    translate([hoolaDiameter / 2, hoolaDiameter / 2, 0])
    linear_extrude(width)
    difference() {
        translate([-hoolaDiameter / 2, -hoolaDiameter / 2, 0])
        square([hoolaDiameter / 2, hoolaDiameter / 2]);
        
        circle(d=hoolaDiameter);
    }
}

hook();