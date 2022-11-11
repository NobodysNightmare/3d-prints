innerThickness = 0.8;
frameThickness = 3;
regularThickness = 2;

frameHeight = 10;

hookLength = 3;
hookHeight = 5;
hookWidth = 2;
totalWidth = 10;

hookDisplacement = hookLength + hookWidth / 2;

$fn = $preview ? 16: 64;

module hook() {
    hull() {
        cylinder(0.1, d = hookWidth);
        
        translate([0, -hookDisplacement, hookDisplacement])
        cylinder(0.1, d = hookWidth);
        
        translate([0, 0, hookDisplacement / 2 + 0.1])
        cube([hookWidth, 0.1, hookDisplacement], center = true);
    }
    
    translate([0, -hookDisplacement, hookDisplacement])
    cylinder(hookHeight, d = hookWidth);
}

cube([totalWidth, regularThickness, frameHeight]);

translate([0, regularThickness + frameThickness, 0])
cube([totalWidth, innerThickness, frameHeight]);

translate([0, 0, frameHeight])
cube([totalWidth, regularThickness + frameThickness + innerThickness, regularThickness]);

translate([totalWidth / 2, 0, 0])
hook();