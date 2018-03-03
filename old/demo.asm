norom
macro org(addr)
if <addr>>>16 < $C0
org <addr>&$3FFFFF|$400000
	if <addr>&$008000 = $008000
	base <addr>&$3FFFFF
	else
	base <addr>&$3FFFFF|$400000
	endif
else
org <addr>&$3FFFFF
base <addr>
endif
endmacro

incsrc defines.txt
incsrc dma_macros.txt

%org($408000)
Reset:
CLC : XCE
REP #$30
LDA #$0000
TCD
LDA #$01FF
TCS
incsrc stz.asm
SEP #$30
STZ $4200	;clear interrupts
STZ $420B	;clear DMA
STZ $420C	;clear HDMA
STZ $4016	;clear joypads
STZ $4017

LDX #$04
-
LDA !SRAMtextspeed,x
STA !textspeed,x
DEX : BPL -

LDA #$03
STA $2101
STA !spritesize

LDA #$81
STA $4200
LDA #$80
STA $2100
STA !brightness
-
WAI : CLI
INC !frame
JSR Joypad
JSR RunGame
JSR OAMStuff
BRA -


NMI:
REP #$30
PHA : PHY : PHX : PHB : PHK : PLB
SEP #$30
LDA #$80
STA $2100
LDA $4210

JSR RunNMI

incsrc mirrorupload.asm

JSR Palette

LDA !hdmareg
STA $420C
LDA !brightness
STA $2100
LDA #$81
STA $4200

REP #$30
PLB : PLX : PLY : PLA
SEP #$30
RTI



IRQ:
SEI
REP #$30
PHA : PHY : PHX : PHB : PHK : PLB
SEP #$30
REP #$30
PLB : PLX : PLY : PLA
SEP #$30
RTI

incsrc palette.asm


RunNMI:
LDA !mode
ASL : TAX
JMP (.nmimode,x)
.nmimode
dw .return
dw TitleScreenNMI
dw OptionsNMI
dw NewGameNMI

.return
RTS


RunGame:
JSL KillSprite
LDA !mode
ASL : TAX
JMP (.gamemode,x)
.gamemode
dw LadidaLogo
dw TitleScreen
dw Options
dw NewGame

incsrc spritestuff.asm

incsrc joypad.asm

incsrc gamemode/00_logo/logo.asm
incsrc gamemode/01_title/title.asm
incsrc gamemode/02_options/options.asm
incsrc gamemode/03_newgame/newgame.asm

cleartable
%org($00FFC0)
incsrc romlayout.asm

%org($400000)
logopal:
incbin gamemode/00_logo/logo.mw3
incsrc gamemode/01_title/tables.asm
incsrc gamemode/02_options/tables.asm
incsrc gamemode/03_newgame/tables.asm

%org($418000)
incsrc lz3.asm

%org($7FFFFF)
db $00

%org($C10000)
incbin AllGFX.bin

%org($C20000)
titletestpic:
incbin gamemode/01_title/titletest.pic
%org($C30000)
optionspic:
incbin gamemode/02_options/options.pic

incbin vwftext.bin -> $040000	;($C40000)
incbin vwfwidth.bin -> $000000	;($C00000)

%org($C00000)
Width:

%org($C10000)
LogoSprite:
%org($C12000)
TitleText:

%org($C13800)
Layer3GFX:
%org($C1C000)
BorderGFX:

incsrc dialogue/characterdiag.asm