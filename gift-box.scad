// Simple gift box consisting of upper and lower part
// Possible outputs (see end of file):
// * printArrangement(): upper and lower part next to each other in print orientation (default)
// * lowerBox(): bottom part of the box
// * upperBox(): top part of the box
// * assembledTestCut(): showing how parts would look stacked together (cut in the middle to inspect interface)
// * assembledTest(): showing how parts would look stacked together

// inner dimensions of the box
// Example dimensions:
// * credit card: 88x56x6
// * Steam gift card (in germany): 135x88x6
// * Box holding a few of my dice: 70x40x25
innerWidth = 88;
innerDepth = 56;
innerHeight = 6;

// How much of the innerHeight should be dedicated to holding the two pieces together
// value is in percent (0.0 - 1.0)
// Recommendations:
// * flat boxes: 0.5 (credit cards, etc.)
// * higher boxes: 0.1 - 0.2
overlapPercent = 0.5;

// thickness of the perimeter walls (half of that for interface between top and bottom)
wallThickness = 3.0;

// thickness of top and bottom solid faces
topBottomThickness = 2.1;

// how far diagonal edges cut into walls
edgeCut = 1;

// width and depth of the "gift wrap" marks that are inset into the surfaces
giftWrapMarkWidth = 1.2;
giftWrapMarkDepth = 0.6;

// total width of each piece of gift wrap
giftWrapWidth = 0.2 * min(innerWidth, innerDepth);

// At which height (relative to the box size) the seam separating
// upper and lower part should be placed
seamRelativeZ = 0.75;

overlapWallThickness = wallThickness * 0.5;
overlapTolerance = 0.2;


// purely computed values, should not be necessary to touch these
absoluteOverlap = overlapPercent * innerHeight;
lowerHeight = innerHeight * seamRelativeZ;
upperHeight = innerHeight * (1 - seamRelativeZ) + absoluteOverlap;
edgeCutterSize = 3 * max(innerWidth, innerDepth, innerHeight);

module lowerBox() {
    difference() {
        baseShape(innerWidth, innerDepth, lowerHeight);
        
        translate([overlapWallThickness - overlapTolerance, overlapWallThickness - overlapTolerance, lowerHeight + topBottomThickness - absoluteOverlap])
        cube([innerWidth + 2 * (overlapWallThickness + overlapTolerance), innerDepth + 2 * (overlapWallThickness + overlapTolerance), absoluteOverlap + 0.01]);
    }
}

module upperBox() {
    difference() {
        baseShape(innerWidth, innerDepth, upperHeight);
        
        translate([0, 0, upperHeight + topBottomThickness - absoluteOverlap])
        difference() {
            translate([-0.01, -0.01, 0])
            cube([innerWidth + 2 * wallThickness + 0.02, innerDepth + 2 * wallThickness + 0.02, absoluteOverlap + 0.01]);
            
            translate([overlapWallThickness, overlapWallThickness, -0.01])
            cube([innerWidth + 2 * overlapWallThickness, innerDepth + 2 * overlapWallThickness, absoluteOverlap + 0.03]);
        }
    }
}

module baseShape(w, d, h) {
    difference() {
        cube([w + 2 * wallThickness, d + 2 * wallThickness, h + topBottomThickness]);
        
        translate([wallThickness, wallThickness, topBottomThickness])
        cube([w, d, h + 0.01]);
        
        translate([0, edgeCut, 0])
        edgeCutter(45, 0);
        
        translate([0, d + 2 * wallThickness - edgeCut, 0])
        edgeCutter(45, 180);
        
        translate([edgeCut, 0, 0])
        edgeCutter(45, -90);
        
        translate([w + 2 * wallThickness - edgeCut, 0, 0])
        edgeCutter(45, 90);
        
        translate([wallThickness + innerWidth / 2, 0, 0])
        giftWrap();
        
        translate([0, wallThickness + innerDepth / 2, 0])
        rotate([0, 0, 90])
        giftWrap();
        
        translate([wallThickness + innerWidth / 2, 0, 0])
        rotate([-90, 0, 0])
        giftWrap();
        
        translate([wallThickness + innerWidth / 2, innerDepth + 2 * wallThickness, 0])
        rotate([90, 0, 0])
        giftWrap();
        
        translate([0, wallThickness + innerDepth / 2, 0])
        rotate([90, 0, 90])
        giftWrap();
        
        translate([innerWidth + 2 * wallThickness, wallThickness + innerDepth / 2, 0])
        rotate([-90, 0, 90])
        giftWrap();
    }
}

module edgeCutter(rx, rz) {
    rotate([rx, 0, rz])
    translate([-edgeCutterSize / 2, -edgeCutterSize, -edgeCutterSize / 2])
    cube(edgeCutterSize);
}

module giftWrap() {
    translate([-(giftWrapWidth + giftWrapMarkWidth) / 2, -edgeCutterSize / 2, -0.01])
    cube([giftWrapMarkWidth, edgeCutterSize, giftWrapMarkDepth + 0.01]);
    
    translate([(giftWrapWidth - giftWrapMarkWidth) / 2, -edgeCutterSize / 2, -0.01])
    cube([giftWrapMarkWidth, edgeCutterSize, giftWrapMarkDepth + 0.01]);
}

module assembledTest() {
    lowerBox();
    
    translate([0, innerDepth + 2 * wallThickness, innerHeight + 2 * topBottomThickness + overlapTolerance])
    rotate([180, 0, 0])
    upperBox();
}

module assembledTestCut() {
    difference() {
        assembledTest();
        
        translate([wallThickness + innerWidth / 2, -0.01, -0.01])
        cube([innerWidth, innerDepth * 4, innerHeight * 4]);
    }
}

module printArrangement() {
    lowerBox();
    
    translate([0, innerDepth + 4 * wallThickness, 0])
    upperBox();
}

assembledTestCut();