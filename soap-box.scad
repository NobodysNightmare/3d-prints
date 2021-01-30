threadWallThickness = 3;
grillThickness = 2;
wallThickness = 8;
verticalThickness = 2;

grillHeight = 2;
boxBottomHeight = 10 + grillHeight + verticalThickness;

innerRadius = 50;
capInnerRadius = innerRadius - 1;

grillHoleSize = 12;
grillGridSize = ceil((2 * innerRadius) / grillHoleSize);

outerRadius = innerRadius + wallThickness;
grillRadius = innerRadius + grillThickness;

threadOuterRadius = outerRadius - threadWallThickness;
threadHeight = 20;
threadPitch = 6;

totalHeight = boxBottomHeight + threadHeight + verticalThickness;

tolerance = 0.2;

$fa = $preview ? 10 : 1;

use <modules/threads.scad>
use <MCAD/regular_shapes.scad>

module soapBox() {
    difference() {
        cylinder(boxBottomHeight, r = outerRadius);
        
        translate([0, 0, verticalThickness])
        cylinder(boxBottomHeight, r = innerRadius);
        
        translate([0, 0, boxBottomHeight - grillHeight - tolerance])
        cylinder(grillHeight + tolerance + 0.01, r = grillRadius + tolerance);
    }
    
    translate([0, 0, boxBottomHeight])
    difference() {
        cylinder(threadHeight, r = outerRadius);
        
        metric_thread(diameter = threadOuterRadius * 2, length = threadHeight, internal = true, pitch = threadPitch, leadin = 1);
    }
}

module soapCap() {
    cylinder(verticalThickness, r = outerRadius);
    
    translate([0, 0, verticalThickness])
    difference() {
        metric_thread(diameter = threadOuterRadius * 2, length = threadHeight - tolerance, internal = false, pitch = threadPitch, leadin = 1);
        
        cylinder(threadHeight, r = capInnerRadius);
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

module testAssemblyCut() {
    difference() {
        union() {
            soapBox();
            
            translate([0, 0, boxBottomHeight - grillHeight])
            soapGrill();

            translate([0, 0, totalHeight + tolerance])
            rotate([180, 0, -55])
            soapCap();
        }
        
        translate([-outerRadius, 0, -tolerance / 2])
        cube([outerRadius * 2, outerRadius, totalHeight + 2 * tolerance]);
    }
}

soapGrill();