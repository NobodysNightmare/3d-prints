// This model currently has problems slicing in Prusa Slicer
// Fix: Import in MeshLab, Merge Close Vertices (< 0.01 mm)
//      (fixing non-manifold vertices does not seem to help)

wallThickness = 1.35;
verticalThickness = 1.2;

sensorWidth = 10.8;
sensorLength = 13.8;
sensorArmLength = 10;
sensorThickness = 1.9;
sensorCushion = 10;
sensorGripSize = 1;

sensorLockWidth = 2.5;
sensorLockLead = 1.2;
sensorLockGrip = 0.6;
sensorLockSpacing = 0.4;

apertureWidth = 1.1;
apertureSpacing = 2;
apertureCount = 3;

espBoardTotalLength = 54.6 + 1;
espBoardPCBLength = 48.4 + 0.4;
espBoardWidth = 28.2 + 0.4;
espBoardThickness = 1.5 + 0.3;
espAntennaSideClearance = 4;
espPinHeaderWidth = 2.6 + 0.1;

espMountMainGrip = 4;
espMountGripThickness = 1.5;
espMountCounterSupportWidth = espAntennaSideClearance - espPinHeaderWidth;
espMountLockGrip = 0.4;
espMountLockThickness = 0.6;

displayWidth = 26;
displayHeight = 14;
displayBoardWidth = 27.5 + 0.8;
displayBoardHeight = 28;
displayBoardThickness = 1.2 + 0.4;
displayTotalThickness = 3.8;

displayTopOffset = 5;
displayGrip = displayTopOffset * 0.8;
displaySideGrip = 2.5;

displayTopMargin = 10;
displayBottomMargin = 12;

displayLockWidth = 3.5;
displayLockSpacing = 0.6;
displayLockGrip = wallThickness + displayLockSpacing + displayBoardThickness;
displayLockLead = 1.2 * displayLockGrip;
displayLockTopOffset = 0.5;

usbWidth = 8;
usbHeight = 2.7;
usbZOffset = 0.3;

capTolerance = 0.1;
capRailOffset = 1;
capLockWidth = 4;
capLockLength = 2;
capLockHeight = capTolerance * 2;

pinHeaderWidth = 10 + 1;

espFrontMargin = 3 * wallThickness + displayTotalThickness + displayLockSpacing + 2;

caseHeight = displayHeight + displayTopMargin + displayBottomMargin;
caseWidth = espBoardTotalLength + 2 * wallThickness;
caseDepth = espBoardWidth + espFrontMargin + 2 * wallThickness;

apertureTotalWidth = apertureCount * apertureSpacing;
espMountYOffset = caseDepth - espBoardWidth - wallThickness;
// espMountLift = verticalThickness + sensorLength + 10;
espMountLift = caseHeight - 2 * verticalThickness - 2 * espBoardThickness - espMountGripThickness - espMountLockThickness;

module mainCase() {
    // ceiling
    cube([caseWidth, caseDepth, verticalThickness]);
    
    // right
    difference() {
        cube([wallThickness, caseDepth, caseHeight - verticalThickness]);
        
        translate([0, caseDepth - wallThickness - apertureTotalWidth + apertureWidth / 2, 0])
        for(y = [0:apertureSpacing:apertureTotalWidth - 0.001]) {
            translate([-wallThickness / 2, y, verticalThickness])
            cube([wallThickness * 2, apertureWidth, sensorLength / 2]);
        }
        
        translate([0, espMountYOffset + (espBoardWidth - usbWidth) / 2, espMountLift + espMountGripThickness - usbHeight + usbZOffset])
        cube([wallThickness, usbWidth, usbHeight]);
    }
    
    sensorMount();
    
    translate([wallThickness, espMountYOffset, 0])
    espMount();
    
    // left
    translate([caseWidth - wallThickness, 0, 0])
    cube([wallThickness, caseDepth, caseHeight]);
    
    // front
    frontWall();
    
