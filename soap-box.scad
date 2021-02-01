innerRadius = 45;
threadWallThickness = 3;
floorHeight = 2;
waterCollectorHeight = 10;
chamferSize = 2;

grillThickness = 2;
grillHeight = 2;
grillHoleSize = 12;

threadHeight = 20;
threadPitch = 6;
threadToleranceScaling = 1.006;

capGripHeight = 5;
capGripRecessCount = 15;
capGripRecessRadius = 10;

tolerance = 0.2;

boxBottomHeight = waterCollectorHeight + grillHeight + floorHeight;


grillGridSize = ceil((2 * innerRadius) / grillHoleSize);



outerRadius = innerRadius + threadWallThickness + threadPitch;
grillRadius = innerRadius + grillThickness;

threadOuterRadius = outerRadius - threadWallThickness;

totalHeight = boxBottomHeight + threadHeight + capGripHeight;

$fa = $preview ? 10 : 1;

use <modules/threads.scad>
use <MCAD/regular_shapes.scad>

module soapBox() {
    difference() {
        cylinder(boxBottomHeight, r = outerRadius);
        
        // water collector
        translate([0, 0, floorHeight])
        cylinder(boxBottomHeight, r = innerRadius);
        
        // grill holder
        translate([0, 0, boxBottomHeight - grillHeight - tolerance])
        cylinder(grillHeight + tolerance + 0.01, r = grillRadius + tolerance);
        
        // smoothed bottom edge
        chamfer();
    }
    
    translate([0, 0, boxBottomHeight])
    difference() {
        cylinder(threadHeight, r = outerRadius);
        
        scale([threadToleranceScaling, threadToleranceScaling, 1])
        metric_thread(diameter = threadOuterRadius * 2, length = threadHeight, internal = true, pitch = threadPitch, leadin = 1);
    }
}

module soapCap() {
    difference() {
        cylinder(capGripHeight, r = outerRadius);
        
        for(rotation = [0:360/capGripRecessCount:360]) {
            rotate([0, 0, rotation])
            translate([outerRadius + capGripRecessRadius / 2, 0, -capGripRecessRadius / 2])
            sphere(capGripRecessRadius);
        }
        
        chamfer();
    }
    
    translate([0, 0, capGripHeight])
    difference() {
        metric_thread(diameter = threadOuterRadius * 2, length = threadHeight - tolerance, internal = false, pitch = threadPitch, leadin = 1);
        
        cylinder(threadHeight, r = innerRadius);
    }
}

module soapGrill() {
    linear_extrude(grillHeight)
    difference() {
        circle(grillRadius);
        intersection() {
            circle(innerRadius);
            union() {
                holeYSpacing = grillHoleSize;
                holeXSpacing = grillHoleSize * sqrt(3) / 2;
                for(y = [for(i = [-grillGridSize:grillGridSize]) i * holeYSpacing]) {
                    for(ix = [-grillGridSize:grillGridSize]) {
                        x = ix * holeXSpacing;
                        translate([x, y + (ix % 2 == 0 ? holeYSpacing / 2 : 0)])
                        hexagon(grillHoleSize / 2);
                    }
                }
            }
        }
    }
}

module chamfer() {
    difference() {
        translate([-outerRadius, -outerRadius, 0])
        cube([outerRadius * 2, outerRadius * 2, chamferSize]);
        cylinder(chamferSize, outerRadius - chamferSize / 2, outerRadius + chamferSize / 2);
    }
}

module testAssemblyCut(inspectionRotation = 0) {
    difference() {
        union() {
            soapBox();
            
            translate([0, 0, boxBottomHeight - grillHeight])
            soapGrill();

            translate([0, 0, totalHeight + tolerance])
            rotate([180, 0, -55])
            soapCap();
        }
        
        rotate([0, 0, inspectionRotation])
        translate([-outerRadius, 0, -tolerance / 2])
        cube([outerRadius * 2, outerRadius, totalHeight + 2 * tolerance]);
    }
}

soapBox();