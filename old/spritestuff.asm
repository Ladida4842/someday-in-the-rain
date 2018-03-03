db $00,$F0
KillSprite:
%WRAMWrite(08, #!oam&$FFFF, #!oam>>16, #KillSprite-1, #KillSprite-1>>16, #$0200)
%WRAMWrite(08, #!oamdata, #!oamdata>>16, #KillSprite-2, #KillSprite-2>>16, #$0080)
RTL

OAMStuff:
LDY #$1E
-
LDX .andoratable,y
LDA !oamdata+$3,x
ASL #2
ORA !oamdata+$2,x
ASL #2
ORA !oamdata+$1,x
ASL #2
ORA !oamdata,x
STA !oamup,y
LDA !oamdata+$7,x
ASL #2
ORA !oamdata+$6,x
ASL #2
ORA !oamdata+$5,x
ASL #2
ORA !oamdata+$4,x
STA !oamup+$1,y
DEY #2 : BPL -
+
RTS
.andoratable
db $00,$00,$08,$00,$10,$00,$18,$00
db $20,$00,$28,$00,$30,$00,$38,$00
db $40,$00,$48,$00,$50,$00,$58,$00
db $60,$00,$68,$00,$68,$00,$78,$00