    // back
    translate([0, caseDepth - wallThickness, 0])
    difference() {
        cube([caseWidth, wallThickness, caseHeight]);
        
        translate([wallThickness + apertureWidth / 2, 0, 0])
        for(x = [0:apertureSpacing:apertureTotalWidth - 0.001]) {
            translate([x, -wallThickness / 2, verticalThickness])
            cube([apertureWidth, wallThickness * 2, sensorLength / 2]);
        }
    }
    
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

module sensorMount() {
    intersection() {
        cube([caseWidth, caseDepth, caseHeight]);
    
        // TODO: I should've been able to properly calculate
        // this based on sensor dimensions
        color("red")
        translate([6, caseDepth - 6, verticalThickness])
        rotate([0, 0, 45])
        translate([-wallThickness - sensorWidth / 2, -wallThickness - sensorThickness / 2, 0]) {
            translate([wallThickness, 2 * wallThickness + sensorThickness, sensorLength / 2])
            cube([sensorWidth, sensorCushion, verticalThickness]);
            
            sensorMountArm();
            
            translate([2 * wallThickness + sensorWidth, 0, 0])
            scale([-1, 1, 1])
            sensorMountArm();
            
            sensorMountLock();
        }
        
    }
}

module sensorMountArm() {
    cube([wallThickness, 2 * wallThickness + sensorThickness, sensorArmLength]);
    
    cube([wallThickness + sensorGripSize, wallThickness, sensorArmLength]);
    
    translate([0, sensorThickness + wallThickness, 0])
    cube([wallThickness + sensorGripSize, wallThickness, sensorArmLength]);
}

module sensorMountLock() {
    translate([0, -sensorLockSpacing, 0])
    rotate([90, 0, 0])
    linear_extrude(sensorLockWidth)
    polygon([
      [0, sensorLength + sensorLockLead],
      [0, 0],
      [wallThickness, 0],
      [wallThickness, sensorLength - sensorLockLead],
      [wallThickness + sensorLockGrip, sensorLength],
      [wallThickness, sensorLength + sensorLockLead]
    ]);
}

module frontWall() {
    difference() {
        cube([caseWidth, wallThickness, caseHeight]);
        
        translate([(caseWidth - displayWidth) / 2, -wallThickness / 2, displayTopMargin])
        cube([displayWidth, wallThickness * 2, displayHeight]);
    }
    
    translate([(caseWidth - displayBoardWidth) / 2, wallThickness, displayTopMargin - verticalThickness - displayTopOffset])    
    difference() {
        union() {
            cube([displayBoardWidth, displayTotalThickness + wallThickness, verticalThickness]);
            
            translate([0, displayTotalThickness - displayBoardThickness - wallThickness, verticalThickness])
            cube([displayBoardWidth, wallThickness, displayGrip]);
            
            translate([0, displayTotalThickness, verticalThickness])
            cube([displayBoardWidth, wallThickness, displayGrip]);
        }
        
        translate([(displayBoardWidth - pinHeaderWidth) / 2, 0, verticalThickness])
        cube([pinHeaderWidth, displayTotalThickness + wallThickness, displayGrip]);
    }
    
    translate([(caseWidth + displayBoardWidth) / 2, wallThickness, 0])
    cube([wallThickness, displayTotalThickness + wallThickness, displayHeight + displayTopMargin]);
    
    translate([(caseWidth + displayBoardWidth) / 2 - displaySideGrip, wallThickness + displayTotalThickness, 0])
    cube([displaySideGrip, wallThickness, displayHeight / 2 + displayTopMargin]);
    
    translate([(caseWidth - displayBoardWidth) / 2 - wallThickness, wallThickness, 0])
    cube([wallThickness, displayTotalThickness + wallThickness, displayHeight + displayTopMargin]);
    
    translate([(caseWidth - displayBoardWidth) / 2, wallThickness + displayTotalThickness, 0])
    cube([displaySideGrip, wallThickness, displayHeight / 2 + displayTopMargin]);
    
    translate([(caseWidth - displayBoardWidth) / 2, 0, 0])
    displayLock();
    
