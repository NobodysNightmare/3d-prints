// Export separate STL files from rendering
// the following two modules:
//     cover();
//     mainBody();

//Text printed on top of the cover (e.g. your name)
coverText = "Pills";

// Text printed inside the slots/trays (current german weekdays)
// Number of slots will adapt to the size of this array
slotLabels = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So", "Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];

// Radius and height have the main influence
// on the storage capacity.
totalRadius = 45;
height = 12;

layerHeight = 0.3;

shaftRadius = 6;

textPadding = 1;

coverOverlap = 2;

// Length of the straight part of the shaft the cover rotates around.
// It should not be necessary to increase the length for higher boxes,
// though shorter boxes might need a shorter shaft.
shaftLength = 8.5;

shaftGripRadius = 7;
shaftGripHeight = 3;
shaftGripRatio = 1 / 3; // balancing between inwards and outwards chamfer of grip
shaftBendGap = 2.5 * (shaftGripRadius - shaftRadius);

verticalThickness = 1.2;
wallThickness = 1.2;
slotRoundness = 2;
radialTolerance = 0.2;
verticalTolerance = 0.2;

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

        translate([0, 0, height - shaftLength - shaftGripHeight * shaftGripRatio + verticalTolerance])
        cylinder(shaftGripHeight * shaftGripRatio, shaftOpenRadius, shaftRadius + radialTolerance);

        linear_extrude(height - shaftLength - shaftGripHeight * shaftGripRatio + verticalTolerance)
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
    linear_extrude(2 * layerHeight)
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
    assert(
        height >= shaftLength + shaftGripHeight,
        "Shaft is too long for box height. Remember to reduce the shaftLength, when reducing the height."
    );
    
    difference() {
        union() {
            cylinder(shaftLength, r = shaftRadius);

            translate([0, 0, shaftLength])
            cylinder(shaftGripHeight * shaftGripRatio, shaftRadius, shaftGripRadius);

            translate([0, 0, shaftLength + shaftGripHeight * shaftGripRatio])
            cylinder(shaftGripHeight * (1 - shaftGripRatio), shaftGripRadius, shaftRadius - wallThickness);
        }

        cylinder(shaftLength + shaftGripHeight + 0.01, r = shaftRadius - wallThickness);

        // bend gap
        translate([-shaftBendGap / 2, -shaftOpenRadius, 0])
        cube([shaftBendGap, shaftOpenRadius * 2, shaftLength + shaftGripHeight + 0.01]);

        // side cut outs (helping during insertion, because bending only
        // happens in one direction)
        translate([-shaftGripRadius, shaftRadius - radialTolerance, shaftLength])
        cube([2 * shaftGripRadius, shaftGripRadius, shaftGripHeight]);

        translate([-shaftGripRadius, -shaftGripRadius - shaftRadius + radialTolerance, shaftLength])
        cube([2 * shaftGripRadius, shaftGripRadius, shaftGripHeight]);
    }
}

module testAssembly() {
    intersection() {
        union() {
            mainBody();

            translate([0, 0, height + verticalThickness + verticalTolerance])
            rotate([180, 0, 0])
            cover();
        }

        rotate([0, 0, -1 * slotAngle + slotAngle / 2])
        translate([-1.5 * totalRadius, 0, 0])
        cube([3 * totalRadius, 2 * totalRadius, 2 * height]);
    }
}

testAssembly();
