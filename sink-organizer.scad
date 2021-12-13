use <MCAD/regular_shapes.scad>

wallThickness = 2.5;
baseThickness = 1.2;
grillTolerance = 0.2;

grillWidth = 80;
grillDepth = 120;
grillHeight = 3;

grillLift = 5;
grillHolderWidth = 5;

bowlHeight = 3;

ragHolderThicknessDepth = 10;
ragHolderThicknessWidth = 6;
ragHolderThicknessHeight = 6;
ragHolderHeight = 160;
ragHolderMargin = 7;

printSupportLength = 20;
printSupportWidth = 0.8;

baseDepth = grillDepth + 2 * wallThickness + 2 * grillTolerance;
baseWidth = 175;
grillMountWidth = grillWidth + 2 * wallThickness + 2 * grillTolerance;

module base() {
    cube([baseWidth, baseDepth, baseThickness]);
    
    grillMount();
    
    translate([baseWidth - grillMountWidth, 0, 0])
    grillMount();
    
    // rag holder
    translate([(baseWidth - ragHolderThicknessWidth) / 2, 0, baseThickness]) {
        cube([ragHolderThicknessWidth, ragHolderThicknessDepth, ragHolderHeight]);
        
        translate([0, baseDepth - ragHolderThicknessDepth, 0])
        cube([ragHolderThicknessWidth, ragHolderThicknessDepth, ragHolderHeight]);
        
        translate([0, ragHolderThicknessDepth, ragHolderHeight - ragHolderThicknessHeight])
        cube([ragHolderThicknessWidth, baseDepth - 2 * ragHolderThicknessDepth, ragHolderThicknessHeight]);
    }
    
    // bowl
    translate([0, 0, baseThickness]) {
        cube([baseWidth, wallThickness, bowlHeight]);
        
        translate([0, baseDepth - wallThickness, 0])
        cube([baseWidth, wallThickness, bowlHeight]);
        
        cube([wallThickness, baseDepth, bowlHeight]);
        
        translate([baseWidth - wallThickness, 0, 0])
        cube([wallThickness, baseDepth, bowlHeight]);
    }
}

module grillMount() {
    translate([wallThickness, 0, baseThickness])
    grillArm();
    
    translate([wallThickness + (grillWidth - grillHolderWidth) / 2, 0, baseThickness])
    grillArm();
    
    translate([wallThickness + grillWidth - grillHolderWidth, 0, baseThickness])
    grillArm();
    
    translate([wallThickness, baseDepth, baseThickness])
    scale([1, -1, 1])
    grillArm();
    
    translate([wallThickness + (grillWidth - grillHolderWidth) / 2, baseDepth, baseThickness])
    scale([1, -1, 1])
    grillArm();
    
    translate([wallThickness + grillWidth - grillHolderWidth, baseDepth, baseThickness])
    scale([1, -1, 1])
    grillArm();
    
    translate([0, wallThickness + (grillDepth + grillHolderWidth) * (1/3), baseThickness])
    rotate([0, 0, -90])
    grillArm();
    
    translate([0, wallThickness + (grillDepth + grillHolderWidth) * (2/3), baseThickness])
    rotate([0, 0, -90])
    grillArm();
    
    translate([grillWidth + 2 * wallThickness + 2 * grillTolerance, wallThickness + (grillDepth - 2 *grillHolderWidth) * (1/3), baseThickness])
    rotate([0, 0, 90])
    grillArm();
    
    translate([grillWidth + 2 * wallThickness + 2 * grillTolerance, wallThickness + (grillDepth - grillHolderWidth) * (2/3), baseThickness])
    rotate([0, 0, 90])
    grillArm();
}

module grillArm() {
    color("red")
    cube([grillHolderWidth, wallThickness, grillLift + grillHeight]);
    
    color("red")
    translate([0, wallThickness, grillLift - wallThickness])
    cushion(grillHolderWidth, wallThickness, wallThickness);
}

module grill() {
    hexGrill(grillWidth, grillDepth, grillHeight, wallThickness, grillDepth / 8);
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

module cushion(thickness, height, width) {
    rotate([90, 0, 90])
    linear_extrude(thickness)
    polygon([
        [0, height],
        [0, 0],
        [width, height],
        
    ]);
}

module testAssembly() {
    base();
    
    translate([wallThickness + grillTolerance, wallThickness + grillTolerance, baseThickness + grillLift])
    grill();
    
    translate([baseWidth - grillMountWidth + wallThickness + grillTolerance, wallThickness + grillTolerance, baseThickness + grillLift])
    grill();
}

base();