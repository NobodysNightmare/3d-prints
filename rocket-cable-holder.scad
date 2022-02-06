printThickness = 2.2;

plateHeight = 21;
plateDepth = 135;
plateWidth = 147;

storageHeight = 15;
cableClearance = 10;

lipHeight = 20;
gripWidth = 12;

lipHoleSize = lipHeight + 2 * printThickness;
bottomHoleSize = 30;
sideHoleSize = 23;

totalInnerHeight = plateHeight + storageHeight +  printThickness;

use <MCAD/regular_shapes.scad>

module cableHolder() {
    hexGrill(plateWidth + 2 * printThickness, lipHeight + printThickness, printThickness, printThickness, lipHoleSize);
    
    cube([gripWidth + printThickness, printThickness, plateDepth]);
    
    translate([plateWidth - gripWidth + printThickness, 0, 0])
    cube([gripWidth + printThickness, printThickness, plateDepth]);
    
    translate([0, -printThickness - plateHeight, 0]) {
        difference() {
            cube([gripWidth + printThickness, printThickness, plateDepth]);
            
            translate([0, printThickness, 0])
            rotate([90, 0, 0])
            translate([printThickness, 0, 0])
            linear_extrude(printThickness)
            polygon([
                [0, 0],
                [gripWidth, 0],
                [gripWidth, cableClearance + 2 * gripWidth],
                [0, cableClearance]
            ]);
        }
        
        translate([plateWidth - gripWidth + printThickness, 0, 0])
        cube([gripWidth + printThickness, printThickness, plateDepth]);
    }
    
    translate([0, -totalInnerHeight, 0])
    rotate([90, 0, 90])
    hexGrill(totalInnerHeight, plateDepth, printThickness, printThickness, sideHoleSize);
    
    translate([plateWidth + printThickness, -totalInnerHeight, 0])
    difference() {
        union() {
            rotate([90, 0, 90])
            hexGrill(totalInnerHeight, plateDepth, printThickness, printThickness, sideHoleSize);
            
            cube([printThickness, storageHeight + printThickness, cableClearance + printThickness]);
        }
        
        cube([printThickness, storageHeight, cableClearance]);
    }
    
    translate([0, -totalInnerHeight + printThickness, 0])
    rotate([90, 0, 0])
    hexGrill(plateWidth + 2 * printThickness, plateDepth, printThickness, printThickness, bottomHoleSize);
}

module hexGrill(width, depth, height, thickness, holeSize) {
    linear_extrude(thickness)
    difference() {
        square([width, depth]);
        intersection() {
            translate([thickness, thickness])
            square([width - 2 * thickness, depth - 2 * thickness]);
            union() {
                // TODO: configurable width of grill pieces
                holeYSpacing = thickness + holeSize * sqrt(3) / 2;
                holeXSpacing = thickness + 0.75 * holeSize;
                grillGridXSize = ceil(width / holeSize) + 1;
                grillGridYSize = ceil(depth / holeSize) + 1;
                for(y = [for(i = [-grillGridYSize:grillGridYSize]) i * holeYSpacing]) {
                    for(ix = [-grillGridXSize:grillGridXSize]) {
                        x = ix * holeXSpacing;
                        translate([x, y + (ix % 2 == 0 ? holeYSpacing / 2 : 0)])
                        hexagon(holeSize / 2);
                    }
                }
            }
        }
    }
}

cableHolder();