thickness = 2;

shellyWidth = 34;
shellyDepth = 29;
shellyHeight = 16 + 2;
shellyGrip = 3;

wagoWidth = 30;
wagoDepth = 18.4;
wagoHeight = 2 * 8.2 + 2; // 2 stacked
wagoGrip = 1;

cableBoxDepth = 20;

cableADiameter = 5.5;
cableBSize = [8, 6];
cableBRounding = 1;
cableBOffset = 4;
cableCDiameter = 5.5;
cableCOffset = 6;

capGap = 1;
capTolerance = 0.2;

moduleDepth = max(shellyDepth, wagoDepth);
moduleHeight = max(shellyHeight, wagoHeight);

cableCenterY = 2 * thickness + moduleDepth + cableBoxDepth / 2;

boxWidth = 3 * thickness + shellyWidth + wagoWidth;
boxDepth = 3 * thickness + moduleDepth + cableBoxDepth;
boxHeight = 2 * thickness + moduleHeight;

cableClipOpeningD = 4;
cableClipOpeningW = 4;
cableClipOpeningH = 2;
cableClipHeight = cableClipOpeningH + thickness;

$fa = $preview ? 1 : 0.4;
$fs = $preview ? 1 : 0.4;

module box() {
    color("red")
    cube([boxWidth, boxDepth, thickness]);
    
    difference() {
        cube([boxWidth, thickness, boxHeight]);
        
        capCutout();
    }
    
    difference() {
        translate([0, boxDepth - thickness, 0])
        cube([boxWidth, thickness, boxHeight]);
        
        capCutout();
    }
    
    difference() {
        cube([thickness, boxDepth, boxHeight]);
        
        translate([-0.01, cableCenterY, thickness + cableClipHeight + cableADiameter / 2])
        rotate([0, 90, 0])
        linear_extrude(thickness + 0.02)   
        circle(d = cableADiameter);
        
        capCutout();
    }
    
    translate([thickness, cableCenterY - cableClipOpeningD / 2, thickness])
    cableClip();
    
    difference() {
        translate([boxWidth - thickness, 0, 0]) {
            difference() {
                cube([thickness, boxDepth, boxHeight]);
                
                translate([-0.01, cableCenterY + cableBOffset, thickness + cableClipHeight + cableBSize.x / 2])
                rotate([0, 90, 0])
                linear_extrude(thickness + 0.02)
                offset(cableBRounding)
                offset(-cableBRounding)
                square([cableBSize.x, cableBSize.y], center = true);
                
                translate([-0.01, cableCenterY - cableCOffset, thickness + cableClipHeight + cableCDiameter / 2])
                rotate([0, 90, 0])
                linear_extrude(thickness + 0.02)   
                circle(d = cableCDiameter);
            }
        }
        
        capCutout();
    }
    
    translate([boxWidth - thickness, cableCenterY + cableBOffset - cableClipOpeningD / 2, thickness])
    scale([-1, 1, 1])
    cableClip();
    
    translate([boxWidth - thickness, cableCenterY - cableCOffset - cableClipOpeningD / 2, thickness])
    scale([-1, 1, 1])
    cableClip();
    
    translate([thickness + shellyWidth, thickness, thickness])
    cube([thickness, moduleDepth + thickness, moduleHeight]);
    
    translate([thickness, thickness, thickness])
    cube([shellyWidth, shellyDepth, moduleHeight - shellyHeight]);
    
    translate([thickness, thickness + shellyDepth, thickness])
    cube([shellyGrip, thickness, moduleHeight]);
    
    translate([thickness + shellyWidth - shellyGrip, thickness + shellyDepth, thickness])
    cube([shellyGrip, thickness, moduleHeight]);
    
    translate([2 * thickness + shellyWidth, thickness + wagoDepth, thickness])
    cube([wagoGrip, thickness, moduleHeight]);
    
    translate([2 * thickness + shellyWidth + wagoWidth - wagoGrip, thickness + wagoDepth, thickness])
    cube([wagoGrip, thickness, moduleHeight]);
}

module cableClip() {
    translate([0, 0, cableClipOpeningH])
    cube([cableClipOpeningW, cableClipOpeningD, thickness]);
    
    translate([cableClipOpeningW, 0, 0])
    cube([thickness, cableClipOpeningD, cableClipOpeningH + thickness]);
}

module cap(t = 0) {
    translate([0, -t, 0])
    hull() {
        cube([boxWidth - capGap + t, boxDepth - 2 * capGap + 2*t, 0.01]);
        
        translate([0, capGap + thickness / 2, thickness - 0.01])
        cube([boxWidth - capGap - thickness + t, boxDepth - 2 * capGap - 2 * thickness + 2 * t, 0.01]);
    }
    
    translate([thickness + 0.4, (boxDepth - 4) / 2, -0.6])
    cube([2, 4, 0.6]);
}

module capCutout() {
    translate([0, capGap, boxHeight - thickness])
    cap(capTolerance);
}

module testAssembly() {
    translate([-5, boxDepth / 2, boxHeight / 2])
    rotate([0, 90, 0])
    linear_extrude(boxWidth + 10)
    difference() {        
        circle(d = 71);
        circle(d = 70);
    }
    
    box();
    
    translate([0, capGap, boxHeight - thickness])
    cap();
}

module printLayout() {
    box();
    
    translate([0, -10, thickness])
    rotate([180, 0, 0])
    cap();
}

printLayout();