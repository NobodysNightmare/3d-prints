toothWidth = 0.45;
toothLength = 10;
toothThickness = 0.9;
toothSpacing = 0.2;
toothCount = 10;

gripWidth = 5;
gripThickness = 1.5;

toothDelta = toothWidth + toothSpacing;

for(i = [0:toothCount - 1]) {
    translate([i * toothDelta, 0, 0])
    cube([toothWidth, toothLength, toothThickness]);
}

translate([0, toothLength, 0])
cube([toothCount * (toothWidth + toothSpacing) - toothSpacing, gripWidth, gripThickness]);