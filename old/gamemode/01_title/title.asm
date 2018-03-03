TitleScreenNMI:
LDA !submode
ASL : TAX
JMP (.ptrs,x)
.ptrs
dw .init
dw .fade
dw .displayfade
dw .display
dw .menu
dw .fadenext

.init
.fade
.displayfade
.fadenext
RTS
.display
LDA !timer
BNE +
BRL ++
+
STZ !timer
INC !submode
%VRAMWrite(#$00, #$1800, #.text>>16, #.text, #$7E44, #$0008)
%VRAMWrite(#$00, #$1800, #.text+8>>16, #.text+8, #$7E84, #$0008)
%VRAMWrite(#$00, #$1800, #.text+16>>16, #.text+16, #$7EC4, #$0008)
++
RTS
.menu
LDX #$04
-
LDA #$1F
STA $00,x
STA $05,x
DEX : BPL -
LDX !timer
LDA #$3A
STA $00,x
LDA #$3B
STA $05,x
%VRAMWrite(#$01, #$1800, #$7E, #$0000, #$7E42, #$0005)
%VRAMWrite(#$01, #$1800, #$7E, #$0005, #$7E4D, #$0005)
RTS

.text
db $11,$24,$32,$34,$2C,$24,$1F,$1F
db $0D,$24,$36,$1F,$06,$20,$2C,$24
db $0E,$2F,$33,$28,$2E,$2D,$32,$1F





TitleScreen:
LDA !submode
ASL : TAX
JMP (.ptrs,x)
.ptrs
dw .init
dw .fade
dw .displayfade
dw .display
dw .menu
dw .fadenext

.init
LDA #$78
STA $2107
LDA #$7C
STA $2108
LDA #$70
STA $210B
LDA #$12
STA !mainscr
LDA #$01
STA !subscr
LDA #$22
STA !cgadsub

REP #$20
STZ !layer1x
STZ !layer1y
STZ !layer2x
STZ !layer2y
STZ !layer3x
STZ !layer3y
STZ !layer4x
STZ !layer4y
SEP #$20

%WRAMWrite(00, #!color, #$7E, #TitleTables_pal, #TitleTables_pal>>16, #$00E0)
%VRAMWrite(#$80, #$1801, #titletestpic>>16, #titletestpic, #$0000, #$D980)
%VRAMWrite(#$80, #$1801, #TitleTables_map>>16, #TitleTables_map, #$7800, #$0800)
%VRAMWrite(#$80, #$1801, #TitleText>>16, #TitleText, #$7000, #$1000)
%VRAMWrite(#$80, #$1801, #TitleTables_map2>>16, #TitleTables_map2, #$7C00, #$0800)

PEA $0000
PLA : STA !color
STA !color+$E2
PLA : STA !color+1
STA !color+$E3

LDA #$1F : STA $00
%VRAMWrite(#$00, #$1808, #$7E, #$0000, #$7E44, #$0008)
%VRAMWrite(#$00, #$1808, #$7E, #$0000, #$7E84, #$0008)
%VRAMWrite(#$00, #$1808, #$7E, #$0000, #$7EC4, #$0008)

%VRAMWrite(#$01, #$1808, #$7E, #$0000, #$7E42, #$0005)
%VRAMWrite(#$01, #$1808, #$7E, #$0000, #$7E4D, #$0005)

STZ !brightness
INC !submode
RTS

.fade
LDA !frame
AND #$03
BNE +
LDA !brightness
INC A
STA !brightness
CMP #$0F
BCC +
INC !submode
LDA #$30
STA !timer
+
RTS

.displayfade
LDA !timer
DEC A
BMI ++
STA !timer
BRA +
++
LDA !frame
AND #$03
BNE +
REP #$20
LDA !color+$E2
CLC : ADC #$0421
STA !color+$E2
SEP #$20
CMP #$FF
BNE +
INC !submode
+
RTS

.display
LDA !joy1press
ORA !joy1press2
BEQ +
INC !timer
+
RTS

.menu
LDA !joy1press
AND #$0C
LSR #2
TAX
LDA !timer
CLC : ADC .pttable,x
BMI ++
CMP #$06
BCC +
++
LDA !timer
+
STA !timer

LDA !joy1press
AND #$80
BEQ +
LDA !timer
LSR : TAX
LDA .nextmode,x
STA !timer
INC !submode
+
RTS
.pttable
db $00,$02,$FE,$00
.nextmode
db $00,$03,$02

.fadenext
LDA !frame
AND #$03
BNE +
LDA !brightness
DEC A
STA !brightness
BPL +
LDA #$80
STA !brightness
STZ !submode
LDA !timer
STA !mode
+
RTS