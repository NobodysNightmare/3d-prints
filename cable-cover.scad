thickness = 0.8;

usbLength = 10;
usbHeight = 4.8;
usbWidth = 12;

cableDiameter = 4.2;
spiralLength = 35;
spiralStartThickness = 4;
spiralEndThickness = 3;
spiralStepSize = 0.02;
spiralRotations = 3;

$fn = $preview ? 12 : 48;

spiralThickness = function(n) spiralStartThickness * (1 - n) + spiralEndThickness * n;

module usbCover() {
    cube([thickness, usbHeight + 2 * thickness, usbLength]);
    
    translate([usbWidth + thickness, 0, 0])
    cube([thickness, usbHeight + 2 * thickness, usbLength]);
    
    translate([0, usbHeight + thickness, 0])
    cube([usbWidth + 2 * thickness, thickness, usbLength]);
    
    cube([thickness + usbWidth / 2, thickness, usbLength]);
    
    counterLength = usbWidth / 2 - cableDiameter;
    translate([thickness + usbWidth - counterLength, 0, 0])
    cube([counterLength, thickness, usbLength]);
    
    translate([0, 0, usbLength])
    difference() {
        cube([usbWidth / 2 + thickness, usbHeight + 2 * thickness, thickness]);
        
        translate([thickness + usbWidth / 2, thickness + usbHeight / 2, -0.01])
        cylinder(2 * thickness, d = cableDiameter);
    }
}

module spiral() {
    translate([(-cableDiameter - spiralThickness(0)) / 2, 0, 0])
    cylinder(spiralThickness(0), d = spiralThickness(0));
    
    translate([0, 0, spiralThickness(0)])
    for(n = [spiralStepSize:spiralStepSize:1]) {
        pn = n - spiralStepSize;
        hull() {
            translate([0, 0, pn * spiralLength])
            rotate([0, 0, pn * spiralRotations * 360])
            translate([(-cableDiameter - spiralThickness(pn)) / 2, 0, 0])
            sphere(d = spiralThickness(pn));
            
            translate([0, 0, n * spiralLength])
            rotate([0, 0, n * spiralRotations * 360])
            translate([(-cableDiameter - spiralThickness(n)) / 2, 0, 0])
            sphere(d = spiralThickness(n));
        }
    }
}

module fullCover() {
    usbCover();
    
    translate([thickness + usbWidth / 2, thickness + usbHeight / 2, usbLength + thickness])
    spiral();
}

fullCover();