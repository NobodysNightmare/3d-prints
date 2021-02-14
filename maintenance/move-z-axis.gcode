G90 ; use absolute coordinates
G28 ; home all without mesh bed level

; Move Z axis up and down
G0 Z180 F360
G0 Z2 F360

; Move Z axis up and down
G0 Z180 F360
G0 Z2 F360

; Move Z axis up and down
G0 Z180 F360
G0 Z2 F360

; Park print head
G0 Z50 F360

M400 ; wait for moves to finish
M84 ; disable motors
