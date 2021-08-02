nameplateWidth = 100;
nameplateAR = 0.5;
nameplateThickness = 2;
nameplateBorderThickness = 2.5;
nameplateHoleDiameter = 6;
nameplateHoleMargin = 1.5;
nameOffset = 1;
birthdayOffset = 15;

frameOutset = 1.5;
frameInset = 2;
frameTolerance = 0.4;

connectorAR = 0.6;
connectorThickness = 2.4;
connectorWidth = 1.5;
nameplateSpacing = 5; // TODO: probably not the actual distance because of roundness
connectorOpening = nameplateHoleMargin * 1.2;
connectorInnerDiameter = 2 * nameplateHoleMargin + nameplateSpacing;

frameThickness = 11;
frameDepth = 20;
hookWidth = 8;
hookThickness = 2;
hookSeparation = 5;

name = "Name";
birthday = "01.01.2021";

$fa = 0.5;
$fs = 0.5;

use <allerta.stencil.ttf>

module namePlate() {
    difference() {
        linear_extrude(nameplateThickness)
        difference() {
            scale([1, nameplateAR])
            circle(d = nameplateWidth);

            translate([0, nameplateWidth * nameplateAR * 0.5 - nameplateHoleDiameter / 2 - nameplateHoleMargin])
            circle(d = nameplateHoleDiameter);

            translate([0, -nameplateWidth * nameplateAR * 0.5 + nameplateHoleDiameter / 2 + nameplateHoleMargin])
            circle(d = nameplateHoleDiameter);

            translate([0, nameOffset])
            text(name, 12, "Allerta:style=Stencil", halign = "center");

            translate([0, -birthdayOffset])
            text(birthday, 9, "Allerta:style=Stencil", halign = "center");
        }
    }
}

module connector() {
    linear_extrude(connectorThickness) {
    difference() {
        offset(connectorWidth)
        scale([connectorAR, 1])
        circle(d = connectorInnerDiameter);

        scale([connectorAR, 1])
        circle(d = connectorInnerDiameter);

        translate([-connectorInnerDiameter * connectorAR / 2, 0])
        square([2 * connectorWidth, connectorOpening], center = true);
    }
    }
}

module frameHook() {
    linear_extrude(hookWidth) {
        square([hookSeparation + connectorInnerDiameter, hookThickness]);

        translate([0, hookThickness + frameThickness])
        square([frameDepth, hookThickness]);

        translate([-hookThickness, 0])
        square([hookThickness, frameThickness + 2 * hookThickness]);
    }

    translate([connectorAR * connectorInnerDiameter / 2 + connectorWidth + hookSeparation, -connectorInnerDiameter / 2, (hookWidth - connectorThickness) / 2])
    connector();
}

module nameplateFrame() {
    linear_extrude(nameplateThickness) {
        difference() {
            offset(frameOutset)
            scale([1, nameplateAR])
            circle(d = nameplateWidth);

            offset(-frameInset)
            scale([1, nameplateAR])
            circle(d = nameplateWidth);

            square([nameplateHoleDiameter, nameplateWidth], center = true);
        }

        frameHoleCutout();

        scale([1, -1])
        frameHoleCutout();
    }

    translate([0, 0, nameplateThickness])
    linear_extrude(nameplateThickness + frameTolerance)
    topFrameShape(frameOutset, 0);
}

module frameHoleCutout() {
    difference() {
        union() {
            translate([0, -nameplateWidth * nameplateAR * 0.5 + nameplateHoleDiameter / 2 + nameplateHoleMargin])
            circle(d = nameplateHoleDiameter + 2 * frameInset);

            translate([-frameInset - nameplateHoleDiameter / 2, -nameplateWidth * nameplateAR * 0.5 + nameplateHoleMargin])
            square([frameInset, nameplateHoleDiameter / 2]);

            translate([nameplateHoleDiameter / 2, -nameplateWidth * nameplateAR * 0.5 + nameplateHoleMargin])
            square([frameInset, nameplateHoleDiameter / 2]);
        }

        translate([0, -nameplateWidth * nameplateAR * 0.5 + nameplateHoleDiameter / 2 + nameplateHoleMargin])
        circle(d = nameplateHoleDiameter);

        translate([0, -nameplateWidth * nameplateAR * 0.5 + nameplateHoleMargin])
        square([nameplateHoleDiameter, nameplateHoleDiameter], center = true);
    }
}

module topFrameShape(outset, inset) {
    difference() {
        offset(outset)
        scale([1, nameplateAR])
        circle(d = nameplateWidth);

        offset(-inset)
        scale([1, nameplateAR])
        circle(d = nameplateWidth);

        square([nameplateHoleDiameter, nameplateWidth], center = true);

        translate([0, -nameplateWidth * nameplateAR * 0.4])
        square([2 * nameplateWidth, nameplateWidth * nameplateAR], center = true);
    }
}

module testAssembly() {
    namePlate();

    translate([0, 0.1, 2 * nameplateThickness + 0.1])
    rotate([0, 180, 0])
    color("red")
    nameplateFrame();
}

namePlate();
