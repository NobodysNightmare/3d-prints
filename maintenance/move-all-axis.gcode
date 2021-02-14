M73 P0 R5 ; Print progress

G90 ; use absolute coordinates
G28 ; home all without mesh bed level

G0 Z10 F360 ; move head up

G0 F2160 ; set feed rate for XY moves

; Move between XY end positions
G0 X179 Y0
G0 X2 Y179

; Move between XY end positions
G0 X179 Y0
G0 X2 Y179

; Move between XY end positions
G0 X179 Y0
G0 X2 Y179

; Move between XY end positions
G0 X179 Y0
G0 X2 Y179

; Move between XY end positions
G0 X179 Y0
G0 X2 Y179

; Back to print start position
G0 Y0 X179

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
G0 X140 Y80 F2160

M400 ; wait for moves to finish
M84 ; disable motors
M73 P100 R0 ; Print progress
