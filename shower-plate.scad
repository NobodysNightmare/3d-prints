plateWidth = 174;
plateDepth = 120;
plateThickness = 5;
plateGrillWidth = 2;
plateHoleSize = 15;

hookBaseSize = 15;
hookWidth = 10;
hookStrength = 3;
hookWallDistance = 50;
hookTopOverhang = 5;

// distance between upper end of plate and upper end of
// pipes
plateHeight = 30;

pipeDiameter = 30;
pipeDistance = 150;

hookOuterDiameter = pipeDiameter + 2 * hookStrength;

$fa = $preview ? 2 : 0.4;
$fs = $preview ? 2 : 0.4;

use <MCAD/regular_shapes.scad>

module plate() {
    linear_extrude(plateThickness)
    difference() {
        square([plateWidth, plateDepth]);
        intersection() {
            translate([plateGrillWidth, plateGrillWidth])
            square([plateWidth - 2 * plateGrillWidth, plateDepth - 2 * plateGrillWidth]);
            union() {
                // TODO: configurable width of grill pieces
                holeYSpacing = plateHoleSize;
                holeXSpacing = plateHoleSize * sqrt(3) / 2;
                grillGridSize = ceil(plateWidth / plateHoleSize) + 1;
                for(y = [for(i = [-grillGridSize:grillGridSize]) i * holeYSpacing]) {
                    for(ix = [-grillGridSize:grillGridSize]) {
                        x = ix * holeXSpacing;
                        translate([x, y + (ix % 2 == 0 ? holeYSpacing / 2 : 0)])
                        hexagon(plateHoleSize / 2);
                    }
                }
            }
        }
    }
}

module pipeHook() {
    translate([0, hookWallDistance, hookOuterDiameter / 2 + plateHeight - hookStrength])
    rotate([-90, 0, 0])
    linear_extrude(hookWidth) {
        difference() {
            circle(d = hookOuterDiameter);
            circle(d = pipeDiameter);
            
            translate([hookStrength / 2, -hookOuterDiameter / 2 - hookTopOverhang])
            square([hookOuterDiameter, hookOuterDiameter]);
        }
        
        translate([-hookStrength / 2, pipeDiameter / 2])
        square([hookStrength, plateHeight]);
    }
    
    translate([-hookBaseSize / 2, hookWallDistance + hookWidth / 2 - hookBaseSize / 2, 0])
    cube([hookBaseSize, hookBaseSize, plateThickness]);
}

module frontHook() {
    translate([plateWidth / 2, plateDepth - 30])
    cube([40, 20, 20]);
}

module showerPlate() {
    plate();
    
    translate([(plateWidth + pipeDistance) / 2, 0, 0])
    pipeHook();
    
    translate([(plateWidth - pipeDistance) / 2, 0, 0])
    scale([-1, 1, 1])
    pipeHook();
    
    frontHook();
}

showerPlate();