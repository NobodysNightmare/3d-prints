height = 160;
depth = 250;
width = 35;
flatT = 20;

screwWallDelta = 10;
screwWoodDelta = 7.5; // 25mm screw should leave 4mm space in 18mm of wood

chamferH = width / 2;
chamferInset = width;

use <modules/screw-hole.scad>

module shelf() {
    difference() {
        shelfBody();
        
        translate([5 + screwWallDelta, height / 4, width / 2])
        rotate([0, 90, 0])
        screwHole(5, 10, 5, screwDepth = 50, screwHeadLead = flatT + chamferH + 5);
        
        translate([5 + screwWallDelta, height * 3 / 4, width / 2])
        rotate([0, 90, 0])
        screwHole(5, 10, 5, screwDepth = 50, screwHeadLead = flatT + chamferH + 5);
        
        translate([depth * 3 / 4, height + flatT - (3.5 + screwWoodDelta), width / 2])
        rotate([90, 0, 0])
        screwHole(3.5, 7, 3.5, screwDepth = 50, screwHeadLead = flatT + chamferH + 5);
        
        translate([depth / 4, height + flatT - (3.5 + screwWoodDelta), width / 2])
        rotate([90, 0, 0])
        screwHole(3.5, 7, 3.5, screwDepth = 50, screwHeadLead = flatT + chamferH + 5);
    }
}

module shelfBody() {
    cube([flatT, height, width]);
    
    translate([0, height, 0])
    cube([depth, flatT, width]);
    
    translate([flatT, 0, 0])
    chamfer(height);
    
    translate([depth, height, 0])
    scale([-1, 1, 1])
    rotate([0, 0, -90])
    chamfer(depth - flatT);
}

module chamfer(length) {
    polyhedron(
        points = [
            [0, 0, 0],
            [0, length, 0],
            [0, length, width],
            [0, 0, width],
            [chamferH, chamferInset, width / 2],
            [chamferH, length, width / 2]
        ],
        faces = [
            [0, 1, 2, 3],
            [1, 5, 2],
            [0, 3, 4],
            [3, 2, 5, 4],
            [4, 5, 1, 0]
        ]
    );
}

module demo() {
    color("blue")
    cube([3000, 1, 2500]);
    
    color("white")
    translate([200, 0, 1000])
    rotate([90, 0, -90])
    shelf();
    
    color("brown")
    translate([100, -300, 1000 + height + flatT])
    cube([2500, 300, 18]);
}

shelf();