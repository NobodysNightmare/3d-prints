neckDiameter = 42;
neckThickness = 4;
printThickness = 3;

wallSeparation = 15;
aspectRatio = 0.86;

gripHeight = 8 + printThickness;
gripThickness = 4.5;

totalDepth = aspectRatio * neckDiameter + 2 * neckThickness;
leftEnd = -(wallSeparation + neckDiameter / 2);

$fa = 1;
$fs = 1;

linear_extrude(printThickness)
difference() {
    hull() {
        translate([leftEnd, 0, 0])
        square([1, totalDepth], center = true);
        
        offset(neckThickness)
        scale([1, aspectRatio, 1])
        circle(d = neckDiameter);
    }
    
    scale([1, aspectRatio, 1])
    circle(d = neckDiameter);
}

translate([-wallSeparation - neckDiameter / 2, -totalDepth / 2, 0]) {
    cube([printThickness, totalDepth, gripHeight]);
    
    translate([-gripThickness - printThickness, 0 , 0]) {
        cube([printThickness, totalDepth, gripHeight]);
        cube([gripThickness + printThickness, totalDepth, printThickness]);
    }
}