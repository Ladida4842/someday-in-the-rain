InitializeReg:
LDA #$60
STA $2101
STZ $2106
LDA #$34
STA !layer1map
LDA #$38
STA !layer2map
LDA #$3C
STA !layer3map
LDA #$61
STA $210B
LDA #$04
STA $210C
STZ $2123
STZ $2124
STZ $2125
STZ $2133

LDA #$29
STA !gfxmode
REP #$20
STZ !layer1x
STZ !layer1y
STZ !layer2x
STZ !layer2y
STZ !layer3x
STZ !layer3y
SEP #$20
LDA #%00010110
STA !mainscr
LDA #%00000001
STA !subscr
LDA #%00000010
STA !cgwsel
LDA #%00100000
STA !cgadsub
RTS