plateThickness = 4;
plateGrillWidth = 2.4;
plateHoleSize = 15;

// pair of two, each having one side of the grill hanging over
plateWidth = (230 / 2) + plateGrillWidth;
plateDepth = 94;

plateLift = 2;
plateHolderHeight = 4.5;
plateHolderInterval = 5;

gripDepth = 1.6;
gripStartWidth = 6;
gripEndWidth = gripStartWidth + 2.4;
gripFrontWiggle = 0.1;
gripSideWiggle = 0.3;
gripOffset = 10;

hookWidth = 6;
hookThickness = 2;
hookGripOpening = 1.8;
hookGripHeight = 30.2;
hookHoldOpening = 8;
hookHoldHeight = 5;

$fa = $preview ? 2 : 0.4;
$fs = $preview ? 2 : 0.4;

use <MCAD/regular_shapes.scad>

module plate() {    
    hexGrill(plateWidth, plateDepth, plateThickness, plateGrillWidth, plateHoleSize);
}

module hexGrill(width, depth, height, thickness, holeSize) {
    linear_extrude(height)
    difference() {
        square([width, depth]);
        intersection() {
            translate([thickness, thickness])
            square([width - 2 * thickness, depth - 2 * thickness]);
            union() {
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

module liftSpacers() {
    cube([plateWidth, plateGrillWidth, plateThickness + plateLift]);
    
    translate([0, plateDepth - plateGrillWidth, 0])
    cube([plateWidth, plateGrillWidth, plateThickness + plateLift]);
}

module plateHolder() {
    for(y = [0:plateHolderInterval * 2:plateDepth]) {
        translate([0, y, 0])
        cube([plateGrillWidth, plateHolderInterval, plateThickness + plateHolderHeight]);
    }
}

module gripInterface() {
    linear_extrude(plateThickness) {
        centerY = plateDepth / 2;
        singleOffset = gripOffset + gripStartWidth / 2;
        difference() {
            square([plateGrillWidth, plateDepth]);
            
            gripInset(singleOffset, plateGrillWidth);
            gripInset(centerY + singleOffset, plateGrillWidth);
        }
        
        gripOutset(plateDepth - singleOffset, plateGrillWidth);
        gripOutset(centerY - singleOffset, plateGrillWidth);
    }
}

// TODO: fix grip inset and outset
module gripInset(insetY, thickness) {    
    polygon([
        [thickness, insetY - gripStartWidth / 2],
        [thickness, insetY + gripStartWidth / 2],
        [thickness - gripDepth, insetY + gripEndWidth / 2],
        [thickness - gripDepth, insetY - gripEndWidth / 2]
    ]);
}

module gripOutset(outsetY, thickness) {
    polygon([
        [thickness, outsetY + gripStartWidth / 2 - gripSideWiggle],
        [thickness, outsetY - gripStartWidth / 2 + gripSideWiggle],
        [thickness + gripDepth - gripFrontWiggle, outsetY - gripEndWidth / 2 + gripSideWiggle],
        [thickness + gripDepth - gripFrontWiggle, outsetY + gripEndWidth / 2 - gripSideWiggle]
    ]);
}

module showerPlate() {
    difference() {
        plate();
        
        translate([plateWidth - plateGrillWidth, 0, 0])
        cube([plateGrillWidth, plateDepth, plateThickness]);
    }
    translate([plateWidth - plateGrillWidth, 0, 0])
    gripInterface();
    
    liftSpacers();
    
    plateHolder();
}

module hook() {
    linear_extrude(hookWidth) {
        square([hookThickness, 2 * hookThickness + hookGripHeight + hookHoldHeight]);
        
        translate([-hookThickness - hookHoldOpening, 0])
        square([hookThickness, hookThickness + hookHoldHeight]);
        
        translate([-hookHoldOpening, 0])
        square([hookHoldOpening, hookThickness]);
        
        translate([hookThickness + hookGripOpening, hookHoldHeight + hookThickness])
        square([hookThickness, hookThickness + hookGripHeight]);
        
        translate([hookThickness, hookHoldHeight + hookGripHeight + hookThickness])
        square([hookGripOpening, hookThickness]);
        
        translate([hookThickness + hookGripOpening / 2, hookHoldHeight])
        square([hookGripOpening / 2 + hookThickness, hookThickness]);
    }
}

module testAssembly() {
    translate([-plateGrillWidth, 0, 0]) {
        showerPlate();
        
        translate([2 * plateWidth, plateDepth, 0])
        rotate([0, 0, 180])
        showerPlate();
    }
}

hook();