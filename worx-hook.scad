length = 85;
width = 12;

minThickness = 2.4;

holderLength = 25;
holderWidth = 5;
holderOpening = 10;
holderTipWidth = 4;

connectorThickness = 6;

$fa = 0.5;
$fs = 0.3;

module hook() {    
    pointyEnd();
    holder();
}

module pointyEnd() {
    difference() {
        union() {
            pointyPiece();
            rotate([0, 0, 90]) pointyPiece();
        }
        
        cube([minThickness, minThickness, 2 * length], true);
    }
    
    intersection() {
        pointyPiece();
        rotate([0, 0, 90]) pointyPiece();
    }
}

module pointyPiece() {
    translate([-width / 2, minThickness / 2, 0])
    rotate([90, 0, 0])
    linear_extrude(minThickness)
    polygon([
        [0, 0],
        [width, 0],
        [width, length - width],
        [width / 2, length],
        [0, length - width]
    ]);
}

module holder() {
    linear_extrude(minThickness)
    hull() {
        circle(d = width + minThickness / 2);
        
        translate([-((width + holderWidth) / 2 + holderOpening), 0])
        circle(d = holderWidth + minThickness / 2);
    }
    
    translate([-((width + holderWidth) / 2 + holderOpening), 0]) {
        hull() {
            linear_extrude(connectorThickness)
            circle(d = holderWidth);
            
            translate([-(holderWidth - holderTipWidth) / 2, 0, holderLength]) {
                sphere(d = holderTipWidth);
            }
        }
        
        translate([0, -holderWidth / 2, 0])
        cube([(width + holderWidth) / 2 + holderOpening, holderWidth, connectorThickness]);
    }
}

hook();