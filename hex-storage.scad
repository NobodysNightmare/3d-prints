outerRadiusL = 42;
thickness = 2.4;
bottomThickness = 1.2;
height = 77;

gripDepth = 1.6;
gripStartWidth = 6;
gripEndWidth = gripStartWidth + 2.4;
gripFrontWiggle = 0.1;
gripSideWiggle = 0.3;
gripOffset = 10;

gridRadiusMultiplier = 0.4;
gridThickness = 1;

outerRadiusS = outerRadiusL * sqrt(3) / 2;
innerRadiusL = outerRadiusL - thickness; // TODO: that's slightly too long

module wall() {
    linear_extrude(height) {
        difference() {
            insetX = gripOffset + gripStartWidth / 2;
            square([outerRadiusL, thickness]);
            
            polygon([
                [insetX - gripStartWidth / 2, thickness],
                [insetX - gripEndWidth / 2, thickness - gripDepth],
                [insetX + gripEndWidth / 2, thickness - gripDepth],
                [insetX + gripStartWidth / 2, thickness]
            ]);
        }
        
        outsetX = outerRadiusL - gripOffset - gripStartWidth / 2;
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
        translate([-outerRadiusL / 2, outerRadiusS - thickness, 0])
        wall();
    }
}

module hexSolidBottom(radiusL = innerRadiusL) {
    linear_extrude(bottomThickness)
    hex2D(radiusL);
}

module hexGridBottom() {
    gridRadiusL = innerRadiusL * gridRadiusMultiplier;
    gridRadiusS = gridRadiusL * sqrt(3) / 2;
    
    linear_extrude(bottomThickness)
    difference() {
        hex2D(innerRadiusL);
        
        hex2D(gridRadiusL);
        
        for(direction = [0:60:360]) {
            translate([sin(direction) * (gridRadiusS * 2 + gridThickness), cos(direction) * (gridRadiusS * 2 + gridThickness)])
            hex2D(gridRadiusL);
        }
    }
}

module hex2D(radiusL) {
    rotate([0, 0, 30])
    polygon([
        [sin(0) * radiusL, cos(0) * radiusL],
        [sin(60) * radiusL, cos(60) * radiusL],
        [sin(120) * radiusL, cos(120) * radiusL],
        [sin(180) * radiusL, cos(180) * radiusL],
        [sin(240) * radiusL, cos(240) * radiusL],
        [sin(300) * radiusL, cos(300) * radiusL]
    ]);
}

module fittingTest() {
    for(r = [0:60:60]) {
        rotate([0, 0, r])
        translate([-outerRadiusL / 2, outerRadiusS - thickness, 0])
        wall();
    }
}

hexGridBottom();
hexFrame();

//fitDistance = 0.1 + outerRadiusS * 2;
//translate([sin(60) * fitDistance, cos(60) * fitDistance, 0]) hexFrame();