columnDiameter = 24;
columnSpacing = 150;

shelfRowDiameter = 24;
shelfRowDepth = 140;
shelfRowStepping = $preview ? 0.2 : 0.1;

bottomShelfRowThickness = 2;

spoolHeight = 60;

height = bottomShelfRowThickness + 2 * spoolHeight + 2 * (shelfRowDiameter / 2);

$fa = $preview ? 2 : 1;
$fs = $preview ? 2 : 1;

// TODO: add drilling holes towards bottom
// TODO: add stacking method towards top

module spoolShelf() {
    column();
    
    translate([columnSpacing, 0, 0])
    column();
    
    bottomShelfRow();
    
    translate([0, 0, bottomShelfRowThickness + spoolHeight]) {
        shelfRow();
        
        translate([0, 0, spoolHeight + shelfRowDiameter / 2])
        shelfRow();
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

module shelfRow() {
    difference() {
        union() {
            shelfRowHalf();
            
            translate([columnSpacing, 0, 0])
            scale([-1, 1, 1])
            shelfRowHalf();
        }
        
        translate([-shelfRowDiameter / 2, 0, 0])
        cube([columnSpacing + shelfRowDiameter, shelfRowDiameter, shelfRowDiameter]);
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