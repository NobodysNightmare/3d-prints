outer = 60;
inner = 10;
lines = 5;

thick = 1.0;
thin = 0.6;

$fa = 1;
$fs = 1;

linear_extrude(thin)
difference() {
    circle(d = outer + 2 * lines);

    difference() {
        circle(d = outer);
        
        square([2 * outer, lines], center = true);
        
        circle(d = inner + 2 * lines);
    }
}

color("red")
linear_extrude(thick)
circle(d = inner);

color("red")
linear_extrude(thick)
difference() {
    circle(d = outer);
    
    translate([0, -outer + lines / 2])
    square([2 * outer, 2 * outer], center = true);
    
    circle(d = inner + 2 * lines);
}


/*
linear_extrude(thin)
circle(d = outer + 2 * lines);

color("red")
linear_extrude(thick)
difference() {
    circle(d = outer);
    
    square([2 * outer, lines], center = true);
    
    circle(d = inner + 2 * lines);
}

color("red")
linear_extrude(thick)
circle(d = inner);
*/