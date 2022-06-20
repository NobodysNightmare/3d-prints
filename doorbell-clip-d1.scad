clipHeight = 49.7026;
clipWidth = 10;

clipHookThickness = 2;
clipHookOpening = 2.5;
clipHookDepth = 5;

buildPlateX = 13.0;

mountBottomThickness = 2;
mountBackgroundThickness = 1.2;
mountGripThickness = 3;

mountGripHeightOffset = 4;
mountGripHeight = 5;
mountGripLength = 20 + 7;
mountGripLengthSpacer = 7;

pinDistance = 22.86;
pinThickness = 2.5;

moduleHeight = 34; // TODO

moduleMountWidth = pinDistance + pinThickness + 2 * mountGripThickness;
moduleMountHeight = moduleHeight + mountBottomThickness;
moduleMountDepth = mountBackgroundThickness + mountGripHeightOffset + mountGripHeight;

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
    cube([mountBackgroundThickness, moduleMountHeight, moduleMountWidth]);
    cube([moduleMountDepth, mountBottomThickness, moduleMountWidth]);
    
    translate([mountBackgroundThickness + mountGripHeightOffset, 0, 0]) {
        cube([mountGripHeight, mountGripLength, mountGripThickness]);
        
        translate([0, 0, mountGripThickness])
        cube([mountGripHeight, mountGripLengthSpacer, pinThickness]);
        
        translate([0, 0, mountGripThickness + pinThickness])
        cube([mountGripHeight, mountGripLength, mountGripThickness]);
        
        translate([0, 0, pinDistance]) {
            cube([mountGripHeight, mountGripLength, mountGripThickness]);
            
            translate([0, 0, mountGripThickness])
            cube([mountGripHeight, mountGripLengthSpacer, pinThickness]);
        
            translate([0, 0, mountGripThickness + pinThickness])
            cube([mountGripHeight, mountGripLength, mountGripThickness]);
        }
    }
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

