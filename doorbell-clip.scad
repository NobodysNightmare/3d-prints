clipHeight = 49.7026;
clipWidth = 10;

clipHookThickness = 2;
clipHookOpening = 2.5;
clipHookDepth = 5;

buildPlateX = 13.0;

mountThickness = 1.2;
sideThickness = 0.6;
gripOverlap = 0.7;

heightTolerance = 0.25;
thicknessTolerance = 0.1;
undersideTolerance = 2.4;

guardDistance = 16.5;
guardHeight = 16;

moduleHeight = 25.3;
moduleWidth = 40;
modulePlateThickness = 1.6;

moduleMountWidth = moduleWidth + sideThickness;
moduleMountHeight = moduleHeight + 2 * (heightTolerance + mountThickness);
moduleMountDepth = mountThickness + undersideTolerance + thicknessTolerance + modulePlateThickness + mountThickness;

// Original CC-BY Robert Hunt:
// https://www.thingiverse.com/thing:101024
module dinClip() {
    translate([13.78, -0.15, 0])
    scale([-1, 1, 1])
	difference() {
		linear_extrude(height=clipWidth, convexity=5)
        import(file="din_clip_01.dxf", layer="0", $fn=64);
    }
}

module moduleMount() {
    cube([mountThickness, moduleMountHeight, moduleMountWidth]);
    cube([moduleMountDepth, moduleMountHeight, sideThickness]);
    
    mountGrip();
    
    translate([0, moduleMountHeight, 0])
    scale([1, -1, 1])
    mountGrip();
    
    guard();
}

module mountGrip() {
    cube([moduleMountDepth, mountThickness, moduleMountWidth]);
    
    translate([mountThickness + undersideTolerance - thicknessTolerance - mountThickness, 0, 0])
    cube([mountThickness, mountThickness + gripOverlap, moduleMountWidth]);
    
    translate([mountThickness + undersideTolerance + modulePlateThickness + thicknessTolerance, 0, 0])
    cube([mountThickness, mountThickness + gripOverlap, moduleMountWidth]);
}

module guard() {
    cube([moduleMountDepth + guardDistance, mountThickness, moduleMountWidth]);
    
    cube([moduleMountDepth + guardDistance, guardHeight + mountThickness, sideThickness]);
    
    translate([moduleMountDepth + guardDistance - mountThickness, 0, 0])
    cube([mountThickness, guardHeight + mountThickness, moduleMountWidth]);
}

module clipHook() {
    difference() {
        cube([clipHookDepth, clipHookThickness + clipHookOpening, clipWidth]);
        
        translate([0, clipHookThickness, clipHookThickness])
        cube([clipHookDepth, clipHookOpening, clipWidth - 2 * clipHookThickness]);
    }
}

module fullAssembly() {
    dinClip();
    
    translate([-clipHookDepth, -clipHookThickness - clipHookOpening, 0])
    clipHook();
    
    translate([buildPlateX, (clipHeight - moduleMountHeight), (clipWidth - moduleMountWidth) / 2])
    moduleMount();
}

fullAssembly();

