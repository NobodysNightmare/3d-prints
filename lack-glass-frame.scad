// Total width:  446 mm
// Total height: 399 mm
// frame thickness 2 * 2 mm = 4 mm
// Glass tolerance 2 * 2 mm = 4 mm
// -------------------------------
// Glass width = 438 mm
// Glass height = 391 mm

use <modules/screw-hole.scad>;

glassThickness = 3.1;
glassWidth = 438;
glassHeight = 391;

printThickness = 2;
frameHeight = 12;

// 3.5 x 25 mm
screwHeadDiameter = 6.8;
screwHeadHeight = 2;
screwDiameter = 3.5;
screwMargin = 5;
screwSideMargin = 12;

magnetLength = 20;
magnetWidth = 10;
magnetThickness = 2;

hingeDiameter = 5;
hingeDepth = 40;
hingeDistance = 0.5;
hingeConnectorRatio = 1.0;
hingeWiggle = 0.4;

doorHingeWidth = 80;
doorHingeHeight = 80;
doorHingeLift = 1.8;
doorGripDepth = 0.1;
doorGripHeight = 0.6;

hingeContactShiftLength = 10;

handleWidth = 60;
handleHeight = 20;
handleLift = 20;
handleStraightRate = 0.8;

ptfePassthroughLength = 72;
ptfeEntryInnerDiameter = 4.8;
ptfeEntryOuterDiameter = 7.2;
ptfeExitInnerDiameter = 4.3;
ptfeExitOuterDiameter = 8;
ptfePassthroughLip = 7;
ptfePassthroughRounding = 1;

$fa = 0.1;
$fs = 0.2;

module framePiece(width) {
    cube([width, glassThickness + 2 * printThickness, printThickness]);
    
    translate([0, 0, printThickness])
    cube([width, printThickness, frameHeight]);
    
    translate([0, glassThickness + printThickness, printThickness])
    cube([width, printThickness, frameHeight]);
}

module middleFrame(width) {
    screwPlateWidth = 2 * screwMargin + screwHeadDiameter;
    frameWidth = glassThickness + 2 * printThickness;
    
    framePiece(width);
    
    
    translate([0, frameWidth, 0])
    difference() {
        cube([width, screwPlateWidth, printThickness]);
        
        translate([screwSideMargin + screwHeadDiameter / 2, screwPlateWidth / 2, printThickness]) screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        translate([width / 2, screwPlateWidth / 2, printThickness]) screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        translate([width - (screwSideMargin + screwHeadDiameter / 2), screwPlateWidth / 2, printThickness]) screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
    }
}

module cornerFrame(width, height) {
    middleFrame(width);
    
    translate([0, 0, height])
    rotate([0, 90, 0])
    middleFrame(height);
}

module middleDoorStop(width) {
    screwPlateWidth = 2 * screwMargin + screwHeadDiameter;
    frameWidth = printThickness;
    
    cube([width, printThickness, frameHeight + printThickness]);
    
    translate([0, frameWidth, 0])
    difference() {
        cube([width, screwPlateWidth, printThickness]);
        
        translate([screwSideMargin + screwHeadDiameter / 2, screwPlateWidth / 2, printThickness]) screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        translate([width / 2, screwPlateWidth / 2, printThickness]) screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        translate([width - (screwSideMargin + screwHeadDiameter / 2), screwPlateWidth / 2, printThickness]) screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
    }
}

module cornerDoorStop(width, height) {
    middleDoorStop(width);
    
    translate([0, 0, height])
    rotate([0, 90, 0])
    middleDoorStop(height);
}

module bottomFrameHinge(width, height) {
    innerRadius = hingeDiameter / 2;
    outerRadius = innerRadius + printThickness;
    hingeYCenter = outerRadius + hingeDistance + 2 * printThickness + glassThickness;
    
    difference() {
        rotate([0, -90, 0])
        cornerDoorStop(width, height);
        
        translate([-(doorHingeWidth), 0, 0])
        cube([doorHingeWidth, printThickness, height]);
    }
    
    translate([-doorHingeWidth + hingeContactShiftLength, printThickness, printThickness])
    cube([doorHingeWidth - hingeContactShiftLength, printThickness, frameHeight]);
    
    translate([-doorHingeWidth, 0, 0])
    linear_extrude(frameHeight + printThickness)
    polygon([[0, 0], [hingeContactShiftLength, printThickness], [hingeContactShiftLength, printThickness * 2], [0, printThickness]]);
    
    translate([-printThickness, -hingeYCenter, 0])
    cube([printThickness, hingeYCenter + printThickness, hingeDepth * hingeConnectorRatio]);
    
    translate([-outerRadius, -hingeYCenter, 0])
    difference() {        
        cylinder(hingeDepth, outerRadius, outerRadius);
        cylinder(hingeDepth, innerRadius, innerRadius);
    }
}

