// By putting in the size of your phone in mm here, you should
// already get a decently fitting stand. Feel free to override
// the settings below as well to customize further
phoneThickness = 12; // front to back, please add 1-2 mm margin here
phoneWidth = 75; // left to right
phoneLength = 160; // top to bottom
phoneAngle = 5; // insertion angle into the holder

// this may require manual fiddling to make sure the swing does
// not end up with thin walls.
// It should work for most phone sizes already, though.
phoneOffset = [3 + phoneThickness / 2, 5];

// how wide the hole for the centered (USB) connector should be
connectorWidth = 15;
connectorCornerRadius = 1;

// This diameter should influence the resting position of the
// swing. Smaller -> leaning back; bigger -> standing "upright"
swingDiameter = 1.8 * phoneLength;

swingWidth = phoneWidth;
swingThickness = 14;

// This default is probably larger than necessary, if you want to
// save on material try reducing this (and tell me if it worked out).
// I guess half the phone length should work, but I didn't try.
swingLength = phoneLength;
swingCornerRadius = 2;

//These are internally used, no modification should be necessary
swingCircumference = PI * swingDiameter;
swingTotalAngle = (swingLength / swingCircumference) * 360;

$fa = 0.5;
$fs = 0.5;

module stand() {
    difference() {
        linear_extrude(swingWidth)
        difference() {
            swingShape();
            phoneCutShape();
        }
        
        connectorCut();
    }
}

module swingShape() {
    offset(swingCornerRadius)
    offset(-swingCornerRadius)
    difference() {
        translate([0, swingDiameter / 2])
        circle(d = swingDiameter);
        
        translate([0, swingDiameter / 2])
        circle(d = swingDiameter - 2 * swingThickness);
        
        translate([-swingDiameter, 0])
        square([swingDiameter, swingDiameter]);
        
        rotate([0, 0, swingTotalAngle - 90])
        translate([-swingDiameter, swingLength])
        square([swingDiameter * 2, swingDiameter]);
    }
}

module phoneCutShape() {
    translate(phoneOffset)
    rotate([0, 0, -phoneAngle])
    translate([-phoneThickness / 2, 0])
    square([phoneThickness, swingThickness]);
}

module connectorCut() {
    translate([phoneOffset.x, phoneOffset.y, (swingWidth - connectorWidth) / 2])
    rotate([0, 0, -phoneAngle])
    translate([-phoneThickness / 2, -phoneLength / 2, connectorWidth])
    rotate([-90, 0, 0])
    linear_extrude(phoneLength)
    offset(connectorCornerRadius)
    offset(-connectorCornerRadius)
    square([phoneThickness, connectorWidth]);
}

module demoPosition() {
    rotate([90, 0, 90])
    stand();
}

stand();