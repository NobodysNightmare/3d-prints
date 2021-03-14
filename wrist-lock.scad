thickness = 1;
length = 8;

innerHeight = 7;
innerWidth = 23;

lockWidth = 4.5;
lockThickness = 1;
lockLength = 1;

linear_extrude(length)
difference() {
    offset(thickness)
    square([innerWidth, innerHeight]);
    
    square([innerWidth, innerHeight]);
}

translate([innerWidth / 2, 0, length / 2])
cube([lockWidth, lockLength, lockThickness], center = true);