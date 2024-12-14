size = 320;
height = 17.32;
wallT = 1.2;

spacerWidth = 53;
spacerHeight = 70;
spacerBoxGrip = 10;

spacerBoxDepth = spacerWidth + 2 * wallT;

smHex = 34.6;
hexFloor = 0.2;
hexHoleD = 20;

railBottomT = 5;
railAreaDepth = smHex * 1.75;

stdWidth = 60;
stdDepth = 11;

trayDepth = size - spacerBoxDepth - railAreaDepth;
targetMargins = [2, 4];

cols = floor((size - targetMargins.x) / (stdWidth + targetMargins.x));
rows = floor((trayDepth - targetMargins.y) / (stdDepth + targetMargins.y));
margins = [
    (size - cols * stdWidth) / (cols + 1),
    (trayDepth - rows * stdDepth) / (rows + 1),
];

echo(str("Tray can fit ", cols * rows, " pieces."));

module standardInset() {
    rotate([90, 0, 0])
    linear_extrude(stdDepth) {
        polygon([
            [0, height + 0.01],
            [stdWidth / 2, 0],
            [stdWidth, height + 0.01]
        ]);
    }
    
    rotate([90, 0, 0])
    linear_extrude(stdDepth + margins.y + 0.01) {    
        polygon([
            [-0.01 - margins.x, -0.01],
            [stdWidth / 2 - wallT, -0.01],
            [-0.01, height - wallT],
            [-0.01 - margins.x, height - wallT]
        ]);
        
        polygon([
            [stdWidth / 2 + wallT, -0.01],
            [stdWidth + margins.x + 0.01, -0.01],
            [stdWidth + margins.x + 0.01, height - wallT],
            [stdWidth + 0.01, height - wallT]
        ]);
    }
}

module hexBase() {
    translate([0, 0, hexFloor])
    linear_extrude(height)
    hexagon(smHex);
    
    translate([0, 0, -0.01])
    cylinder(d = hexHoleD, h = height + 0.02, $fn = 256);
}

module hexagon(d) {
    rotate([0, 0, 90])
    circle(d = d, $fn = 6);
}

module tray() {
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
        
        // Box for vertical spacers
        translate([wallT, size - spacerWidth - wallT, wallT])
        cube([size - 2 * wallT, spacerWidth, spacerHeight]);
        
        translate([-0.01, size - spacerWidth - wallT + spacerBoxGrip, wallT + spacerBoxGrip])
        cube([size + 0.02, spacerWidth - 2 * spacerBoxGrip, spacerHeight - 2 * spacerBoxGrip]);
        
        // flat area with mounts for Rail holders
        translate([-0.01, size - spacerBoxDepth - railAreaDepth, railBottomT])
        cube([size + 0.02, railAreaDepth, height]);
        
        translate([smHex / 2 - 2.1 + 50, size - spacerBoxDepth - smHex / 2 - 0.75 * smHex, 0])
        hexBase();
        
        translate([smHex / 2 - 2.1 + 80, size - spacerBoxDepth - smHex / 2, 0])
        hexBase();
        
        // spacing 126mm away from previous holder to fit 2x and 3x rails next to each other
        translate([smHex / 2 - 2.1 + 80 + 30 + 126, size - spacerBoxDepth - smHex / 2, 0])
        hexBase();
        
        translate([smHex / 2 - 2.1 + 50 + 156, size - spacerBoxDepth - smHex / 2 - 0.75 * smHex, 0])
        hexBase();
    }
    
    //closing the tray from the outside
    cube([margins.x, trayDepth, height]);
    cube([size, margins.y, height]);
    
    translate([size - margins.x, 0, 0])
    cube([margins.x, trayDepth, height]);
}

tray();