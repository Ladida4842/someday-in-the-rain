Palette:
LDX #$02
--
REP #$20
LDA !bgcolor		;get BG color
LDY .cdat,x
-
DEY : BMI +
LSR
BRA -
+
SEP #$20
AND #$1F
ORA .cdatt,x
STA $2132		;store to fixed color data
DEX : BPL --

%CGRAMWrite(#$7E, #!color, #$00, #$0200)

RTS
.cdat
db $00,$05,$0A
.cdatt
db $20,$40,$80