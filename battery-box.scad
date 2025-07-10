batteryDiameter = 14.5;
holdHeight = 20;
count = [8, 6];
marginIn = [2, 0.2];
marginOut = 3;
bottomThickness = 0.6;

roundingIn = 1;
roundingOut = 10;

$fn = $preview ? 32 : 128;

size = [
    2 * marginOut + count.x * batteryDiameter + (count.x - 1) * marginIn.x,
    2 * marginOut + count.y * batteryDiameter + (count.y - 1) * marginIn.y,
    bottomThickness + holdHeight
];

module baseShape() {
    offset(roundingOut)
    offset(-roundingOut)
    square([size.x, size.y]);
}

linear_extrude(bottomThickness)
baseShape();

translate([0, 0, bottomThickness])
linear_extrude(size.z)
offset(roundingIn)
offset(-roundingIn)
difference() {
    baseShape();
    
    for(x = [0:count.x-1]) {
        for(y = [0:count.y-1]) {
            translate([
                marginOut + (0.5 + x) * batteryDiameter + x * marginIn.x,
                marginOut + (0.5 + y) * batteryDiameter + y * marginIn.y
            ])
            circle(d = batteryDiameter);
        }
    }
}