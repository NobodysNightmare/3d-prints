baseWidth = 130;
depth = 80;
extensionWidth = depth / 4;
roundness = 5;

shellThickness = 3;
airgapHeight = 3;
airgapWidth = 10;

basinClearance = airgapHeight + 1;
basinMinThickness = 2;
basinHeightDifference = 5;

cushions = 3;
cushionWidth = 4;
cushionMargin = 5;
sideCushionOffset = roundness / 10; // TODO: this should be calculated

drainDiameter = 8;
drainThickness = 2;
drainLength = 26;
drainCutAngle = 45;
drainRounding = drainThickness / 5;

grillTolerance = 0.2;
grillFrameThickness = 3;
grillThickness = 2;
grillHeight = 5;
grillScale = 10;
grillClearance = 4;

extensionAngle = 90 - atan(extensionWidth / (depth / 2));
extensionEdgeLength = sqrt(extensionWidth^2 + (depth / 2)^2);

basinBaseHeight = basinClearance + basinMinThickness;
height = basinBaseHeight + max(basinHeightDifference, drainDiameter) + grillClearance + grillHeight;
grillTileW = (baseWidth + 2 * extensionWidth) / grillScale;
grillTileH = depth / grillScale;
grillTileXOffset = grillThickness / sin(extensionAngle) + grillThickness / tan(extensionAngle);
grillTileXSpacing = grillTileXOffset + grillTileW + baseWidth / grillScale;
grillTileYSpacing = grillThickness / 2 + grillTileH / 2;
activeXAlign = grillTileXOffset / 2 + grillTileW - extensionWidth / grillScale;

$fn = $preview ? 32 : 256;

// -------- Holder ------------

module holder() {
    shell();
    basin();
    allCushions();
    drain();
}

module shell() {
    difference() {
        linear_extrude(height)
        difference() {
            offset(shellThickness)
            baseShape();
            
            baseShape();
        }
        
        translate([baseWidth / 2, 0.01, drainDiameter / 2 + basinBaseHeight])
        rotate([90, 0, 0])
        cylinder(h = shellThickness * 2, d = drainDiameter);
        
        rotate([0, 0, -extensionAngle])
        translate([-extensionEdgeLength / 2, 0, 0])
        airgap();
        
        translate([baseWidth, 0, 0])
        rotate([0, 0, extensionAngle])
        translate([extensionEdgeLength / 2, 0, 0])
        airgap();
        
        translate([0, depth, 0])
        rotate([0, 0, 180 + extensionAngle])
        translate([extensionEdgeLength / 2, 0, 0])
        airgap();
        
        translate([baseWidth, depth, 0])
        rotate([0, 0, 180 - extensionAngle])
        translate([-extensionEdgeLength / 2, 0, 0])
        airgap();
    }
}

module airgap() {
    translate([0, 0.01, 0])
    rotate([90, 0, 0])
    linear_extrude(2 * shellThickness)
    hull() {
        translate([airgapWidth / 2, 0])
        circle(r = airgapHeight);
        
        translate([-airgapWidth / 2, 0])
        circle(r = airgapHeight);
    }
}

module basin() {
    intersection() {
        union() {
            translate([-extensionWidth, 0, basinClearance])
            basinFloorPiece(baseWidth + 2 * extensionWidth, depth);
            
            translate([baseWidth / 2, 0, basinClearance])
            rotate([0, 0, 90])
            basinFloorPiece(depth, baseWidth / 2 + extensionWidth);
            
            translate([baseWidth / 2, depth, basinClearance])
            rotate([0, 0, -90])
            basinFloorPiece(depth, baseWidth / 2 + extensionWidth);
        }
        
        linear_extrude(height)
        baseShape();
    }
}

module basinFloorPiece(width, depth) {
    rotate([90, 0, 90])
    linear_extrude(width)
    polygon([
        [0, 0],
        [depth, 0],
        [depth, basinMinThickness + basinHeightDifference],
        [0, basinMinThickness]
    ]);
}

module allCushions() {
    for(i =[0:cushions - 1])
    translate([cushionMargin + i * (baseWidth - cushionWidth - 2 * cushionMargin) / (cushions - 1), 0, 0])
    cushion();
    
    for(i =[0:cushions - 1])
    translate([cushionMargin + cushionWidth + i * (baseWidth - cushionWidth - 2 * cushionMargin) / (cushions - 1), depth, 0])
    rotate([0, 0, 180])
    cushion();
    
    translate([-extensionWidth + sideCushionOffset, (depth + cushionWidth) / 2, 0])
    rotate([0, 0, -90])
    cushion();
    
    translate([baseWidth + extensionWidth - sideCushionOffset, (depth - cushionWidth) / 2, 0])
    rotate([0, 0, 90])
    cushion();
}

module cushion() {
    translate([0, 0, height - grillHeight - grillFrameThickness - grillTolerance])
    rotate([90, 0, 90])
    linear_extrude(cushionWidth)
    polygon([
        [0, 0],
        [grillFrameThickness, grillFrameThickness],
        [0, grillFrameThickness]
    ]);
}

module drain() {
    translate([baseWidth / 2, -shellThickness, drainDiameter / 2 + basinBaseHeight])
    rotate([90, 0, 0])
    difference() {
        linear_extrude(drainLength)
        offset(drainRounding)
        offset(-drainRounding)
        difference() {
            circle(d = drainDiameter + 2 * drainThickness);
            circle(d = drainDiameter);
            
            cutWidth = drainDiameter + 2 * drainThickness;
            translate([-cutWidth / 2, 0])
            square(cutWidth);
        }
        
        cutSize = drainLength * 2;
        
        translate([-cutSize / 2, -drainDiameter / 2 - drainThickness, drainLength])
        rotate([-drainCutAngle, 0, 0])
        cube([cutSize, cutSize, cutSize]);
    }
}

// -------- Grill ------------

module grill() {
    linear_extrude(grillHeight)
    grillShape();
}

module grillShape() {
    difference() {
        offset(-grillTolerance)
        baseShape();
        
        offset(-grillFrameThickness)
        baseShape();
    }
    
    difference() {
        offset(-grillTolerance)
        baseShape();
        
        translate([-grillTileXSpacing * 3, -grillTileYSpacing * 3])
        for(iy = [1:2 * grillScale])
        for(ix = [1:grillScale]) {
            xAlign = (iy % 2) == 0 ? 0 : activeXAlign;
            translate([xAlign + ix * grillTileXSpacing, iy * grillTileYSpacing])
            scale([1 / grillScale, 1 / grillScale])
            baseShape();
        }
    }
}

module baseShape() {
    offset(roundness)
    offset(-roundness)
    polygon([
        [0, 0],
        [baseWidth, 0],
        [baseWidth + extensionWidth, depth / 2],
        [baseWidth, depth],
        [0, depth],
        [-extensionWidth, depth / 2],
    ]);
}

module testAssembly() {
    holder();
    
    translate([0, 0, height - grillHeight])
    grill();
}

module printLayout() {
    holder();
    
    translate([0, depth + 10, 0])
    grill();
}

printLayout();