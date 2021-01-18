columnDiameter = 24;
columnSpacing = 150;

shelfRowDiameter = 24;
shelfRowDepth = 140;
shelfRowStepping = $preview ? 0.2 : 0.1;

bottomShelfRowThickness = 2.4;

screwDiameter = 3.2;
screwHeadDiameter = 6.2;
screwHeadHeight = 1.7;
nutDiameterS = 5.8;
nutHoldThickness = 3;

spoolHeight = 60;

height = bottomShelfRowThickness + 2 * spoolHeight + 2 * (shelfRowDiameter / 2);

$fa = $preview ? 2 : 1;
$fs = $preview ? 2 : 1;

// TODO: add drilling holes towards bottom
// TODO: add stacking method towards top

use <modules/screw-hole.scad>

module spoolShelf() {
    column();
    
    translate([columnSpacing, 0, 0])
    column();
    
    bottomShelfRow();
    
    translate([0, 0, bottomShelfRowThickness + spoolHeight]) {
        shelfRow();
        
        translate([0, 0, spoolHeight + shelfRowDiameter / 2])
        shelfRow(true);
    }
}

module column() {
    linear_extrude(height)
    difference() {
        circle(columnDiameter / 2);
        
        translate([-columnDiameter / 2, 0])
        square([columnDiameter, columnDiameter]);
    }
}

module bottomShelfRow() {
    difference() {
        union() {
            bottomShelfRowHalf();
            
            translate([columnSpacing, 0, 0])
            scale([-1, 1, 1])
            bottomShelfRowHalf();
        }
        
        translate([-shelfRowDiameter / 2, 0, 0])
        cube([columnSpacing + shelfRowDiameter, shelfRowDiameter, shelfRowDiameter]);
        
        translate([interpolateShelfRowX(1), -interpolateShelfRowY(1), bottomShelfRowThickness])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        
        translate([interpolateShelfRowX(0.2), -interpolateShelfRowY(0.2), bottomShelfRowThickness])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        
        translate([columnSpacing, 0, 0])
        scale([-1, 1, 1])
        translate([interpolateShelfRowX(0.2), -interpolateShelfRowY(0.2), bottomShelfRowThickness])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
    }
}

module bottomShelfRowHalf() {
    linear_extrude(bottomShelfRowThickness)
    for(p = [0:shelfRowStepping:1 - shelfRowStepping]) {
        x = interpolateShelfRowX(p);
        y = interpolateShelfRowY(p);
        nx = interpolateShelfRowX(p + shelfRowStepping);
        ny = interpolateShelfRowY(p + shelfRowStepping);

        hull() {
            translate([x, -y, 0])
            circle(shelfRowDiameter / 2);
            
            translate([nx, -ny, 0])
            circle(shelfRowDiameter / 2);
        }
    }
}

module shelfRow(nutHoles = false) {
    difference() {
        union() {
            shelfRowHalf();
            
            translate([columnSpacing, 0, 0])
            scale([-1, 1, 1])
            shelfRowHalf();
        }
        
        translate([-shelfRowDiameter / 2, 0, 0])
        cube([columnSpacing + shelfRowDiameter, shelfRowDiameter, shelfRowDiameter]);
        
        if(nutHoles) {
            nutZOffset = shelfRowDiameter / 2 - nutHoldThickness;
            translate([interpolateShelfRowX(1), -interpolateShelfRowY(1), nutZOffset])
            nutHole(nutDiameterS, screwDiameter);
            
            translate([interpolateShelfRowX(0.2), -interpolateShelfRowY(0.2), nutZOffset])
            nutHole(nutDiameterS, screwDiameter);
            
            translate([columnSpacing, 0, 0])
            scale([-1, 1, 1])
            translate([interpolateShelfRowX(0.2), -interpolateShelfRowY(0.2), nutZOffset])
            nutHole(nutDiameterS, screwDiameter);
        }
    }
}

module shelfRowHalf() {
    translate([0, 0, shelfRowDiameter / 2])
    for(p = [0:shelfRowStepping:1 - shelfRowStepping]) {
        x = interpolateShelfRowX(p);
        y = interpolateShelfRowY(p);
        nx = interpolateShelfRowX(p + shelfRowStepping);
        ny = interpolateShelfRowY(p + shelfRowStepping);
        difference() {
            hull() {
                translate([x, -y, 0])
                sphere(shelfRowDiameter / 2);
                
                translate([nx, -ny, 0])
                sphere(shelfRowDiameter / 2);
            }
            
            translate([-shelfRowDiameter / 2, -shelfRowDepth - shelfRowDiameter / 2, 0])
            cube([columnSpacing, shelfRowDepth + shelfRowDiameter, shelfRowDiameter]);
        }
    }
}

function interpolateShelfRowX(p) = (p * p) * columnSpacing / 2;
function interpolateShelfRowY(p) = p * shelfRowDepth;

spoolShelf();

/*
// fake spool
translate([columnSpacing / 2, -90, 3])
difference() {
    cylinder(55, 103, 103);
    translate([0, 0, -1]) cylinder(60, 52.5 / 2, 52.5 / 2);
}
*/