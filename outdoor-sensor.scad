layerHeight = 0.3;
wallThickness = 1.5;
verticalThickness = 4 * layerHeight;

espBoardTotalLength = 54.6 + 5.4;
espBoardPCBLength = 48.4 + 0.6;
espBoardWidth = 28.2 + 0.4;
espBoardThickness = 1.5 + 0.3;
espAntennaSideClearance = 4;
espPinHeaderWidth = 2.6 + 0.1;

espMountMainGrip = 4;
espMountGripThickness = 5 * layerHeight;
espMountCounterSupportWidth = espAntennaSideClearance - espPinHeaderWidth;
espMountLockGrip = 0.4;
espMountLockThickness = 2 * layerHeight;
espMountCushionHeight = 5;
espMountCushionWidth = 4;
espMountPillarThickness = 2.4;

sensorHoleDiameter = 5;

sensorMargin = 3;
sensorWidth = 16;
sensorScrewOffset = 30;
sensorThickness = 8;
sensorScrewDiameter = 3;

usbWidth = 8;
usbHeight = 2.7;
usbZOffset = 0.3;

usbCoverHMargin = 2.2;
usbCoverVMargin = 3.2;
usbCoverLength = 5;

capTolerance = 0.2;
capRailOffset = 1;
capLockWidth = 4;
capLockLength = 2;
capLockHeight = 0.6;

screwHeadRadius = 4.5;
screwHeadHeight = 4;
screwRadius = 2;
screwOffset = 8;
screwWallThickness = 2;

screwHoleMargin = 11.5;
screwHoleOffset = 16;

pinHeaderWidth = 10 + 1;

espFrontMargin = 3;

caseHeight = 36;
caseWidth = espBoardTotalLength + 2 * wallThickness;
caseDepth = espBoardWidth + espFrontMargin + 4 * wallThickness;

espMountYOffset = caseDepth - espBoardWidth - 2 * wallThickness;
espMountLift = 11;

$fn = $preview ? 32 : 64;

module mainCase() {
    difference() {
        union() {
            cube([caseWidth, caseDepth, verticalThickness]);
            
            translate([screwHoleMargin, screwHoleOffset, 0])
            screwHoleCase();
            
            translate([caseWidth - screwHoleMargin, screwHoleOffset, 0])
            screwHoleCase();
        }
        
        translate([screwHoleMargin, screwHoleOffset, 0])
        screwHole();
        
        translate([caseWidth - screwHoleMargin, screwHoleOffset, 0])
        screwHole();
    }
    
    // right
    difference() {
        cube([wallThickness, caseDepth, caseHeight - verticalThickness]);
        
        translate([-0.05, espMountYOffset + (espBoardWidth - usbWidth) / 2, espMountLift + espMountGripThickness - usbHeight + usbZOffset])
        cube([wallThickness + 0.1, usbWidth, usbHeight]);
    }
    
    translate([-usbCoverLength, espMountYOffset + espBoardWidth / 2, espMountLift + espMountGripThickness - usbHeight / 2 + usbZOffset])
    usbCover();
    
    translate([wallThickness, espMountYOffset, 0])
    espMount();
    
    // left
    translate([caseWidth - wallThickness, 0, 0])
    cube([wallThickness, caseDepth, caseHeight]);
    
    // front
    frontWall();
    
    // back
    translate([0, caseDepth - wallThickness, 0])
    cube([caseWidth, wallThickness, caseHeight]);
    
    // front rail
    translate([0, wallThickness, caseHeight - verticalThickness]) {
        capRail(caseWidth);
        translate([0, 0, -verticalThickness]) capRail(caseWidth);
    }
    
    // back rail
    translate([0, caseDepth - wallThickness, caseHeight - verticalThickness])
    scale([1, -1, 1]) {
        capRail(caseWidth);
        translate([0, 0, -verticalThickness]) capRail(caseWidth);
    }
    
    // left rail
    translate([caseWidth - wallThickness, 0, caseHeight - verticalThickness])
    rotate(90) {
        capRail(caseDepth);
        translate([0, 0, -verticalThickness]) capRail(caseDepth);
    }
}

