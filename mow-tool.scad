length = 100;
diameter = 4;
handleWidth = 120;
handleHeight = 20;
thickness = 30;

stickWidth = 6;
stickLead = 10;

$fa = 0.2;
$fs = 0.2;

linear_extrude(thickness) {
    difference() {
        hull() {
            square([diameter, length]);
            
            translate([(diameter / 2) - 1 + stickWidth / 2, stickLead])
            square([1, length - stickLead]);
            
            translate([(diameter / 2) - stickWidth / 2, stickLead])
            square([1, length - stickLead]);
        }
        
        translate([diameter / 2, 0, 0])
        circle(d = diameter);
    }
    
    translate([(diameter - handleWidth) / 2, length])
    square([handleWidth, handleHeight]);
}