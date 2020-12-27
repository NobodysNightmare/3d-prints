tushLength = 128;
tushWidth = 15;
tushHeight = 10; // how high we grip tush

spoolWidth = 51.5;

wallThickness = 2;
connectorThickness = 10;

use <modules/nn-logo.scad>;

module tushFoot() {
    translate([(-tushWidth / 2) - wallThickness, 0, 0]) {
        cube([wallThickness, tushLength, tushHeight]);
        
        translate([wallThickness + tushWidth, 0, 0])
        cube([wallThickness, tushLength, tushHeight]);
        
        translate([0, -wallThickness, 0])
        cube([tushWidth + 2 * wallThickness, wallThickness, tushHeight]);
        
        translate([0, tushLength, 0])
        cube([tushWidth + 2 * wallThickness, wallThickness, tushHeight]);
    }
}

translate([-spoolWidth / 2, 0, 0]) tushFoot();
translate([spoolWidth / 2, 0, 0]) tushFoot();

connectorWidth = spoolWidth - tushWidth;

translate([-connectorWidth / 2, 0, 0])
cube([connectorWidth, connectorThickness, wallThickness]);

translate([-connectorWidth / 2, tushLength - connectorThickness, 0])
cube([connectorWidth, connectorThickness, wallThickness]);

translate([0, tushLength / 2, 0])
nnLogo(connectorWidth - wallThickness * 2, wallThickness);