module frontWall() {
    difference() {
        cube([caseWidth, wallThickness, caseHeight]);
        
        translate([caseWidth - wallThickness - sensorHoleDiameter / 2, wallThickness / 2, sensorMargin + sensorWidth / 2 + sensorHoleDiameter / 2])
        rotate([90, 0, 0])
        cylinder(d = sensorHoleDiameter, h = wallThickness * 2, center = true);
        
        translate([wallThickness + sensorMargin + sensorScrewOffset, wallThickness / 2, sensorMargin + sensorWidth / 2 + sensorHoleDiameter / 2])
        rotate([90, 0, 0])
        cylinder(d = sensorScrewDiameter, h = wallThickness * 2, center = true);
    }
    
    translate([0, -sensorThickness, 0]) {
        cube([wallThickness, sensorThickness, caseHeight]);
        
        translate([caseWidth - wallThickness, 0, 0])
        cube([wallThickness, sensorThickness, caseHeight]);
        
        translate([0, 0, caseHeight - verticalThickness])
        cube([caseWidth, sensorThickness, verticalThickness]);
        
        translate([(caseWidth - wallThickness) / 2, sensorThickness, caseHeight - verticalThickness - sensorThickness / 2])
        scale([1, -1, 1])
        cushion(wallThickness, sensorThickness / 2, sensorThickness);
    }
}

module espMount() {
    // main grip
    translate([0, espBoardWidth - espMountMainGrip, espMountLift]) {
        // lower
        cube([espBoardPCBLength, wallThickness + espMountMainGrip, espMountGripThickness]);
        
        // middle cushion to support lower from wall
        translate([(espBoardPCBLength - wallThickness) / 2, espMountMainGrip + wallThickness, -espMountCushionHeight])
        scale([1, -1, 1])
        cushion(wallThickness, espMountCushionHeight, wallThickness + espMountMainGrip);
        
        // main support
        translate([0, espMountMainGrip, espMountGripThickness])
        cube([espBoardPCBLength, wallThickness, espBoardThickness]);
        
        // left lock
        translate([0, 0, espMountGripThickness + espBoardThickness])
        cube([espMountLockGrip, espMountMainGrip, espMountLockThickness]);
    }
    
    // counter grip
    translate([0, 0, espMountLift]) {
        // counter support
        translate([0, espPinHeaderWidth, 0]) {
            cube([espBoardPCBLength, espMountCounterSupportWidth, espMountGripThickness]);
            
            // left cushion
            translate([0, espMountCounterSupportWidth, -espMountCushionHeight])
            rotate([0, 0, -90])
            cushion(espMountCounterSupportWidth, espMountCushionHeight, espMountCushionWidth);
            
            // right cushion
            translate([espBoardPCBLength, 0, -espMountCushionHeight])
            rotate([0, 0, 90])
            cushion(espMountCounterSupportWidth, espMountCushionHeight, espMountCushionWidth);
        }
        
        // counter side support
        translate([0, -wallThickness, 0]) {
            cube([espBoardPCBLength, wallThickness, espMountGripThickness + espBoardThickness]);
            
            // left cushion
            translate([0, wallThickness, -espMountCushionHeight])
            rotate([0, 0, -90])
            cushion(wallThickness, espMountCushionHeight, espMountCushionWidth);
            
            // right cushion
            translate([espBoardPCBLength, 0, -espMountCushionHeight])
            rotate([0, 0, 90])
            cushion(wallThickness, espMountCushionHeight, espMountCushionWidth);
        }
        
        // left lock
        translate([0, espPinHeaderWidth, espMountGripThickness + espBoardThickness])
        cube([espMountLockGrip, espMountCounterSupportWidth, espMountLockThickness]);
    }
    
    // main stand-off
    translate([espBoardPCBLength, espBoardWidth - espMountMainGrip, 0])
    cube([espMountPillarThickness, wallThickness + espMountMainGrip, espMountLift + espBoardThickness + 2 * espMountGripThickness]);
    
    // counter stand-off
    translate([espBoardPCBLength, -wallThickness, 0])
    cube([espMountPillarThickness, espAntennaSideClearance + wallThickness, espMountLift + espBoardThickness + 2 * espMountGripThickness]);
    
