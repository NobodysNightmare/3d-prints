innerRadius = 16.5 / 2;
openWidth = 1.5;
thickness = 3;
width = 12;
spikeLength = 15;
groundClearance = 2;

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
        
        groundRemoverHeight = thickness + spikeLength;
        translate([0, -(innerRadius + groundClearance + groundRemoverHeight / 2), 0])
            square([innerRadius * 2 + thickness * 2 + spikeLength, groundRemoverHeight], true);
    }
}