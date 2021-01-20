columnDiameter = 25;
columnSpacing = 150;

shelfRowDiameter = 25;
shelfRowDepth = 140;
shelfRowStepping = $preview ? 20 : 0.5;

flatRowThickness = 5.5;

screwDiameter = 3.3;
screwHeadDiameter = 6.2;
screwHeadHeight = 1.7;
nutDiameterS = 5.8;
nutHoldThickness = 2;

spoolHeight = 60;

height = flatRowThickness + 2 * spoolHeight + 2 * (shelfRowDiameter / 2);

$fa = $preview ? 2 : 1;
$fs = $preview ? 2 : 1;

use <modules/screw-hole.scad>

module spoolShelf() {
    column();
    
    translate([columnSpacing, 0, 0])
    column();
    
    columnConnector();
    
    translate([0, 0, height - flatRowThickness])
    columnConnector(false);
    
    bottomShelfRow();
    
    translate([0, 0, flatRowThickness + spoolHeight]) {
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

module columnConnector(bottom = true) {
    translate([0, -shelfRowDiameter, 0])
    difference() {
        cube([columnSpacing, shelfRowDiameter, flatRowThickness]);
        
        if(bottom) {
            translate([columnDiameter, shelfRowDiameter / 2, flatRowThickness])
            screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
            
            translate([columnSpacing - columnDiameter, shelfRowDiameter / 2, flatRowThickness])
            screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        } else {
            translate([columnDiameter, shelfRowDiameter / 2, flatRowThickness - nutHoldThickness])
            nutHole(nutDiameterS, screwDiameter);
            
            translate([columnSpacing - columnDiameter, shelfRowDiameter / 2, flatRowThickness - nutHoldThickness])
            nutHole(nutDiameterS, screwDiameter);
        }
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
        
        translate([interpolateShelfRowX(100), -interpolateShelfRowY(100), flatRowThickness])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
    }
}

module bottomShelfRowHalf() {
    linear_extrude(flatRowThickness)
    for(p = [0:shelfRowStepping:100 - shelfRowStepping]) {
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
            translate([interpolateShelfRowX(100), -interpolateShelfRowY(100), nutZOffset])
            nutHole(nutDiameterS, screwDiameter);
        }
    }
}

module shelfRowHalf() {
    translate([0, 0, shelfRowDiameter / 2])
    for(p = [0:shelfRowStepping:100 - shelfRowStepping]) {
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

function interpolateShelfRowX(p) = ((p / 100) * (p / 100)) * columnSpacing / 2;
function interpolateShelfRowY(p) = (p / 100) * shelfRowDepth;

spoolShelf();

/*
// fake spool
translate([columnSpacing / 2, -90, 5.2])
difference() {
    cylinder(55, 103, 103);
    translate([0, 0, -1]) cylinder(60, 52.5 / 2, 52.5 / 2);
}
*/