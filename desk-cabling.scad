width = 80;
sideMargin = 12;
thickness = 2;
deskPlateThickness = 34;
grabDepth = 40;
holderHeight = 20;

cableDiameters = [7, 5, 5, 4];

module cableHole(cableDiameter) {
    radius = (cableDiameter + 2) / 2;
    holeDepth = holderHeight / 2;
    translate([0, thickness * 1.5, 2*thickness + deskPlateThickness + holderHeight - holeDepth])
    rotate([90, 0, 0]) {
        cylinder(thickness * 2, radius, radius);
    
        translate([-cableDiameter / 2, 0, 0])
        cube([cableDiameter, holeDepth + 1, thickness * 2]);
    }
}

difference() {
    cube([width, thickness, 2*thickness + deskPlateThickness + holderHeight]);
    
    spacing = (width - 2 * sideMargin) / (len(cableDiameters) - 1);
    start = width - sideMargin;
    
    for(index = [0 : len(cableDiameters) - 1]) {
        translate([start - spacing * index, 0, 0]) cableHole(cableDiameters[index]);
    }
}

translate([0, thickness, 0])
cube([width, grabDepth, thickness]);

translate([0, thickness, thickness + deskPlateThickness])
cube([width, grabDepth, thickness]);