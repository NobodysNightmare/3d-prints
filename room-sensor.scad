layerHeight = 0.3;
wallThickness = 1.5;
verticalThickness = 4 * layerHeight;

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

isolationWallThickness = 6;
isolationWallOpeningWidth = 5;
isolationWallOpeningHeight = 11;
isolationWallInnerWall = 0.5;
isolatedSensorSpaceInnerWidth = 21.5;
isolatedSensorSpaceTotalWidth = isolationWallThickness + isolatedSensorSpaceInnerWidth;

apertureWidth = 1.1;
apertureSpacing = 2;
apertureCount = 3;

espBoardTotalLength = 54.6 + 5;
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

ventilationHeight = 2.4;

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

capTolerance = 0.2;
capRailOffset = 1;
capLockWidth = 4;
capLockLength = 2;
capLockHeight = 0.6;

pinHeaderWidth = 10 + 1;

espFrontMargin = 3 * wallThickness + displayTotalThickness + displayLockSpacing + 3;

caseHeight = displayHeight + displayTopMargin + displayBottomMargin;
caseWidth = espBoardTotalLength + 2 * wallThickness + isolatedSensorSpaceTotalWidth;
caseDepth = espBoardWidth + espFrontMargin + 4 * wallThickness;

apertureTotalWidth = apertureCount * apertureSpacing;
espMountYOffset = caseDepth - espBoardWidth - 2 * wallThickness;
espMountLift = caseHeight - 2 * verticalThickness - 2 * espBoardThickness - espMountGripThickness - espMountLockThickness;

bottomVentilationZOffset = caseHeight - 2 * verticalThickness - ventilationHeight;

module mainCase() {
    // ceiling
    cube([caseWidth, caseDepth, verticalThickness]);
    
    // right
    difference() {
        cube([wallThickness, caseDepth, caseHeight - verticalThickness]);
        
        translate([0, espMountYOffset + (espBoardWidth - usbWidth) / 2, espMountLift + espMountGripThickness - usbHeight + usbZOffset])
        cube([wallThickness + 0.1, usbWidth, usbHeight]);
    }
    
    translate([espBoardTotalLength + wallThickness, 0, 0])
    isolatedSensorSpace();
    
    translate([caseWidth, 0, 0])
    scale([-1, 1, 1])
    sensorMount();
    
    translate([wallThickness, espMountYOffset, 0])
    espMount();
    
    // left
    translate([caseWidth - wallThickness, 0, 0])
    difference() {
        cube([wallThickness, caseDepth, caseHeight]);
        
        translate([0, caseDepth - wallThickness - apertureWidth / 2, verticalThickness])
        rotate([0, 0, -90])
        ventilationSlots(apertureTotalWidth, sensorLength / 2);
    }
    
    // front
    frontWall();
    
    // back
    translate([0, caseDepth - wallThickness, 0])
    difference() {
        cube([caseWidth, wallThickness, caseHeight]);
        
        translate([caseWidth - apertureTotalWidth - apertureWidth / 2, 0, verticalThickness])
        ventilationSlots(apertureTotalWidth, sensorLength / 2);
        
        translate([wallThickness, 0, bottomVentilationZOffset])
        ventilationSlots(espBoardPCBLength, ventilationHeight);
        
        translate([wallThickness, 0, verticalThickness])
        ventilationSlots(espBoardPCBLength, ventilationHeight);
        
        translate([caseWidth - isolatedSensorSpaceInnerWidth, 0, bottomVentilationZOffset])
        ventilationSlots(isolatedSensorSpaceInnerWidth - 2 * wallThickness, ventilationHeight);
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
        translate([6.5, caseDepth - 6.5, verticalThickness])
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
        cube([espBoardPCBLength, espMountCounterSupportWidth, espMountGripThickness]);
        
        // middle cushion to support lower from wall
        translate([(espBoardPCBLength - wallThickness) / 2, espMountMainGrip + wallThickness, -espMountCushionHeight])
        scale([1, -1, 1])
        cushion(wallThickness, espMountCushionHeight, wallThickness);
        
        // main support
        translate([0, espMountMainGrip, 0])
        cube([espBoardPCBLength, wallThickness, espMountGripThickness + espBoardThickness]);
        
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
    // aligning with display lock to avoid blocking cable flow
    translate([espBoardPCBLength / 2, -wallThickness, 0])
    cube([espMountPillarThickness, wallThickness, espMountLift]);
    
    // counter lower center stand-off
    // aligning with display lock to avoid blocking cable flow
    translate([espBoardPCBLength / 2, espPinHeaderWidth, 0])
    cube([espMountPillarThickness, espMountCounterSupportWidth, espMountLift]);
    
    // main lower center stand-off
    translate([espBoardPCBLength / 2, espBoardWidth - espPinHeaderWidth - espMountCounterSupportWidth, 0])
    cube([espMountPillarThickness, espMountCounterSupportWidth, espMountLift]);
}

module isolatedSensorSpace() {
    difference() {
        union() {
            cube([wallThickness, caseDepth, caseHeight - verticalThickness]);
            
            translate([(isolationWallThickness - isolationWallInnerWall) / 2, 0, 0])
            cube([isolationWallInnerWall, caseDepth, caseHeight - verticalThickness]);
            
            translate([isolationWallThickness - wallThickness, 0, 0])
            cube([wallThickness, caseDepth, caseHeight - verticalThickness]);
            
            translate([0, 0, caseHeight - verticalThickness - 2 * layerHeight])
            cube([isolationWallThickness, caseDepth, 2 * layerHeight]);

            // walls around opening
            intersection() {
                minkowski() {
                    isolationWallOpeningCube();
                    cube([1, wallThickness * 2, verticalThickness + 2 * layerHeight], center = true);
                }
                
                cube([isolationWallThickness, caseDepth, caseHeight - verticalThickness]);
            }
        }
        
        isolationWallOpeningCube();
    }
}

module isolationWallOpeningCube() {
    translate([0, caseDepth - espBoardWidth - 2 * wallThickness - isolationWallOpeningWidth, caseHeight - isolationWallOpeningHeight - verticalThickness - 2 * layerHeight])
        cube([isolationWallThickness, isolationWallOpeningWidth, isolationWallOpeningHeight]);
}

module ventilationSlots(width, height) {
    for(x = [0:apertureSpacing:width - 0.001]) {
        translate([x, -wallThickness / 2, 0])
        cube([apertureWidth, wallThickness * 2, height]);
    }
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