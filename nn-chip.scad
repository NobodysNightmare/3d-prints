use <modules/nn-logo.scad>

outset = 3.9;
background = 3;
inset = 2.4;
coasterScale = 2.1;

chipScale = 1.1;
chipBackground = -0.1;
chipRelief = 2.4;

$fa = 1;
$fs = 1;

module chip() {
    linear_extrude(chipRelief)
    difference() {
        circle(d = 23.22);
        
        offset(-0.2)
        nnCutout(15);
    }
}

chip();