module nnLogo(width, height) {
    baseHeight = 0.6 * height;
    scaleFactor = width / 88;

    scale([scaleFactor, scaleFactor, 1])
    difference() {
        linear_extrude(height)
            import("printable-avatar.svg", center = true);
    
        translate([0, 0, baseHeight])
        linear_extrude(height)
            import("avatar-border.svg", center = true);
    }
}

module nnCutout(width) {
    scaleFactor = width / 88;

    scale([scaleFactor, scaleFactor, 1])
    difference() {
        import("printable-avatar.svg", center = true);
        import("avatar-border.svg", center = true);
    }
}

nnCutout(50);