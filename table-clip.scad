width = 15;
height = 29;
depth = 20;
thickness = 2;

rounding = 0.5;
gripRadius = 2;

$fn = $preview ? 64 : 128;

linear_extrude(width) {
    square([thickness, depth]);
    
    translate([thickness + height, 0])
    offset(rounding)
    offset(-rounding)
    square([thickness, depth + thickness]);
    
    translate([0, depth])
    square([2*thickness + height, thickness]);
    
    translate([thickness, gripRadius])
    circle(r=gripRadius);
}