norom
incsrc defines.asm
incsrc macros.asm

%org($008000)
RESET:
SEI
STZ $4200
CLC : XCE
ROR : STA $2100
STZ $420C
REP #$28
LDA #$4300 : TCD
STZ $2181
TAY : STY $2183
STY $04 : STY $74 : STY $77
LDA #$8008 : STA $00 : STA $02
LDA #$2000 : STA $05
LDA #.hdmatable : STA $72
LDA #$0040 : STA $70
TYA : TCD
INY : STY $420B
SEP #$21 : ROR
STA !hdmareg
STA !brightness
JSR InitializeReg
LDA #$D9
STA $4209
STZ $420A
LDA #$21
STA $4200
CLI
BRA $03
-
WAI
INC !frame
JSR killsprite
LDA !gamemode
ASL : TAX
JSR (gamemodes,x)
JSR oamstuff
BRA -
.hdmatable
db $08 : dw .hdmatable+3
db $80 : dw !brightness
db $50 : dw !brightness
db $08 : dw .hdmatable+3
db $00

incsrc initialize.asm
incsrc joypad.asm
incsrc spritestuff.asm

IRQ:
%pushall(0)
LDA $4211
LDA !gamemode
ASL : TAX
JSR (nmimodes,x)
incsrc mirrorupload.asm
JSR joypad
LDA #$D9
STA $4209
STZ $420A
LDA #$21
STA $4200
LDA !hdmareg
ORA #$80
STA $420C
%pullall(0)
RTI

incsrc decomp.asm

COM_FADEIN:
LDA !brightness
INC A
CMP #$0F
BCC +
INC !subgamemode
+
STA !brightness
RTS

COM_FADEOUT:
DEC !brightness
BNE +
INC !subgamemode
+
RTS

COM_WAIT:
DEC !fadetimer
BNE +
INC !subgamemode
+
RTS

nmimodes:
dw NMI_TITLE

gamemodes:
dw TITLE

incsrc GAME/00_title.asm


BRK:
STZ $4200
STZ $420C
PEA $2100 : PLD
STZ $30 : STZ $33
STZ $2C : STZ $31
STZ $21
LDA #$FF : STA $22
LSR : STA $22
LDA #$0F
STA $00
EOR #$80
BRA $FA

%warnpc($00FFB0)
%org($00FFB0)
cleartable
db "~ LOLI HOMEBREW "
;db "~ LOLI SMW HACK "
incsrc romlayout.asm
%warnpc($018000)

%org($410000)
incbin bank0.bin
incbin bank1.bin
incbin bank2.bin
incbin bank3.bin
%warnpc($418000)

%org($018000)
incsrc logo.asm
%warnpc($028000)

%org($400000)
GFXFILES:

%org($C00000)

%org($420000)
;script starts here

org $7FFFFF
db $FF