holeDistance = 34.5;
holeDiameter = 2.2;
holeMargin = 2;
thickness = 2.4;

wallOffset = 2.4;
teethCount = 8;

baseHeight = holeDiameter + 2 * holeMargin;
teethMargin = holeMargin + thickness;
teethWidth = holeDistance - 2 * teethMargin;
widthPerTooth = teethWidth / teethCount;
teethHeight = teethWidth / teethCount / 2;

$fa = $preview ? 0.5 : 0.2;
$fs = $preview ? 0.5 : 0.2;

module holder() {
    holeFrame();
    
    translate([holeDistance, 0, 0])
    scale([-1, 1, 1])
    holeFrame();
    
    translate([teethMargin, -baseHeight / 2, thickness + wallOffset])
    teeth();
}

module teeth() {
    teethNodes = [ each for (i = [0:teethCount-1]) [[i * widthPerTooth, 0], [(i + 0.5) * widthPerTooth, -teethHeight]] ];
    allNodes = [
        each teethNodes,
        [teethWidth, 0],
        [teethWidth, baseHeight],
        [0, baseHeight]
    ];
    
    linear_extrude(thickness)
    polygon(allNodes);
}

module holeFrame() {
    linear_extrude(thickness)
    difference() {
        union() {
            circle(d = baseHeight);
            
            translate([0, -baseHeight / 2])
            square([holeDiameter / 2 + teethMargin, baseHeight]);
        }
        
        circle(d = holeDiameter);
    }
    
    translate([holeDiameter / 2 + holeMargin, -baseHeight / 2, thickness])
    cube([thickness, baseHeight, wallOffset + thickness]);
}

holder();