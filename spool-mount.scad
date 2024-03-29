rodLength = 102;
rodDiameter = 8.6;

rodGrip = 12;
rodLeadInFactor = 1.25;
radialThickness = 8;
sideThickness = 8;

spoolRadius = 102.5;
spoolWidth = 60;
spoolRadialMargin = 40;

baseThickness = 5;
baseLength = 140;

// 3.5 x 25 mm
screwHeadDiameter = 6.8;
screwHeadHeight = 2;
screwDiameter = 3.5;
screwMargin = 12;

bearingDiameter = 22 + 0.4;
bearingWidth = 7;
bearingGripDiameter = 15;
bearingOverhangGrip = 2;
bearingOverhangThickness = 1;
spoolInnerDiameter = 51.5;

adapterDepth = 20;
adapterGrowth = 0.5;
adapterInsertShrink = 2;
adapterInsertLength = 4;
adapterThickness = 3;
adapterGap = 10;
adapterOverhang = 12;
adapterOverhangThickness = 5;

armWidth = rodGrip + sideThickness;
armDepth = rodDiameter + 2 * radialThickness;
armLength = spoolRadius + spoolRadialMargin;
baseWidth = rodLength + 2 * (armWidth - rodGrip);

rodLeadInDiameter = rodLeadInFactor * rodDiameter;
leadInHeight = spoolRadialMargin / 2;
insertChamferHeight = leadInHeight / 2;

$fs = $preview ? 1 : 0.5;
$fa = $preview ? 1 : 0.5;

use <modules/screw-hole.scad>;

module mount() {
    basePlate();
    
    translate([armWidth, 0, baseThickness])
    scale([-1, 1, 1])
    arm();
    
    translate([rodLength - rodGrip + sideThickness, 0, baseThickness])
    arm();
}

module arm() {
    difference() {
        hull() {
            cube([armWidth, armDepth, 0.1]);
            
            translate([0, armDepth / 2, armLength])
            rotate([0, 90, 0])
            cylinder(armWidth, d = armDepth);
        }
        
        hull() {
            translate([rodGrip, armDepth / 2, armLength])
            rotate([0, -90, 0])
            cylinder(armWidth, d = rodDiameter);
            
            translate([rodGrip, armDepth / 2 + (rodLeadInDiameter - rodDiameter) / 2, armLength - leadInHeight])
            rotate([0, -90, 0])
            cylinder(armWidth, d = rodLeadInDiameter);
        }
        
        hull() {            
            translate([rodGrip, armDepth / 2 + (rodLeadInDiameter - rodDiameter) / 2, armLength - leadInHeight])
            rotate([0, -90, 0])
            cylinder(armWidth, d = rodLeadInDiameter);
            
            translate([rodGrip, armDepth, armLength - leadInHeight])
            rotate([0, -90, 0])
            cylinder(armWidth, d = rodLeadInDiameter);
        }
        
        translate([0, armDepth + 0.01, armLength - leadInHeight + rodLeadInDiameter / 2 - 0.01])
        rotate([90, 0, 0])
        linear_extrude(radialThickness)
        polygon([
            [-0.01, 0],
            [rodGrip, 0],
            [-0.01, insertChamferHeight]
        ]);
    }
}

module basePlate() {
    translate([0, -(baseLength - armDepth) / 2, 0])
    difference() {
        cube([baseWidth, baseLength, baseThickness]);
    
        translate([screwMargin, screwMargin, baseThickness])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        
        translate([baseWidth - screwMargin, screwMargin, baseThickness])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        
        translate([baseWidth - screwMargin, baseLength - screwMargin, baseThickness])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
        
        translate([screwMargin, baseLength - screwMargin, baseThickness])
        screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight);
    }
}

module adapter() {
    intersection() {
        linear_extrude(adapterOverhangThickness)
        difference() {
            circle(d = spoolInnerDiameter + adapterOverhang);
            
            circle(d = bearingGripDiameter);
            
            distance = spoolInnerDiameter / 2 + adapterOverhang;            
            for(angle = [0:90:359])
            translate([distance * sin(angle), distance * cos(angle)])
            circle(r = adapterOverhang);
        }
        
        translate([0, 0, -adapterOverhangThickness])
        sphere(d = spoolInnerDiameter + adapterOverhang);
    }
    
    translate([0, 0, adapterOverhangThickness])
    difference() {
        union() {
            cylinder(adapterDepth - adapterInsertLength, d1 = spoolInnerDiameter, d2 = spoolInnerDiameter + adapterGrowth);
            
            translate([0, 0, adapterDepth - adapterInsertLength])
            cylinder(adapterInsertLength, d1 = spoolInnerDiameter + adapterGrowth, d2 = spoolInnerDiameter - adapterInsertShrink);
        }
        
        translate([0, 0, -0.01]) {
            cylinder(adapterDepth + 0.02, d = spoolInnerDiameter - 2 * adapterThickness);
            
            translate([-spoolInnerDiameter, -adapterGap / 2, 0])
            cube([2 * spoolInnerDiameter, adapterGap, adapterDepth + 0.02]);
            
            translate([-adapterGap / 2, -spoolInnerDiameter, 0])
            cube([adapterGap, 2 * spoolInnerDiameter, adapterDepth + 0.02]);
        }
    }
    
    translate([0, 0, adapterOverhangThickness])
    difference() {
        cylinder(bearingWidth + bearingOverhangThickness, d = bearingDiameter + 2 * adapterThickness);
        
        translate([0, 0, -0.01])
        cylinder(bearingWidth + 0.01, d = bearingDiameter);
        
        translate([0, 0, 0.01])
        cylinder(bearingWidth * 2, d = bearingDiameter - 2 * bearingOverhangGrip);
    }
}

module testAssembly() {
    mount();
    
    color("red")
    translate([armWidth - rodGrip + 0.2, armDepth / 2, baseThickness + armLength - 0.2])
    rotate([0, 90, 0])
    cylinder(rodLength - 0.4, d = rodDiameter - 0.4);
    
    color("green")
    translate([armWidth + 9, armDepth / 2, baseThickness + armLength - 0.2])
    rotate([0, 90, 0])
    cylinder(spoolWidth, d = spoolRadius * 2);
    
    translate([armWidth + 9 - adapterOverhangThickness, armDepth / 2, baseThickness + armLength - 0.2])
    rotate([0, 90, 0])
    adapter();
    
    translate([armWidth + 9 + spoolWidth + adapterOverhangThickness, armDepth / 2, baseThickness + armLength - 0.2])
    rotate([0, -90, 0])
    adapter();
}

adapter();