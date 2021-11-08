thickLength = 16;
thickDiameter = 32.5;
thinDiameter = 24;
thinLength = 18;
changeLength = 12;

stopDiameter = 17;
stopLength = thinDiameter - stopDiameter;

phaseInLength = 5;
phaseInDiameter = thinDiameter + 2;

materialThickness = 3;

$fa = 0.5;
$fs = 0.5;

module outerShape() {
    cylinder(thickLength, d=thickDiameter + 2 * materialThickness);
    
    translate([0, 0, thickLength])
    cylinder(changeLength, d1=thickDiameter + 2 * materialThickness, d2=thinDiameter + 2 * materialThickness);
    
    translate([0, 0, thickLength + changeLength])
    cylinder(thinLength + stopLength + phaseInLength, d=thinDiameter + 2 * materialThickness);
}

module innerShape() {
    cylinder(thickLength, d=thickDiameter);
    
    translate([0, 0, thickLength])
    cylinder(changeLength + stopLength, d1=thickDiameter, d2=stopDiameter);
    
    translate([0, 0, thickLength + changeLength + stopLength])
    cylinder(thinLength, d=thinDiameter);
    
    translate([0, 0, thickLength + changeLength + stopLength + thinLength])
    cylinder(phaseInLength, d1=thinDiameter, d2=phaseInDiameter);
}

module adapter() {
    difference() {
        outerShape();
        innerShape();
    }
}

module testAdapterCut() {
    difference() {
        adapter();
        
        translate([-50, 0, 0])
        cube([100, 100, 100]);
    }
}

testAdapterCut();