    translate([(caseWidth + displayBoardWidth) / 2 - displayLockWidth, 0, 0])
    displayLock();
}

module displayLock() {
    lockHeight = displayTopMargin - displayTopOffset + displayBoardHeight + displayLockTopOffset;
    
    translate([displayLockWidth, 3 * wallThickness + displayTotalThickness + displayLockSpacing, 0])
    rotate([90, 0, -90])
    linear_extrude(displayLockWidth)
    polygon([
      [0, lockHeight],
      [0, 0],
      [wallThickness, 0],
      [wallThickness, lockHeight - displayLockLead],
      [wallThickness + displayLockGrip, lockHeight]
    ]);
}

module espMount() {
    // main grip
    translate([0, espBoardWidth - espMountMainGrip, espMountLift]) {
        // lower
        cube([espBoardPCBLength, wallThickness + espMountMainGrip, espMountGripThickness]);
        
        // connector between upper and lower
        translate([0, espMountMainGrip, espMountGripThickness])
        cube([espBoardPCBLength, wallThickness, espBoardThickness]);
        
        // right-hand side limiter
        translate([espBoardPCBLength, 0, 0])
        cube([wallThickness, espAntennaSideClearance + wallThickness, 2 * espMountGripThickness + espBoardThickness]);
        
        // left-hand side limiter
        translate([-wallThickness, 0, 0])
        cube([wallThickness, espAntennaSideClearance + wallThickness, 2 * espMountGripThickness + espBoardThickness]);
        
        // left lock
        translate([0, 0, espMountGripThickness + espBoardThickness])
        cube([espMountLockGrip, espMountMainGrip, espMountLockThickness]);
        
        // right lock
        translate([espBoardPCBLength - espMountLockGrip, 0, espMountGripThickness + espBoardThickness])
        cube([espMountLockGrip, espMountMainGrip, espMountLockThickness]);
    }
    
    // counter grip
    translate([0, 0, espMountLift]) {
        // right-hand side limiter
        translate([espBoardPCBLength, 0, 0])
        cube([wallThickness, espAntennaSideClearance + wallThickness, 2 * espMountGripThickness + espBoardThickness]);
            
        // left-hand side limiter
        translate([-wallThickness, 0, 0])
        cube([wallThickness, espAntennaSideClearance + wallThickness, 2 * espMountGripThickness + espBoardThickness]);
        
        // counter support
        translate([0, espPinHeaderWidth, 0])
        cube([espBoardPCBLength, espMountCounterSupportWidth, espMountGripThickness]);
        
        // counter side support
        translate([0, -wallThickness, 0])
        cube([espBoardPCBLength, wallThickness, espMountGripThickness + espBoardThickness]);
        
        // left lock
        translate([0, espPinHeaderWidth, espMountGripThickness + espBoardThickness])
        cube([espMountLockGrip, espMountCounterSupportWidth, espMountLockThickness]);
        
        // right lock
        translate([espBoardPCBLength - espMountLockGrip, espPinHeaderWidth, espMountGripThickness + espBoardThickness])
        cube([espMountLockGrip, espMountCounterSupportWidth, espMountLockThickness]);
    }
    
    // main stand-off
    translate([espBoardPCBLength, espBoardWidth - espMountMainGrip, 0])
    cube([wallThickness, wallThickness + espMountMainGrip, espMountLift]);
    
    // counter stand-off
    translate([espBoardPCBLength, -wallThickness, 0])
    cube([wallThickness, espAntennaSideClearance + 2 * wallThickness, espMountLift + espBoardThickness + espMountGripThickness]);
}

module capRail(length) {
    rotate([90, 0, 90])
    linear_extrude(length)
    polygon([
        [0, verticalThickness],
        [0, 0],
        [capRailOffset, verticalThickness],
        
    ]);
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
    
    translate([topLength - capLockLength - wallThickness - capTolerance, (topWidth - capLockWidth) / 2, verticalThickness])
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
        
        translate([caseWidth / 2, 0, 0])
        cube([caseWidth / 2, caseDepth, caseHeight]);
    }
}

espMount();