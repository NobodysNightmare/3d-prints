module screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight, screwDepth = 50, screwHeadLead = 1) {
    screwRadius = screwDiameter / 2;
    screwHeadRadius = screwHeadDiameter / 2;
    $fa = 0.2;
    $fs = 0.5;
    
    translate([0, 0, -screwHeadHeight - 0.01])
        cylinder(screwHeadHeight, screwRadius, screwHeadRadius);
    translate([0, 0, -0.02])
        cylinder(screwHeadLead, screwHeadRadius, screwHeadRadius);
    translate([0, 0, -screwHeadHeight - screwDepth])
    cylinder(screwDepth, screwRadius, screwRadius);
}

module nutHole(nutDiameterS, screwDiameter, nutDepth = 50, screwDepth = 50) {
    screwRadius = screwDiameter / 2;
    nutRadiusS = nutDiameterS / 2;
    nutRadiusL = nutRadiusS / sqrt(3) * 2;
    
    $fa = 0.2;
    $fs = 0.5;
    
    translate([0, 0, -0.01])
    cylinder(screwDepth, screwRadius, screwRadius);
    
    translate([0, 0, -nutDepth])
    linear_extrude(nutDepth)
    polygon([
        [sin(0) * nutRadiusL, cos(0) * nutRadiusL],
        [sin(60) * nutRadiusL, cos(60) * nutRadiusL],
        [sin(120) * nutRadiusL, cos(120) * nutRadiusL],
        [sin(180) * nutRadiusL, cos(180) * nutRadiusL],
        [sin(240) * nutRadiusL, cos(240) * nutRadiusL],
        [sin(300) * nutRadiusL, cos(300) * nutRadiusL]
    ]);
}

//screwHole(4, 5, 2);
nutHole(6, 3);