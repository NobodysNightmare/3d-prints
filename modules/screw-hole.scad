module screwHole(screwDiameter, screwHeadDiameter, screwHeadHeight, screwDepth = 50, screwHeadLead = 1) {
    screwRadius = screwDiameter / 2;
    screwHeadRadius = screwHeadDiameter / 2;
    $fa = 0.2;
    $fs = 0.5;
    
    translate([0, 0, -screwHeadHeight])
        cylinder(screwHeadHeight, screwRadius, screwHeadRadius);
    translate([0, 0, -0.01])
        cylinder(screwHeadLead, screwHeadRadius, screwHeadRadius);
    translate([0, 0, -screwHeadHeight - screwDepth])
    cylinder(screwDepth, screwRadius, screwRadius);
}

screwHole(4, 5, 2);