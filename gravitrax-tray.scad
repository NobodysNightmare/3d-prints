size = 320;
height = 17.32;
wallT = 1.2;

stdWidth = 60;
stdDepth = 11;

spacerWidth = 53;
spacerHeight = 100;

smHex = 34.2;

railBottomT = 5;
railAreaDepth = smHex * 1.75;

targetMargins = [2, 4];

cols = floor((size - targetMargins.x) / (stdWidth + targetMargins.x));
rows = 10;
margins = [
    (size - cols * stdWidth) / (cols + 1),
    targetMargins.y
];

spacerBoxDepth = spacerWidth + 2 * wallT;

module standardInset() {
    rotate([90, 0, 0])
    linear_extrude(stdDepth)
    polygon([
        [0, height + 0.01],
        [stdWidth / 2, 0],
        [stdWidth, height + 0.01]
    ]);
}

module hexagon(d) {
    rotate([0, 0, 90])
    circle(d = d, $fn = 6);
}

difference() {
    union() {
        cube([size, size, height]);
        
        translate([0, size - spacerWidth - 2 * wallT, 0])
        cube([size, spacerBoxDepth, spacerHeight]);
    }
    
    for(ix = [1:cols]) {
        for(iy = [1:rows])
        translate([ix * margins.x + (ix - 1) * stdWidth,
                   iy * margins.y +  iy * stdDepth,
                   0])
        standardInset();
    }
    
    translate([wallT, size - spacerWidth - wallT, wallT])
    cube([size - 2 * wallT, spacerWidth, spacerHeight]);
    
    translate([-0.01, size - spacerBoxDepth - railAreaDepth, railBottomT])
    cube([size + 0.02, railAreaDepth, height]);
    
    translate([smHex / 2 - 2.1 + 50, size - spacerBoxDepth - smHex / 2 - 0.75 * smHex, -0.01])
    linear_extrude(height + 0.02)
    hexagon(smHex);
    
    translate([smHex / 2 - 2.1 + 80, size - spacerBoxDepth - smHex / 2, -0.01])
    linear_extrude(height + 0.02)
    hexagon(smHex);
    
    translate([smHex / 2 - 2.1 + 80 + 30 + 128, size - spacerBoxDepth - smHex / 2, -0.01])
    linear_extrude(height + 0.02)
    hexagon(smHex);
}

