footThickness = 1.2;
standThickness = 3.5;

footLength = 55;
frontExtensionLength = 5;
width = 100;
height = 1.5 * width;

fontWeight = 24;

$fn = $preview ? 40 : 100;

cube([footLength, width, footThickness]);

translate([footLength, 0, 0]) {
    cube([standThickness, width, fontWeight]);
    cube([standThickness, fontWeight, height]);
    
    translate([standThickness, 0, 0])
    difference() {
        cube([frontExtensionLength, width, frontExtensionLength]);
        
        translate([frontExtensionLength, 0, frontExtensionLength + footThickness])
        rotate([-90, 0, 0])
        cylinder(width, r = frontExtensionLength);
    }
}