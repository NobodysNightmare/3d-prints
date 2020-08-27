height = 12;
railWidth = 7;
railDepth = 3;
trackWidth = 39;
trackLength = 216;
sideMargin = 4;

connectorWidth = 8;
connectorLength = 12;
connectorRadius = 6.25;

module connector(sideFit, heightFit) {
    translate([(trackWidth - connectorWidth - sideFit) / 2, -1, -heightFit / 2])
    union() {
        cube([connectorWidth + sideFit, connectorLength + 1, height + heightFit]);
        translate([(connectorWidth + sideFit) / 2, connectorLength, 0])
        cylinder(height + heightFit, connectorRadius + sideFit, connectorRadius + sideFit);
    }
}

module straightTrack(length) {
    difference() {
        cube([trackWidth, length, height]);
        translate([sideMargin, -0.5 * length, height - railDepth])
            cube([railWidth, length * 2, railDepth * 2]);
        translate([trackWidth - railWidth - sideMargin, -0.5 * length, height - railDepth])
            cube([railWidth, length * 2, railDepth * 2]);
        connector(0, 2);
    }
    translate([0, length, 0])
        connector(-0.5, 0);
}

straightTrack(trackLength);