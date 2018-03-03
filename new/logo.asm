;the code is optimized for space. speed is unimportant

;the RESET vector must point to a JML ladida_logo.
;this code, when finished, will then
;jump to $008000 in emulation mode, as if the system
;was just powered on. make sure to initialize registers
;and RAM, as well as other stuff, at $008000.
;also make sure to put this code in a location
;with RAM/REG access (banks $00-$3F or $80-$BF)
;NOT USED:
; DMA or HDMA (no reason)
; Interrupts (to avoid hardware vectors)
; BG layers (only sprite layer is used)
;USED:
; < 12kb of ROM with RAM/REG access (includes GFX and sound)
; first 8kb of VRAM
; palette 8 of CGRAM (and color 0, no fixed color)
; pages 0 and 1 (512bytes) of RAM:
;  $00-$7F = OAM low table (first 32 sprites only)
;  $80-$87 = OAM high table (first 32 sprites only)
;  $88 = brightness
;  $89 = frame counter
;  $8A = current mode
;  $8B = fadetimer
;  $8C = lower 8 bits (0-7) of x position for main sprite
;  $8D = high byte (bit 8) of x position for main sprite
;  $8E = counter of sorts, for how many sprites to spawn
;  $8F-9F = unused
;  $A0-$DC = gfx decompressor, loaded in RAM
;  $DD-$FF = unused
;  $0100-$01FF = reserved for stack

db "custom logo code"			;header
db " (C) Ladida "			;
dw ladida_logo_end-ladida_logo		;length
dw ~(ladida_logo_end-ladida_logo)	;inv of length

ladida_logo:
SEI
STZ $4200
STZ $420C
PEA $2100 : PLD
LDA #$80
STA $00
STZ $06
STZ $23
STZ $24
STZ $25
STZ $30
STZ $31
STZ $33
STZ $40
STZ $41
STZ $42
STZ $43
LDA #$60
STA $01
LDA #$10
STA $2C
STZ $21
LDA #$FF
STA $22
LSR
STA $22
PEA $0000 : PLD
PHK : PLB
LDX #$10
-
STZ $7F,x
DEX : BNE -
LDY #$E1
-
STY $00,x
INX : BPL -
JSR .decomp_CHR
XCE
LDA #$80 : STA $2121
LDX #$60
-
LDY .logoPAL-$0060,x
STY $2122
INX : BPL -
STZ $2102
STZ $2103
LDX #$00
LDY #$E1
-
STY $2104
INX : BNE -
ASL : BCS -
LDX #$20
LDA #$55
-
STA $2104
DEX : BPL -
CLI : BRA $05

.loop
INC $89
JSR .code
BIT $4210
BPL $FB
SEI
LDA #$80
STA $2100
STZ $2102
STZ $2103
LDX #$00
-
LDY $00,x
STY $2104
INX : BPL -
-
LDY $2138
INX : BNE -
ASL : BCS -
LDX #$78
-
LDA $08,x
STA $2104
INX : BPL -
LDA $88
STA $2100
LDA $4210
CLI
BRA .loop

.fadein
LDA $89
LSR : BCC +
INC $88
LDA $88
CMP #$0F
BCC +
LDA #$01
STA $2140
LDA $2140
CMP #$CC
BNE $F9
STZ $2140
INC $8A
LDA #$75
STA $8B
LDA #$E0
STA $00 : STA $8C
LDA #$58 : STA $01
LDA #$40 : STA $02
STZ $03
LDA #$03
STA $80 : STA $8D
+
RTS

.fadeout
LDA $89
LSR : BCC +
DEC $88
BNE +
PHD : PLB
PLA : ROR
STA $2100
STA $2140
PLA : PLA
SEP #$14
LDA $4212 : BPL $FB
LDA $4212 : BMI $FB
CLV : JML $008000

.jumper
LDY $8E
-
TYA : ASL #2 : TAX
ASL #2 : STA $04,x
LDA #$69 : STA $05,x
LDA #$20 : STA $06,x
STZ $07,x
DEY : BPL -
+
RTS

.code
LDA $8A
BEQ .fadein
DEC : LSR
BNE .fadeout
BCS .run2

.run
LDA $8C : STA $00
LDA $89
AND #$0C
ORA #$40
STA $02
LDA $8D
AND #$01
ORA #$02
STA $80

LDA $8C
ADC #$10
TAX
LDA $8D
ADC #$00
LSR : BCS +
TXA
BIT #$0F
BNE ++
LSR #4
STA $8E
++
JSR .jumper
+

LDA $89
AND #$02
LSR : INC
ADC $8C
STA $8C
LDA $8D
ADC #$00
STA $8D

DEC $8B
BNE +
LDA #$7F
STA $8B
INC $8A
+
RTS

.run2
LDA #$98 : STA $00
LDA #$80 : STA $02

JSR .jumper

LDA #$60 : STA $70
LDA #$70 : STA $74
LDA #$80 : STA $78
LDA #$90 : STA $7C
LDA #$66
STA $71
STA $75
STA $79
STA $7D
LDA #$02 : STA $72
LDA #$04 : STA $76
LDA #$06 : STA $7A
LDA #$08 : STA $7E
STZ $73
STZ $77
STZ $7B
STZ $7F

DEC $8B
BNE +
INC $8A
+
RTS

.decomp
LDA.w .logoCHR,y	;operand at $A1
BMI +
LDA #$F6 : STA $D2
LDA.w .logoCHR+2,y	;operand at $AA
ROL
BPL ++
LDA #$F8 : STA $D2
++
LDA #$40
ROL
STA $2115
REP #$20
LDA ($A1),y
XBA
STA $2116
LDA ($AA),y
XBA
AND #$3FFF
LSR : TAX
-
INY #2
LDA ($AA),y
STA $2118
DEX : BPL -		;branch distance at $D2
INY #4
SEP #$20
BRA .decomp
+
PLP : RTS

.logoPAL
dw $0000,$7FFF,$1084,$1D2E
dw $29F9,$4B3F,$5B9F,$4498
dw $619C,$7E9F,$7588,$7742
dw $0561,$09E2,$1283,$1704

.logoCHR
incbin logo.stim

.decomp_CHR
LDX.b #.logoPAL-.decomp-1
-
LDA .decomp,x
STA $A0,x
DEX : BPL -
CLC : XCE
PHP

.sound
REP #$30
LDX #$0000
LDA #$BBAA
CMP $2140
BNE $FB
SEP #$20
LDA #$CC
BRA .initupload
.nextblock
LDA .spcdata,x
INX
XBA
LDA #$00
BRA +
-
XBA
LDA .spcdata,x
INX
XBA
CMP $2140
BNE $FB
INC
+
REP #$20
STA $2140
SEP #$20
DEY
BNE -
CMP $2140
BNE $FB
ADC #$03
BEQ $FC
.initupload
PHA
REP #$20
LDA .spcdata,x
INX #2
TAY
LDA .spcdata,x
INX #2
STA $2142
SEP #$20
CPY #$0001
LDA #$00
ROL
STA $2141
ADC #$7F
PLA
STA $2140
CMP $2140
BNE $FB
BVS .nextblock
STY $2140
STY $2142
JMP $00A0

.spcdata
dw .espc-.bspc,$0200
.bspc
incbin logo_spc.spc
.espc
dw .esmp-.bsmp,$0300
.bsmp
dw $0304,$0304+(9*592)
incbin gong.brr
.esmp
dw $0000,$0200
ladida_logo_end: