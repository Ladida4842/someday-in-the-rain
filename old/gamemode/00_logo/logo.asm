LadidaLogo:
LDA !submode
ASL : TAX
JMP (.ptrs,x)
.ptrs
dw .init
dw .fade
dw .display
dw .fadeout

.init
LDA #$03	;mode 3
STA !gfxmode

LDA #$58
STA $2107
LDA #$5C
STA $2108
LDA #$50
STA $210B
LDA !spritesize
ORA #$60
STA !spritesize

REP #$20
STZ !layer1x
STZ !layer1y
STZ !layer2x
STZ !layer2y
SEP #$20

LDA #$10
STA !mainscr
STZ !subscr
LDA #$02
STA !cgwsel
LDA #$20
STA !cgadsub
%WRAMWrite(00, #!color, #$7E, #logopal, #logopal>>16, #$0202)
%VRAMWrite(#$80, #$1801, #LogoSprite>>16, #LogoSprite, #$6000, #$1000)
INC !submode
STZ !brightness
LDA #$FF
STA !timer
RTS

.fade
JSR .logogen
JSR .bonnikairagen
LDA !frame
AND #$03
BNE +
LDA !brightness
INC A
STA !brightness
CMP #$0F
BCC +
INC !submode
+
RTS

.fadeout
JSR .logogen
JSR .bonnikairagen
LDA !frame
AND #$03
BNE +
LDA !brightness
DEC A
STA !brightness
BNE +
LDA #$80
STA !brightness
STZ !submode
INC !mode
+
RTS

.display
JSR .logogen
JSR .bonnikairagen
LDA !timer
DEC A
CMP #$FF
BNE +
INC !submode
LDA #$00
+
STA !timer
RTS

.logogen
LDX #$03
LDY #$00
-
LDA .logox,x
STA !oamx,y
LDA #$70
STA !oamy,y
LDA .logot,x
STA !oamt,y
LDA #$30
STA !oamp,y
PHX : TYA : LSR #2 : TAX
LDA #$00
STA !oamdata,x
PLX
INY #4 : DEX : BPL -
RTS

.logox
db $60,$70,$80,$90
.logot
db $00,$02,$04,$06

.bonnikairagen
LDA #$20
STA $00
LDA !frame
CMP #$08
BCS +
LDA #$23
STA $00
+
LDA #$38
STA !oamx,y
LDA #$68
STA !oamy,y
LDA $00
STA !oamt,y
LDA #$32
STA !oamp,y
PHX : TYA : LSR #2 : TAX
LDA #$02
STA !oamdata,x
PLX
INY #4
LDA #$26
STA $00
LDA !frame
CMP #$F8
BCC +
LDA #$29
STA $00
+
LDA #$A8
STA !oamx,y
LDA #$68
STA !oamy,y
LDA $00
STA !oamt,y
LDA #$34
STA !oamp,y
PHX : TYA : LSR #2 : TAX
LDA #$02
STA !oamdata,x
PLX
INY #4
RTS