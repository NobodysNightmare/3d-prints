outerRadiusLong = 42;
thickness = 2.4;
bottomThickness = 1.2;
height = 77;

gripDepth = 1.6;
gripStartWidth = 6;
gripEndWidth = gripStartWidth + 2.4;
gripFrontWiggle = 0.1;
gripSideWiggle = 0.3;
gripOffset = 10;

outerRadiusShort = outerRadiusLong * sqrt(3) / 2;
innerRadiusLong = outerRadiusLong - thickness; // TODO: that's slightly too long

module wall() {
    linear_extrude(height) {
        difference() {
            insetX = gripOffset + gripStartWidth / 2;
            square([outerRadiusLong, thickness]);
            
            polygon([
                [insetX - gripStartWidth / 2, thickness],
                [insetX - gripEndWidth / 2, thickness - gripDepth],
                [insetX + gripEndWidth / 2, thickness - gripDepth],
                [insetX + gripStartWidth / 2, thickness]
            ]);
        }
        
        outsetX = outerRadiusLong - gripOffset - gripStartWidth / 2;
        polygon([
                [outsetX - gripStartWidth / 2 + gripSideWiggle, thickness],
                [outsetX - gripEndWidth / 2 + gripSideWiggle, thickness + gripDepth - gripFrontWiggle],
                [outsetX + gripEndWidth / 2 - gripSideWiggle, thickness + gripDepth - gripFrontWiggle],
                [outsetX + gripStartWidth / 2 - gripSideWiggle, thickness]
            ]);
    }
}

module hexFrame() {
    for(r = [0:60:360]) {
        rotate([0, 0, r])
        translate([-outerRadiusLong / 2, outerRadiusShort - thickness, 0])
        wall();
    }
}

module hexSolidBottom() {
    rotate([0, 0, 30])
    linear_extrude(bottomThickness)
    polygon([
        [sin(0) * innerRadiusLong, cos(0) * innerRadiusLong],
        [sin(60) * innerRadiusLong, cos(60) * innerRadiusLong],
        [sin(120) * innerRadiusLong, cos(120) * innerRadiusLong],
        [sin(180) * innerRadiusLong, cos(180) * innerRadiusLong],
        [sin(240) * innerRadiusLong, cos(240) * innerRadiusLong],
        [sin(300) * innerRadiusLong, cos(300) * innerRadiusLong]
    ]);
}

module fittingTest() {
    for(r = [0:60:60]) {
        rotate([0, 0, r])
        translate([-outerRadiusLong / 2, outerRadiusShort - thickness, 0])
        wall();
    }
}

hexSolidBottom();
hexFrame();

//fitDistance = 0.1 + outerRadiusShort * 2;
//translate([sin(60) * fitDistance, cos(60) * fitDistance, 0]) hexFrame();