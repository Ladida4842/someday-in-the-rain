DecompressLong:
PHB : PHK : PLB
JSR Decompressor
PLB : RTL

macro ReadByte()
STX !decomp1
LDA [!decomp1]
INX
BNE +
LDX #$8000
INC $03+!decomp3
INC !decomp1+2
+
endmacro

Decompressor:
PHX : PHY : PHP : REP #$30
STA !decomp1
ASL
CLC : ADC !decomp1
TAX
LDA.l GFXFILES,x
STA !decomp1
LDA.l GFXFILES+1,x
STA !decomp1+1
SEP #$20
PHB : LDY #$0000
PEI ($00+!decomp3)
PEI ($02+!decomp3)
PEI ($04+!decomp3)
PEI ($06+!decomp3)
PEI ($08+!decomp3)
PEI ($0A+!decomp3)
PEI ($0C+!decomp3)
PEI ($0E+!decomp3)
PEI (!decomp1)
LDA $02
PHA : PLB
STA $02+!decomp3
STA $0B+!decomp3
STA $0C+!decomp3
INC
STA $00+!decomp3
LDA #$54
STA $01+!decomp3
STA $0A+!decomp3
LDA #$4C
STA $04+!decomp3
STA $0D+!decomp3
LDA !decomp1+2
STA $03+!decomp3
LDX.w #.back
STX $05+!decomp3
LDX.w #.back2
STX $0E+!decomp3
LDY $00
LDX !decomp1
STZ !decomp1
STZ !decomp1+1
JMP .main

.end
PLX : STX !decomp1
PLX : STX $0E+!decomp3
PLX : STX $0C+!decomp3
PLX : STX $0A+!decomp3
PLX : STX $08+!decomp3
PLX : STX $06+!decomp3
PLX : STX $04+!decomp3
PLX : STX $02+!decomp3
PLX : STX $00+!decomp3
REP #$20
TYA
SEC : SBC $00
STA !decomp2
PLB : PLP : PLY : PLX
RTS

.case_e0_or_end
LDA !decomp2
CMP #$1F
BEQ .end
AND #$03
STA !decomp2+1
EOR !decomp2
ASL #3
XBA
%ReadByte()
STA !decomp2
XBA
BRA .type

.case_80_or_else
BMI .case_e0_or_end
%ReadByte()
XBA
%ReadByte()
STX $08+!decomp3
REP #$21
ADC $00
TAX
LDA !decomp2
SEP #$20
JMP $000A+!decomp3

.back2
LDX $08+!decomp3

.main
%ReadByte()
STA !decomp2
STZ !decomp2+1
AND #$E0
TRB !decomp2

.type
ASL
BCS .case_80_or_else
BMI .case_40_or_60
ASL
BMI .case_20

.case_00
REP #$20
LDA !decomp2
STX !decomp2
-
SEP #$20
JMP $0001+!decomp3

.back
CPX !decomp2
BCS .main
INC $03+!decomp3
INC !decomp1+2
CPX #$0000
BEQ ++
DEX
STX $08+!decomp3
REP #$21
LDX #$8000
STX !decomp2
TYA
SBC $08+!decomp3
TAY
LDA $08+!decomp3
BRA -
++
LDX #$8000
BRA .main

.case_20
%ReadByte()
STX $08+!decomp3
PHA : PHA
REP #$20

.case_20_main
LDA !decomp2
INC
LSR
TAX
PLA
-
STA $0000,y
INY #2
DEX
BNE -
SEP #$20
BCC +
STA $0000,y
INY
+
LDX $08+!decomp3
BRA .main

.case_40_or_60
ASL
BMI .case_60
%ReadByte()
XBA
%ReadByte()

XBA
STX $08+!decomp3
REP #$20
PHA
LDA !decomp2
INC
LSR
TAX
PLA
-
STA $0000,y
INY #2
DEX
BNE -
SEP #$20
BCC +
STA $0000,y
INY
+
LDX $08+!decomp3
JMP .main

.case_60
%ReadByte()
STX $08+!decomp3
LDX !decomp2
-
STA $0000,y
INC
INY
DEX
BPL -
LDX $08+!decomp3
JMP .main