    // helper for printing, avoiding that the pillar bends over due to
    // the long bridge of the main mount
    translate([espBoardPCBLength + espMountPillarThickness, 0, espMountLift - espMountCushionHeight / 2])
    cube([espBoardTotalLength - espBoardPCBLength - espMountPillarThickness, wallThickness, 2 * layerHeight]);
    
    // counter side center stand-off
    translate([espBoardPCBLength / 2, -wallThickness, 0])
    cube([espMountPillarThickness, wallThickness, espMountLift]);
    
    // counter lower center stand-off
    translate([espBoardPCBLength / 2, espPinHeaderWidth, 0])
    cube([espMountPillarThickness, espMountCounterSupportWidth, espMountLift]);
}

module capRail(length) {
    cushion(length, verticalThickness, capRailOffset);
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

module usbCover() {
    translate([0, -usbCoverHMargin - usbWidth / 2, -verticalThickness - usbCoverVMargin - usbHeight / 2]) {
        cube([usbCoverLength, usbWidth + 2 * usbCoverHMargin, verticalThickness]);
        
        translate([0, 0, verticalThickness + 2 * usbCoverVMargin + usbHeight])
        cube([usbCoverLength, usbWidth + 2 * usbCoverHMargin, verticalThickness]);
        
        translate([0, -wallThickness, 0])
        cube([usbCoverLength, wallThickness, 2 * verticalThickness + 2 * usbCoverVMargin + usbHeight]);
        
        translate([0, usbWidth + 2 * usbCoverHMargin, 0])
        cube([usbCoverLength, wallThickness, 2 * verticalThickness + 2 * usbCoverVMargin + usbHeight]);
        
        translate([usbCoverLength, -wallThickness, -usbCoverLength])
        rotate([0, 0, 90])
        cushion(usbWidth + 2 * usbCoverHMargin + 2 * wallThickness, usbCoverLength, usbCoverLength);
    }
}

module screwHole() {
    startOffset = 1;
    
    translate([0, 0, -startOffset])
    cylinder(startOffset + verticalThickness + screwHeadHeight, screwHeadRadius, screwHeadRadius);
    
    translate([0, 0, verticalThickness])
    hull() {
        cylinder(screwHeadHeight, screwHeadRadius, screwHeadRadius);
        
        translate([0, screwOffset, 0])
        cylinder(screwHeadHeight, screwHeadRadius, screwHeadRadius);
    }
    
    translate([0, 0, -startOffset])
    hull() {
        cylinder(startOffset + verticalThickness + screwHeadHeight, screwRadius, screwRadius);
        
        translate([0, screwOffset, 0])
        cylinder(startOffset + verticalThickness + screwHeadHeight, screwRadius, screwRadius);
    }
}

module screwHoleCase() {        
    hull() {
        cylinder(screwHeadHeight + 2 * verticalThickness, r = screwHeadRadius + wallThickness);
        
        translate([0, screwOffset, 0])
        cylinder(screwHeadHeight + 2 * verticalThickness, r = screwHeadRadius + wallThickness);
    }
}

module bottomCap() {
    topWidth = caseDepth - 2 * (wallThickness + capTolerance);
    topLength = caseWidth - (wallThickness + capTolerance);
    hull() {
        translate([0, 0, verticalThickness - 0.01])
        cube([topLength, topWidth, 0.01]);
        
        translate([capRailOffset, capRailOffset, 0])
        cube([topLength - capRailOffset, topWidth - 2 * capRailOffset, 0.01]);
    }
    
    translate([topLength - capLockLength - wallThickness - 2 * capTolerance, (topWidth - capLockWidth) / 2, verticalThickness])
    cube([capLockLength, capLockWidth, capLockHeight]);
}

module testAssembly() {
    intersection() {
        union() {
            translate([caseWidth, 0, caseHeight])
            rotate([0, 180, 0])
            mainCase();
            
            translate([wallThickness + capTolerance, wallThickness + capTolerance, -capTolerance / 2])
            bottomCap();
        }
        
        translate([0, 0, 0])
        cube([caseWidth, caseDepth / 2, caseHeight]);
    }
}

mainCase();