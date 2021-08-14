length = 190;
width = 50;
height = 45;

thickness = 5;
roundness = 0.5;

cutInDepth = 2.8;
cutInSink = 1;
drainRadius = 1;

sideMargin = 4;
holeMargin = 2.5;

largeHoleDiameter = width - 2 * sideMargin;
largeHoleShrinking = 0.84;

smallHoleDiameter = (width - 3 * sideMargin) / 2;

$fa = $preview ? 2 : 0.5;
$fs = $preview ? 2 : 0.5;

module organizer() {
    difference() {
        linear_extrude(width)
        difference() {
            baseShape();
            
            offset(-thickness)
            baseShape();
        }
        
        translate([largeHoleShrinking * largeHoleDiameter / 2, 0, 0])
        scale([largeHoleShrinking, 1, 1])
        cutOut(largeHoleDiameter);
        
        translate([1.5 * largeHoleShrinking * largeHoleDiameter + holeMargin, 0, 0])
        scale([largeHoleShrinking, 1, 1])
        cutOut(largeHoleDiameter);
        
        translate([0.5 * smallHoleDiameter + 2 * largeHoleShrinking * largeHoleDiameter + 2 * holeMargin, 0, 0])
        cutOutPair();
        
        translate([1.5 * smallHoleDiameter + 2 * largeHoleShrinking * largeHoleDiameter + 3 * holeMargin, 0, 0])
        cutOutPair();
        
        translate([length - largeHoleShrinking * largeHoleDiameter / 2, 0, 0])
        scale([largeHoleShrinking, 1, 1])
        cutOut(largeHoleDiameter);
        
        translate([length - (1.5 * largeHoleShrinking * largeHoleDiameter + holeMargin), 0, 0])
        scale([largeHoleShrinking, 1, 1])
        cutOut(largeHoleDiameter);
    }
}

module baseShape() {
    translate([0, height / 2, 0])
    scale([roundness, 1, 1])
    circle(d = height);
    
    square([length, height]);
    
    translate([length, height / 2, 0])
    scale([roundness, 1, 1])
    circle(d = height);
}

module cutOut(diameter) {
    translate([0, height - thickness + cutInDepth , width / 2])
    rotate([90, 0, 0]) {
        cylinder(d = diameter, h = height);
        
        translate([0, 0, -thickness])
        cylinder(r = drainRadius, h = height);
        
        translate([0, 0, -cutInSink])
        cylinder(cutInSink, d1 = 0, d2 = diameter);
    }
    
    translate([0, height, 0])
    cylinder(r = drainRadius, h = width);
}

module cutOutPair() {
    translate([0, 0, (smallHoleDiameter + sideMargin) / 2])
    cutOut(smallHoleDiameter);
    
    translate([0, 0, -(smallHoleDiameter + sideMargin) / 2])
    cutOut(smallHoleDiameter);
}

organizer();