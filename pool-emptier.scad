use <modules/threads.scad>

thickness = 2;

threadOuterDiameter = 42.6;
threadHeight = 11;
threadPitch = 2;

pusherSpace = 6.5;
pusherHeight = threadHeight + 4;

$fn = $preview ? 64 : 128;

difference() {
    cylinder(h = threadHeight + thickness, d = threadOuterDiameter + 2 * thickness);
    
    translate([0, 0, thickness])
    metric_thread(diameter = threadOuterDiameter, length = threadHeight, pitch = threadPitch, internal = true, leadin = 1);
    
    cylinder(h = 2 * threadHeight, d = threadOuterDiameter - 2 * thickness - 2 * pusherSpace, center = true);
}

translate([0, 0, thickness])
linear_extrude(pusherHeight)
difference() {
    circle(d = threadOuterDiameter - 2 * pusherSpace);
    circle(d = threadOuterDiameter - 2 * thickness - 2 * pusherSpace);
}