standFrameThickness = 12.5;
standFrameWidth = 156;
standFrameLift = 0.6;
standHeight = 10;
standSideMargin = 3;
standFrontMargin = 12;
standRoundness = 5;

$fn = $preview ? 32 : 64;

module stand() {
    difference() {
        translate([standRoundness, standRoundness, 0])
        linear_extrude(standHeight)
        hull() {
            translate([0, 0])
            circle(standRoundness);
            
            translate([2 * standSideMargin + standFrameWidth - 2 * standRoundness, 0])
            circle(standRoundness);
            
            translate([0, 2 * standFrontMargin + standFrameThickness - 2 * standRoundness])
            circle(standRoundness);
            
            translate([2 * standSideMargin + standFrameWidth - 2 * standRoundness, 2 * standFrontMargin + standFrameThickness - 2 * standRoundness])
            circle(standRoundness);
        }
        
        translate([standSideMargin, standFrontMargin, standFrameLift])
        cube([standFrameWidth, standFrameThickness, standHeight]);
    }
}

stand();