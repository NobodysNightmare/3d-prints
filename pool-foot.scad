stickBB = [41, 27];
stickThickness = 1;
stickLongRadius = 50;

growth = 10;
insetHeight = 15;
bottomHeight = 5; // TODO: match with reality?

holderR = 5;

$fn = $preview ? 64 : 128;

module foot() {
    difference() {
        linear_extrude(bottomHeight + insetHeight)
        offset(growth)
        outerFit();
        
        translate([0, 0, bottomHeight + 0.01])
        linear_extrude(insetHeight)
        outerFit();
    }
    
    translate([stickBB.x / 2, stickThickness + holderR, bottomHeight])
    holder();
    
    translate([stickBB.x / 2, stickBB.y - (stickThickness + holderR), bottomHeight])
    holder();
}

module outerFit() {
    intersection() {
        square(stickBB);
        
        translate([stickBB.x / 2, stickBB.y - stickLongRadius])
        circle(r = stickLongRadius);
        
        translate([stickBB.x / 2, stickLongRadius])
        circle(r = stickLongRadius);
    }
}

module holder() {
    cylinder(r1 = holderR, r2 = holderR - 1, h = insetHeight / 2);
}

foot();