module topFrameHinge(width, height) {
    scale([1, 1, -1]) bottomFrameHinge(width, height);
}

module bottomDoorHinge(hingeBlockModifier = doorHingeLift) {
    innerRadius = (hingeDiameter - hingeWiggle) / 2;
    outerRadius = hingeDiameter / 2 + printThickness;
    
    frameWidth = 2 * printThickness + glassThickness;
    hingeYCenterDistance = outerRadius + hingeDistance;
    hingeBlockHeight = hingeDepth + hingeBlockModifier;
    
    translate([0, 0, hingeDepth - hingeBlockModifier])
    cylinder(hingeBlockHeight, outerRadius, outerRadius);
    cylinder(hingeDepth - hingeBlockModifier, innerRadius, innerRadius);
    
    translate([outerRadius - printThickness, 0, (hingeDepth - hingeBlockModifier) * (2 - hingeConnectorRatio)])
    cube([printThickness, hingeYCenterDistance + 2 * printThickness + glassThickness, hingeBlockHeight * hingeConnectorRatio]);

    difference() {    
        union() {
            translate([-doorHingeWidth + outerRadius, hingeYCenterDistance, 0])
        framePiece(doorHingeWidth);
            
            translate([-doorHingeWidth + outerRadius, hingeYCenterDistance + printThickness, frameHeight + printThickness - doorGripHeight])
            cube([doorHingeWidth - frameHeight - printThickness, doorGripDepth, doorGripHeight]);
            
            translate([-doorHingeWidth + outerRadius, hingeYCenterDistance + printThickness + glassThickness - doorGripDepth, frameHeight + printThickness - doorGripHeight])
            cube([doorHingeWidth - frameHeight - printThickness, doorGripDepth, doorGripHeight]);
            
            translate([outerRadius, hingeYCenterDistance, 0])
            rotate([0, -90, 0])
            framePiece(doorHingeHeight);
        }
        
        translate([outerRadius - printThickness, hingeYCenterDistance, 0])
        cube([printThickness, frameWidth, hingeDepth * (2 - hingeConnectorRatio)]);
        
        translate([-doorHingeWidth + outerRadius, hingeYCenterDistance + glassThickness + printThickness, 0])
        linear_extrude(frameHeight + printThickness)
        polygon([[0, 0], [hingeContactShiftLength, printThickness], [hingeContactShiftLength, printThickness * 2], [0, printThickness]]);
    }
}

module topDoorHinge(width, height) {
    scale([1, 1, -1]) bottomDoorHinge(-doorHingeLift);
}

module doorLock(width) {
    raiserDistance = width / 2 - magnetLength;
    
    middleDoorStop(width);
    
    translate([0, printThickness, printThickness + frameHeight])
    rotate([90, 0, 0])
    linear_extrude(printThickness)
    polygon([
        [0, 0],
        [raiserDistance, frameHeight],
        [width - raiserDistance, frameHeight],
        [width, 0]
    ]);
    
    translate([width / 2 - magnetLength / 2 - printThickness, 0, printThickness + 2])
    magnetBag();
}

module doorHandle() {
    grippingHeight = magnetLength + 4 * printThickness;
    grippingWidth = 2 * magnetWidth + printThickness;
    
    difference() {
        union() {
            cube([printThickness, printThickness + glassThickness, grippingHeight]);
            cube([printThickness + grippingWidth, printThickness, grippingHeight]);
            
            translate([0, printThickness + glassThickness, 0])
            cube([printThickness + grippingWidth, magnetThickness + 0.8, grippingHeight]);
            
            translate([printThickness + grippingWidth - doorGripHeight, printThickness, 0])
            cube([doorGripHeight, doorGripDepth, grippingHeight]);
            
            translate([printThickness + grippingWidth - doorGripHeight, printThickness + glassThickness - doorGripDepth, 0])
            cube([doorGripHeight, doorGripDepth, grippingHeight]);
        }
        
        translate([0, printThickness + glassThickness, 2 * printThickness])
        cube([printThickness + 2 * magnetWidth, magnetThickness, magnetLength]);
    }
    
    diagonalEnd = (1 - handleStraightRate) * handleWidth;
    linear_extrude(handleHeight)
    polygon([
        [0, 0],
        [diagonalEnd, -handleLift],
        [diagonalEnd + printThickness, -handleLift],
        [printThickness, 0]
    ]);
    translate([diagonalEnd, -handleLift, 0])
    cube([handleStraightRate * handleWidth, printThickness, handleHeight]);
}

module magnetBag() {
    cube([magnetLength + 2 * printThickness, printThickness, magnetWidth]);
    
    translate([0, printThickness + magnetThickness, 0])
    cube([magnetLength + 2 * printThickness, printThickness, magnetWidth]);
    
    cube([printThickness, magnetThickness + 2 * printThickness, magnetWidth]);
    
    translate([printThickness + magnetLength, 0, 0])
    cube([printThickness, magnetThickness + 2 * printThickness, magnetWidth]);
}

