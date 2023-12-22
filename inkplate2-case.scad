layerHeight = 0.3;
verticalThickness = 4 * layerHeight;

inkplateBoardWidth = 65.2 + 0.8;
inkplateBoardHeight = 35.3 + 0.7;
inkplateBoardThickness = 9.9 + 0.1;

inkplateBoardLift = 10;
lifterRadius = 6;

display = [50, 26];
displayRightPadding = 4.5;
displayBottomPadding = 4.5;

usbWidth = 10; // 12 for whole plug
usbHeight = 4; // 7 for whole plug
usbYOffset = 7.2;
usbZOffset = 3.5;

capTolerance = 0.2;
capRailMinThickness = 1.0;
capRailLockSize = 0.8;
capLockWidth = 4;
capLockLength = 2;
capLockHeight = 0.6;

wallThickness = capRailMinThickness + capRailLockSize;
caseWidth = inkplateBoardWidth + 2 * wallThickness;
caseDepth = inkplateBoardHeight + 2 * wallThickness;
caseHeight = inkplateBoardLift + inkplateBoardThickness + 2 * verticalThickness;

$fn = $preview ? 32 : 128;

module mainCase() {
    // floor
    cube([caseWidth, caseDepth, verticalThickness]);
    
    // left
    cube([wallThickness, caseDepth, caseHeight - verticalThickness]);       
    
    // right
    translate([caseWidth - wallThickness, 0, 0])
    difference() {
        cube([wallThickness, caseDepth, caseHeight - verticalThickness]);
        
        translate([-0.01, wallThickness + usbYOffset, verticalThickness + inkplateBoardLift + usbZOffset])
        cube([wallThickness + 0.02, usbWidth, usbHeight]);
    }
        
    
    // front
    cube([caseWidth, wallThickness, caseHeight - verticalThickness]);
    
    // back
    translate([0, caseDepth - wallThickness, 0])
    cube([caseWidth, wallThickness, caseHeight - verticalThickness]);
    
    // Lifter FL
    translate([wallThickness, wallThickness, verticalThickness])
    lifter();
    
    // Lifter FR
    translate([caseWidth - wallThickness, wallThickness, verticalThickness])
    scale([-1, 1, 1])
    lifter();
    
    // Lifter BL
    translate([wallThickness, caseDepth - wallThickness, verticalThickness])
    scale([1, -1, 1])
    lifter();
    
    // Lifter BR
    translate([caseWidth - wallThickness, caseDepth - wallThickness, verticalThickness])
    scale([-1, -1, 1])
    lifter();
    
    // front rail
    translate([0, 0, caseHeight - verticalThickness]) {
        capRail(caseWidth);
    }
    
    // back rail
    translate([0, caseDepth, caseHeight - verticalThickness])
    scale([1, -1, 1]) {
        capRail(caseWidth);
    }
    
    // right rail
    translate([caseWidth, 0, caseHeight - verticalThickness])
    rotate(90) {
        capRail(caseDepth);
    }
}

module capRail(length) {
    translate([0, capRailMinThickness, 0])
    cushion(length, verticalThickness, capRailLockSize);
    
    cube([length, capRailMinThickness, verticalThickness]);
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

module lifter() {
    intersection() {
        cylinder(h = inkplateBoardLift, r1 = 0, r2 = lifterRadius);
        
        cube([lifterRadius, lifterRadius, inkplateBoardLift]);
    }
}

module displayCap() {
    topWidth = caseDepth - 2 * (capRailMinThickness + capTolerance);
    topLength = caseWidth - (capRailMinThickness + capTolerance);
    
    difference() {
        hull() {
            translate([0, 0, verticalThickness - 0.01])
            cube([topLength, topWidth, 0.01]);
            
            translate([capRailLockSize, capRailLockSize, 0])
            cube([topLength - capRailLockSize, topWidth - 2 * capRailLockSize, 0.01]);
        }
        
        translate([capRailLockSize + displayRightPadding, capRailLockSize + displayBottomPadding, -0.01])
        cube([display.x, display.y, verticalThickness + 0.02]);
    }
    
    translate([topLength - capLockLength - wallThickness - 2 * capTolerance, (topWidth - capLockWidth) / 2, verticalThickness])
    cube([capLockLength, capLockWidth, capLockHeight]);
}

module testAssembly() {
    cutPosition = 0.9;
    intersection() {
        union() {
            mainCase();
            
            translate([caseWidth, 0, caseHeight])
            rotate([0, 180, 0])
            translate([capRailMinThickness + capTolerance, capRailMinThickness + capTolerance, -capTolerance / 2])
            displayCap();
        }
        
        translate([0, 0, 0])
        cube([caseWidth, caseDepth * cutPosition, caseHeight]);
    }
}

module printLayout() {
    mainCase();
    
    translate([0, caseDepth + 10, 0])
    displayCap();
}

mainCase();