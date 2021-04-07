wallThickness = 1.35;
verticalThickness = 1.2;

tolerance = 0.1;

boardWidth = 60;
boardDepth = 25;

displayWidth = 20;
displayHeight = 10;
displayBoardWidth = 30;
displayBoardHeight = 20;

displayTopMargin = 10;
displayBottomMargin = 10;

sensorWidth = 10.2;
sensorLength = 14;
sensorThickness = 2.5;
sensorCushion = 10;
sensorGripSize = 1;

apertureWidth = 1.1;
apertureSpacing = 2;
apertureCount = 3;

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
            cube([wallThickness * 2, apertureWidth, sensorLength]);
        }
    }
    
    sensorMount();
    
    // left
    translate([caseWidth - wallThickness, 0, 0])
    cube([wallThickness, caseDepth, caseHeight]);
    
    // front
    difference() {
        cube([caseWidth, wallThickness, caseHeight]);
        
        translate([(caseWidth - displayWidth) / 2, -wallThickness / 2, displayTopMargin])
        cube([displayWidth, wallThickness * 2, displayHeight]);
    }
    
    // back
    translate([0, caseDepth - wallThickness, 0])
    difference() {
        cube([caseWidth, wallThickness, caseHeight]);
        
        translate([wallThickness + apertureWidth / 2, 0, 0])
        for(x = [0:apertureSpacing:apertureTotalWidth - 0.001]) {
            translate([x, -wallThickness / 2, verticalThickness])
            cube([apertureWidth, wallThickness * 2, sensorLength]);
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
            translate([wallThickness, 2 * wallThickness + sensorThickness, sensorLength])
            cube([sensorWidth, sensorCushion, verticalThickness]);
            
            sensorMountArm();
            
            translate([2 * wallThickness + sensorWidth, 0, 0])
            scale([-1, 1, 1])
            sensorMountArm();
        }
        
    }
}

module sensorMountArm() {
    cube([wallThickness, 2 * wallThickness + sensorThickness, sensorLength]);
    
    cube([wallThickness + sensorGripSize, wallThickness, sensorLength]);
    
    translate([0, sensorThickness + wallThickness, 0])
    cube([wallThickness + sensorGripSize, wallThickness, sensorLength]);
}

module bottomCap() {
    cube([caseWidth - 2 * (wallThickness + tolerance), caseDepth - 2 * (wallThickness + tolerance), verticalThickness]);
}

module testAssembly() {
    translate([caseWidth, 0, caseHeight])
    rotate([0, 180, 0])
    mainCase();
    
    translate([wallThickness + tolerance, wallThickness + tolerance, 0])
    bottomCap();
}

mainCase();