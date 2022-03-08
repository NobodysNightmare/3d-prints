bladeLength = 23;
bladeWidth = 5;
bladeThickness = 0.65;

bladeOpening = 2.0;
bladeLeadInWidth = 10;
bladeLeadInLength = 30;

bladeOffset = 10;

bodyDiameter = 55;
bodyLength = 70;
bodyThickness = 4;

$fa = 1;
$fs = 1;

bodyOuterDiameter = bodyDiameter + 2 * bodyThickness;

module cutter() {
    difference() {
        cylinder(bodyLength, d = bodyOuterDiameter);
        
        translate([0, 0, -0.01])
        cylinder(bodyLength + 0.02, d = bodyDiameter);
        
        translate([-bladeWidth / 2, -(bodyDiameter + bodyThickness + bladeThickness) / 2, bladeOffset])
        bladeCutOut();
    }
}

module bladeCutOut() {
    cube([bladeWidth, bladeThickness, bladeLength * 2]);
    
    translate([(bladeWidth - bladeOpening) / 2, -bodyThickness, 0])
    cube([bladeOpening, bodyThickness * 2, bladeLength * 2]);
    
    translate([(bladeWidth - bladeLeadInWidth) / 2, 0, bladeLength])
    bladeLeadIn();
}

module bladeLeadIn() {
    leadInDiff = bladeLeadInWidth - bladeOpening;
    
    translate([0, bodyThickness, 0])
    rotate([90, 0, 0])
    linear_extrude(2 * bodyThickness)
    polygon([
        [bladeLeadInWidth, bladeLeadInLength],
        [0, bladeLeadInLength],
        [leadInDiff / 2, 0],
        [bladeLeadInWidth - leadInDiff / 2, 0]
    ]);
    
    translate([0, -bodyThickness, bladeLeadInLength - 0.01])
    cube([bladeLeadInWidth, 2 * bodyThickness, bodyLength]);
}

cutter();