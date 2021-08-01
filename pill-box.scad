layerHeight = 0.3;

totalRadius = 45;
shaftRadius = 6;
height = 12;

textPadding = 1;

coverOverlap = 2;
shaftLength = 8.5;
shaftGripRadius = 7;
shaftGripHeight = 1;
shaftBendGap = 2.5 * (shaftGripRadius - shaftRadius);

coverText = "Pill Box";

verticalThickness = 1.2;
wallThickness = 1.2;
slotRoundness = 2;
radialTolerance = 0.2;
verticalTolerance = 0.2;

slotLabels = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So", "Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];
slotAngle = 360 / len(slotLabels);

testRendering = false;
$fa = testRendering ? 2 : 0.4;
$fs = testRendering ? 2 : 0.4;

shaftOpenRadius = shaftGripRadius + 2 * radialTolerance;

module mainBody() {
    difference() {
        union() {
            linear_extrude(height)
            difference() {
                circle(totalRadius);
                
                for(angle = [0:slotAngle:360]) {
                    rotate([0, 0, angle])
                    slot();
                }
                
                circle(shaftRadius + radialTolerance);
            }
            
            linear_extrude(verticalThickness)
            difference() {
                circle(totalRadius);
                circle(shaftRadius + radialTolerance);
            }
        }
        
        translate([0, 0, height - shaftLength - shaftGripHeight + verticalTolerance])
        cylinder(shaftGripHeight, shaftOpenRadius, shaftRadius + radialTolerance);
        
        linear_extrude(height - shaftLength - shaftGripHeight + verticalTolerance)
        circle(shaftOpenRadius);
        
        for(i = [0:len(slotLabels) - 1]) {
            rotate([0, 0, i * slotAngle + slotAngle / 2])
            translate([totalRadius - wallThickness - textPadding, 0, verticalThickness - layerHeight])
            linear_extrude(2 * layerHeight)
            text(slotLabels[i], size = 8, font = "Deja Vu Sans", halign = "right", valign = "center");
        }
    }
}

module cover() {
    difference() {
        linear_extrude(verticalThickness + coverOverlap)
        circle(totalRadius + radialTolerance + wallThickness);
        
        translate([0, 0, verticalThickness])
        linear_extrude(verticalThickness + coverOverlap)
        circle(totalRadius + radialTolerance);
        
        linear_extrude(verticalThickness + verticalTolerance)
        slot();
        
        rotate([0, 0, 90 + slotAngle / 2])
        translate([0, totalRadius / 2, 0])
        linear_extrude(2 * layerHeight)
        scale([-1, 1])
        text(coverText, size = 12, font = "Deja Vu Sans", halign = "center", valign = "center");
    }
    
    translate([0, 0, verticalThickness])
    rotate([0, 0, floor(len(slotLabels) / 2) * slotAngle])
    linear_extrude(layerHeight)
    offset(-radialTolerance)
    slot();
    
    translate([0, 0, verticalThickness])
    shaft();
}

module slot() {
    offset(slotRoundness)
    offset(-slotRoundness - wallThickness / 2)
    difference() {
        intersection() {
            polygon([
                [0, 0],
                [2 * totalRadius, 0],
                [cos(slotAngle) * 2 * totalRadius, sin(slotAngle) * 2 * totalRadius]
            ]);
            
            circle(totalRadius - wallThickness);
        };
        
        circle(shaftOpenRadius + wallThickness);
    }
}

module shaft() {
    difference() {
        union() {
            cylinder(shaftLength, r = shaftRadius);
            
            translate([0, 0, shaftLength])
            cylinder(shaftGripHeight, shaftRadius, shaftGripRadius);
            
            translate([0, 0, shaftLength + shaftGripHeight])
            cylinder(2 * shaftGripHeight, shaftGripRadius, shaftRadius - wallThickness);
        }
        
        cylinder(height, r = shaftRadius - wallThickness);
        
        translate([-shaftBendGap / 2, -shaftOpenRadius, 0])
        cube([shaftBendGap, shaftOpenRadius * 2, height]);
    }
}

module testAssembly() {
    intersection() {
        union() {
            mainBody();
            
            translate([0, 0, height + verticalThickness + verticalTolerance / 2])
            rotate([180, 0, 0])
            cover();
        }
        
        rotate([0, 0, slotAngle / 2])
        translate([-1.5 * totalRadius, 0, 0])
        cube([3 * totalRadius, 2 * totalRadius, 2 * height]);
    }
}

cover();