fieldWidth = 100;
fieldHeight = 100;
borderWidth = 4;

signThickness = 3.3;
textThickness = 1.8;
chamferAmount = 2;

coverThickness = 1.5;
coverSideThickness = 2.0;
coverTolerance = 0.5;

endStopThickness = 1.2;
endStopHeight = 4;

textHeight = fieldHeight - 4;
signHeight = fieldHeight + 2 * borderWidth;
signWidth = 2 * fieldWidth + 3 * borderWidth;
coverStopCutHeight = endStopHeight + 2 * coverTolerance;

module sign() {
    difference() {
        signPlate();
        
        svgImpression("symbols/checkmark.svg", 9.7, 10);
        
        translate([fieldWidth + borderWidth, 0, 0])
        svgImpression("symbols/crossmark.svg", 9.7, 10);
    }
    
    
    endStop();
    
    translate([signWidth, 0, 0])
    scale([-1, 1, 1])
    endStop();
}

module signPlate() {
    rotate([90, 0, 90])
    linear_extrude(signWidth)
    polygon([
        [chamferAmount, 0],
        [signHeight - chamferAmount, 0],
        [signHeight, signThickness],
        [0, signThickness]
    ]);
}

module endStop() {
    translate([0, (signHeight + endStopHeight) / 2, signThickness])
    rotate([90, 0, 0])
    linear_extrude(endStopHeight)
    polygon([
        [0, 0],
        [borderWidth, 0],
        [borderWidth, endStopThickness]
    ]);
}

module textImpression(t) {
    translate([borderWidth, borderWidth, signThickness - textThickness])
    difference() {
        cube([fieldWidth, fieldHeight, textThickness + 0.01]);
        
        translate([fieldWidth / 2, (fieldHeight - textHeight) / 2, -0.01])
        linear_extrude(textThickness + 0.03)
        text(t, size = textHeight, halign = "center");
    }
}

module svgImpression(svg, svgWidth, svgHeight) {
    translate([borderWidth, borderWidth, signThickness - textThickness])
    difference() {
        cube([fieldWidth, fieldHeight, textThickness + 0.01]);
        
        translate([fieldWidth / 2, fieldHeight / 2, -0.01])
        linear_extrude(textThickness + 0.03)
        scale([textHeight / svgHeight, textHeight / svgHeight])
        translate([-svgWidth / 2, -svgHeight / 2])
        import(svg);
    }
}

module cover() {
    difference() {
        cube([fieldWidth + borderWidth, signHeight + 2 * coverThickness, signThickness + coverSideThickness]);
        
        translate([-0.01, coverSideThickness, -0.01])
        rotate([90, 0, 90])
        linear_extrude(signWidth)
        polygon([
            [chamferAmount - coverTolerance, 0],
            [signHeight - chamferAmount + coverTolerance, 0],
            [signHeight + coverTolerance, signThickness],
            [-coverTolerance, signThickness]
        ]);
        
        translate([-0.01, coverSideThickness + (signHeight - coverStopCutHeight) / 2, signThickness - 0.02])
        cube([borderWidth + coverTolerance + 0.01, coverStopCutHeight, endStopThickness + 0.02]);
        
        translate([fieldWidth - coverTolerance, coverSideThickness + (signHeight - coverStopCutHeight) / 2, signThickness - 0.02])
        cube([borderWidth + coverTolerance + 0.01, coverStopCutHeight, endStopThickness + 0.02]);
    }
}

module testAssembly() {
    sign();
    
    translate([0, -coverSideThickness, coverTolerance / 2])
    cover();
    
    translate([0, signHeight + 5, 0]) {
        sign();
        
        translate([fieldWidth + 2 * borderWidth, -coverSideThickness, coverTolerance / 2])
        cover();
    }
}

module printLayout() {
    sign();
    
    translate([0, 2 * signHeight + 10, coverThickness + signThickness])
    rotate([180, 0, 0])
    cover();
}

printLayout();