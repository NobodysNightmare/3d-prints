width = 112;
length = 64;
depth = 20;

sideShrink = 2;
trayThickness = 0.8;
verticalThickness = 1.2;
tolerance = 0.4;

armWidth = 4;
holderBackThickness = 2;
holderLockLength = 1.2;

armHeight = armWidth;

module tray() {
    difference() { 
        trayShape(width, length);
        
        translate([trayThickness, trayThickness, verticalThickness])
        trayShape(width - 2 * trayThickness, length - 2 * trayThickness);
    }
    
    translate([-armWidth, 0, depth - verticalThickness])
    cube([armWidth + trayThickness, length, verticalThickness]);
    
    translate([width - trayThickness, 0, depth - verticalThickness])
    cube([armWidth + trayThickness, length, verticalThickness]);
}

module holder() {
    holderArm();
    
    translate([width + armWidth + 2 * tolerance, 0, 0])
    holderArm();
    
    translate([0, length + tolerance, 0])
    cube([width + 2 * tolerance + 2 * armWidth, holderBackThickness, armHeight]);
}

module holderArm() {
    translate([0, -holderLockLength - tolerance, 0]) {
        cube([armWidth, length + 2 * tolerance + holderLockLength, armHeight]);
        
        translate([0, 0, armHeight])
        cube([armWidth, holderLockLength, verticalThickness]);
    }
}

module trayShape(w, l) {
    translate([0, l, 0])
    rotate([90, 0, 0])
    linear_extrude(l)
    polygon([
        [sideShrink, 0],
        [w - sideShrink, 0],
        [w, depth],
        [0, depth]
    ]);
}

module testAssembly() {
    holder();
    
    translate([armWidth + tolerance, 0, armHeight - depth + verticalThickness + tolerance])
    tray();
}

holder();