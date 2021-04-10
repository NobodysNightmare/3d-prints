wallThickness = 1.35;
verticalThickness = 1.2;

tolerance = 0.1;

boardWidth = 54.5;
boardDepth = 28;

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
displayBottomMargin = 10;

displayLockWidth = 3.5;
displayLockSpacing = 0.6;
displayLockGrip = wallThickness + displayLockSpacing + displayBoardThickness;
displayLockLead = 1.2 * displayLockGrip;

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

pinHeaderWidth = 10 + 1;

caseHeight = displayHeight + displayTopMargin + displayBottomMargin;
caseWidth = boardWidth + 2 * wallThickness;
caseDepth = boardDepth + 2 * wallThickness;

apertureTotalWidth = apertureCount * apertureSpacing;

module mainCase() {
    // ceiling
    cube([caseWidth, caseDepth, verticalThickness]);
    
    // right
    difference() {
        cube([wallThickness, caseDepth, caseHeight]);
        
        translate([0, caseDepth - wallThickness - apertureTotalWidth + apertureWidth / 2, 0])
        for(y = [0:apertureSpacing:apertureTotalWidth - 0.001]) {
            translate([-wallThickness / 2, y, verticalThickness])
            cube([wallThickness * 2, apertureWidth, sensorLength / 2]);
        }
    }
    
    sensorMount();
    
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
    lockHeight = displayTopMargin - displayTopOffset + displayBoardHeight;
    
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

module bottomCap() {
    cube([caseWidth - 2 * (wallThickness + tolerance), caseDepth - 2 * (wallThickness + tolerance), verticalThickness]);
}

module testAssembly() {
    intersection() {
        union() {
            translate([caseWidth, 0, caseHeight])
            rotate([0, 180, 0])
            mainCase();
            
            translate([wallThickness + tolerance, wallThickness + tolerance, 0])
            bottomCap();
        }
        
        cube([caseWidth / 2, caseDepth, caseHeight]);
    }
}

mainCase();