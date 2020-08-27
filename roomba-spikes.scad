innerRadius = 20;
openWidth = 32;
thickness = 5;
width = 10;
spikeLength = 20;

linear_extrude(width) {
    difference() {
        union() {
            circle(innerRadius + thickness);
            for (rotation = [45:90:315]) {
                rotate([0, 0, rotation])
                translate([innerRadius + spikeLength / 2 + thickness / 2, 0, 0])
                    square([spikeLength, thickness], true);
            }
        }
        circle(innerRadius, $fa = 6);
        translate([0, -innerRadius, 0])
            square([openWidth, thickness + innerRadius], true);
        
        groundClearHeight = thickness + spikeLength;
        translate([0, -(innerRadius + groundClearHeight / 2), 0])
            square([innerRadius * 2 + thickness + spikeLength, groundClearHeight], true);
    }
}