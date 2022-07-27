topDiameter = 15;
bottomDiameter = 14;

topHeight = 24;
totalHeight = 43;
bottomHeight = totalHeight - topHeight;

penTopDiameter = 12.5;
penBottomDiameter = 9.6;
penBottomHeight = 6;

bendSpace = 2;
bendMargin = 3;

$fn = $preview ? 32 : 128;

module adapter() {
    difference() {
        outerShape();
        
        bendCut();
        
        rotate([0, 0, 90])
        bendCut();
        
        translate([0, 0, -0.01])
        linear_extrude(2 * totalHeight)
        circle(d = penBottomDiameter);
        
        translate([0, 0, penBottomHeight])
        linear_extrude(2 * totalHeight)
        circle(d = penTopDiameter);
    }
}

module outerShape() {
    linear_extrude(bottomHeight)
    circle(d = bottomDiameter);

    translate([0, 0, bottomHeight])
    linear_extrude(topHeight)
    circle(d = topDiameter);
}

module bendCut() {
    translate([-topDiameter, -bendSpace / 2, -bendMargin])
    cube([2* topDiameter, bendSpace, bottomHeight]);
}

adapter();