// Total width:  446 mm
// Total height: 399 mm
// frame thickness 2 * 2 mm = 4 mm
// Glass tolerance 2 * 2 mm = 4 mm
// -------------------------------
// Glass width = 438 mm
// Glass height = 391 mm

use <modules/screw-hole.scad>;

printThickness = 2;
glassThickness = 3;
frameHeight = 12;

screwHeadDiameter = 4; // TODO
screwHeadHeight = 1; // TODO
screwDiameter = 3; // TODO
screwMargin = 5;
screwSideMargin = 12;

magnetLength = 20;
magnetWidth = 10;
magnetThickness = 2;

hingeDiameter = 5;
hingeDepth = 40;
hingeDistance = 0.5;
hingeConnectorRatio = 0.9;
hingeWiggle = 0.2;

doorHingeWidth = 80;
doorHingeHeight = 80;

$fa = 0.2;
$fs = 0.5;

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
    
    translate([-doorHingeWidth, printThickness, printThickness])
    cube([doorHingeWidth, printThickness, frameHeight]);
    
    // TODO: diagonal change from normal frame level to
    // hinged frame level (instead of sudden shift by 2 mm)
    
    translate([-printThickness, -hingeYCenter, 0])
    cube([printThickness, hingeYCenter, hingeDepth * hingeConnectorRatio]);
    
    translate([-outerRadius, -hingeYCenter, 0])
    difference() {        
        cylinder(hingeDepth, outerRadius, outerRadius);
        cylinder(hingeDepth, innerRadius, innerRadius);
    }
}

module topFrameHinge(width, height) {
    scale([1, 1, -1]) bottomFrameHinge(width, height);
}

module bottomDoorHinge() {
    // TODO: leave space below door frame
    innerRadius = (hingeDiameter - hingeWiggle) / 2;
    outerRadius = hingeDiameter / 2 + printThickness;
    
    frameWidth = 2 * printThickness + glassThickness;
    hingeYCenterDistance = outerRadius + hingeDistance;
    
    translate([0, 0, hingeDepth])
    cylinder(hingeDepth, outerRadius, outerRadius);
    cylinder(hingeDepth, innerRadius, innerRadius);
    
    translate([outerRadius - printThickness, 0, hingeDepth * (2 - hingeConnectorRatio)])
    cube([printThickness, hingeYCenterDistance, hingeDepth * hingeConnectorRatio]);

    difference() {    
        union() {
            translate([-doorHingeWidth + outerRadius, hingeYCenterDistance, 0])
        framePiece(doorHingeWidth);
            
            translate([outerRadius, hingeYCenterDistance, 0])
            rotate([0, -90, 0])
            framePiece(doorHingeHeight);
        }
        
        translate([outerRadius - printThickness, hingeYCenterDistance, 0])
        cube([printThickness, frameWidth, hingeDepth * (2 - hingeConnectorRatio)]);
    }
}

module doorLock(width) {
    // TODO: accomodate door handle
    middleDoorStop(width);
    
    translate([width / 2 - magnetLength / 2 - printThickness, 0, printThickness])
    magnetBag();
}

module magnetBag() {
    cube([magnetLength + 2 * printThickness, printThickness, magnetWidth]);
    
    translate([0, printThickness + magnetThickness, 0])
    cube([magnetLength + 2 * printThickness, printThickness, magnetWidth]);
    
    cube([printThickness, magnetThickness + 2 * printThickness, magnetWidth]);
    
    translate([printThickness + magnetLength, 0, 0])
    cube([printThickness, magnetThickness + 2 * printThickness, magnetWidth]);
}

color("grey")
bottomFrameHinge(140, 140);
translate([-hingeDiameter / 2 - printThickness, -(hingeDiameter / 2 + hingeDistance + 3 * printThickness + glassThickness), 0.1])
rotate([0, 0, 0])
bottomDoorHinge();

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

// TODO: position glass correctly
// TODO: attach glass elements (hinges and handle)

translate([printThickness, -glassThickness, printThickness])
color("blue", 0.3)
cube([438, glassThickness, 391]);
*/