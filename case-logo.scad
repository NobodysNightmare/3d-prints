use <modules/nn-logo.scad>

thickness = 3;
size = 49;

logoThickness = 1;
logoBorder = 1.5;
logoBorderMargin = 1;

magnet = [20, 10, 2];

logoReduce = 2 * (logoBorder + logoBorderMargin);

$fn = $preview ? 64 : 128;

module caseLogo() {
    base();
    
    translate([size/2, size/2, 0])
    rotate([0, 180, 0])
    linear_extrude(logoThickness)
    nnCutout(size - logoReduce);
    
    translate([0, 0, -logoThickness])
    linear_extrude(logoThickness)
    difference() {
        square([size, size]);
        
        translate([logoBorder, logoBorder])
        square([size - 2 * logoBorder, size - 2 * logoBorder]);
    }
}

module base() {
    difference() {
        intersection() {
            cube([size, size, thickness]);
            
            edgeCutter();
            
            translate([size, size, 0])
            rotate([0, 0, 180])
            edgeCutter();
            
            translate([size, 0, 0])
            rotate([0, 0, 90])
            edgeCutter();
            
            translate([0, size, 0])
            rotate([0, 0, -90])
            edgeCutter();
        }
        
        translate([(size - magnet.x) / 2, (size - magnet.y) / 2, thickness - magnet.z])
        cube(magnet);
    }
}

module edgeCutter() {
    intersection() {
        cube([size, thickness, thickness]);
        
        translate([0, thickness, 0])
        rotate([0, 90, 0])
        cylinder(h=size, r=thickness);
    }
    
    translate([0, thickness, 0])
    cube([size, size, thickness]);
}

caseLogo();