module ptfePassthrough() {    
    difference() {
        union() {
            translate([0, 0, printThickness])
            cylinder(ptfePassthroughLength, ptfeExitOuterDiameter / 2, ptfeEntryOuterDiameter / 2);
            
            difference() {
                translate([0, 0, ptfePassthroughRounding])
                minkowski() {
                    cylinder(printThickness, ptfeExitOuterDiameter / 2 + ptfePassthroughLip - ptfePassthroughRounding, ptfeExitOuterDiameter / 2 + ptfePassthroughLip - ptfePassthroughRounding);
                    
                    sphere(ptfePassthroughRounding);
                }
                
                cutCubeSize = ptfeExitOuterDiameter + ptfePassthroughLip * 2 + ptfePassthroughRounding * 2;
                
                translate([-cutCubeSize / 2, -cutCubeSize / 2, printThickness])
                cube([cutCubeSize, cutCubeSize, ptfePassthroughRounding * 2]);
            }
        }
        
        cylinder(ptfePassthroughLength + printThickness, ptfeExitInnerDiameter / 2, ptfeEntryInnerDiameter / 2);
    }
}

module ptfePassthroughLock() {
    entryWidth = printThickness / 2;
    difference() {
        cylinder(printThickness, ptfeExitOuterDiameter / 2 + ptfePassthroughLip, ptfeExitOuterDiameter / 2 + ptfePassthroughLip);
        
        cylinder(printThickness, ptfeEntryOuterDiameter / 2, ptfeEntryOuterDiameter / 2);
        
        translate([-entryWidth / 2, 0, 0])
        cube([entryWidth, ptfeExitOuterDiameter + ptfePassthroughLip, printThickness]);
    }
}

topDoorHinge();

/*
// hinge mechanism
color("grey")
bottomFrameHinge(140, 140);
translate([-hingeDiameter / 2 - printThickness, -(hingeDiameter / 2 + hingeDistance + 3 * printThickness + glassThickness), doorHingeLift + 0.1])
rotate([0, 0, 0.5])
bottomDoorHinge();
*/

// window:
//  - 2x middleFrame(166) top/bottom
//  - 2x middleFrame(119) left/right
//  - 4x cornerFrame(140, 140)
/*
cornerFrame(140, 140);
translate([140, 0, 0]) middleFrame(166);
translate([446, 0, 0]) rotate([0, -90, 0]) cornerFrame(140, 140);
translate([2 * 140 + 166, 0, 2* 140 + 119])
rotate([0, 180, 0]) {
    cornerFrame(140, 140);
    translate([140, 0, 0]) middleFrame(166);
    translate([446, 0, 0]) rotate([0, -90, 0]) cornerFrame(140, 140);
}
translate([0, 0, 140 + 119])rotate([0, 90, 0]) middleFrame(119);
translate([2 * 140 + 166, 0, 140])rotate([0, -90, 0]) middleFrame(119);

translate([printThickness, printThickness, printThickness])
color("blue", 0.3)
cube([438, glassThickness, 391]);
*/

// door:
//  - 2x middleDoorStop(166) top/bottom
//  - 1x middleDoorStop(119) right (TODO: leave this out?)
//  - 1x doorLock(119) left
//  - 2x cornerDoorStop(140, 140)
//  - 1x topFrameHinge(140, 140)
//  - 1x bottomFrameHinge(140, 140)
//  - 1x topDoorHinge
//  - 1x bottomDoorHinge
//  - 1x doorHandle
/*
cornerDoorStop(140, 140);
translate([140, 0, 0]) middleDoorStop(166);
translate([446, 0, 0]) bottomFrameHinge(140, 140);
translate([2 * 140 + 166, 0, 2* 140 + 119])
rotate([0, 180, 0]) {
    translate([140, 0, 0]) middleDoorStop(166);
    translate([446, 0, 0]) rotate([0, -90, 0]) cornerDoorStop(140, 140);
}
translate([446, 0, 2 * 140 + 119]) topFrameHinge(140, 140);

translate([0, 0, 140 + 119])rotate([0, 90, 0]) doorLock(119);
translate([2 * 140 + 166, 0, 140])rotate([0, -90, 0]) middleDoorStop(119);

translate([-hingeDiameter / 2 - printThickness + 446, -(hingeDiameter / 2 + hingeDistance + 3 * printThickness + glassThickness), doorHingeLift + 0.1])
rotate([0, 0, 0.0]) {
    bottomDoorHinge();
        
    translate([0, 0, glassHeight + doorHingeLift + printThickness]) topDoorHinge();
    
    translate([-glassWidth, glassThickness + printThickness, glassHeight / 2 - magnetLength / 2])
    doorHandle();

    translate([-glassWidth + hingeDiameter / 2, glassThickness + 2 * printThickness, printThickness])
    color("blue", 0.3)
    cube([glassWidth, glassThickness, glassHeight]);
}
*/