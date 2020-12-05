svgScale = 1.24;
baseHeight = 10;
reliefHeight = 5;
armLength = 60;

screwHeadRadius = 4.5;
screwHeadHeight = 4;
screwRadius = 2;
screwOffset = 8;
screwWallThickness = 2;

$fa = 5;
$fs = 0.5;

bgHeight = baseHeight + reliefHeight;

difference() {
    scale([svgScale, svgScale, 1])
    translate([-47, 0, 0])
    union() {
        linear_extrude(baseHeight) {
            import("rocket-bg.svg");
        }

        linear_extrude(bgHeight) {
            import("rocket-fg.svg");
        }
        
        intersection() {
            linear_extrude(bgHeight + armLength)
            import("rocket-fg.svg");
                
            translate([0, 118, -5])
            cube([100, 12, (bgHeight + armLength) * 2]);
        }
    };
    
    translate([0, 160, 0]) screwHole();
    translate([0, 80, 0]) screwHole();
}

module screwHole() {
    startOffset = 1;
    
    translate([0, 0, -startOffset])
    cylinder(startOffset + screwWallThickness + screwHeadHeight, screwHeadRadius, screwHeadRadius);
    
    translate([0, 0, screwWallThickness])
    hull() {
        cylinder(screwHeadHeight, screwHeadRadius, screwHeadRadius);
        
        translate([0, screwOffset, 0])
        cylinder(screwHeadHeight, screwHeadRadius, screwHeadRadius);
    }
    
    translate([0, 0, -startOffset])
    hull() {
        cylinder(startOffset + screwWallThickness + screwHeadHeight, screwRadius, screwRadius);
        
        translate([0, screwOffset, 0])
        cylinder(startOffset + screwWallThickness + screwHeadHeight, screwRadius, screwRadius);
    }
}