NewGameNMI:
LDA !vramupdate
BEQ +
%VRAMWrite(#$80, #$1900, #$7E, #!textbuffer, !textbufferloc, !textbuffersize)
+
RTS

NewGame:
LDA !submode
ASL : TAX
JMP (.ptrs,x)
.ptrs
dw .init
dw .fade
dw .main

.init
STZ !vramupdate

LDA #$49
STA !gfxmode
LDA.b #%11011111
TRB !cgadsub
LDA.b #%00010110
STA !mainscr
STA $212E
LDA.b #%00001001
STA !subscr
STA $212F
LDA !spritesize
ORA #$60
STA !spritesize
LDA #$30
STA $210B	;layers 1 & 2 GFX loc
LDA #$44
STA $210C	;layers 3 & 4 GFX loc
LDA #$28
STA $2107	;layer 1 tilemap loc
LDA #$55
STA $2108	;layer 2 tilemap loc
LDA #$5C
STA $2109	;layer 3 tilemap loc
STZ $00
STZ $01
%VRAMWrite(#$80, #$1809, #$7E, #$0000, #$0000, #$0000)
%WRAMWrite(00, #!color, #$7E, #NewGameTables_pal, #NewGameTables_pal>>16, #$0200)
%VRAMWrite(#$80, #$1801, #BorderGFX>>16, #BorderGFX, #$3000, #$2000)
;%VRAMWrite(#$80, #$1801, #$C1, #$F000, #$4000, #$1000)
%VRAMWrite(#$80, #$1801, #Layer3GFX>>16, #Layer3GFX, #$5000, #$0800)
%VRAMWrite(#$80, #$1801, #NewGameTables>>16, #NewGameTables_map1, #$2800, #$0800)
%VRAMWrite(#$80, #$1801, #NewGameTables>>16, #NewGameTables_map2, #$5400, #$1000)
%VRAMWrite(#$80, #$1801, #NewGameTables>>16, #NewGameTables_map3, #$5C00, #$0800)
;%VRAMWrite(#$00, #$1800, #NewGameTables>>16, #NewGameTables_introtxt, #$5800, #$0400)

LDX.b #.endhdmatable2-.hdmatable1-1
-
LDA .hdmatable1,x
STA !hdmatable,x
DEX : BPL -

LDA #$03
STA $2124


REP #$20
LDA #$6290
STA !bgcolor

SEP #$20
INC !submode
STZ !brightness

JSR .hdma
RTS

.hdma
REP #$20
LDA #$1103
STA $4360
LDA.w #!hdmatable
STA $4362
LDX.b #$7E
STX $4364
LDA #$2601
STA $4370
LDA.w #!hdmatable+$1F
STA $4372
LDX.b #$7E
STX $4374
SEP #$20
LDA #$C0
TSB !hdmareg
RTS

.hdmatable1		;layer 3 x & y
db $70 : dw #$0100,#$0000
db $23 : dw #$0100,#$0000
db $08 : dw #$00EC,#$004C
db $0C : dw #$0100,#$0000
db $30 : dw #$01F0,#$0156
db $08 : dw #$0100,#$0000
db $00
.endhdmatable1

.hdmatable2		;layer 3 window
db $70 : dw #$0001
db $23 : dw #$0001
db $08 : dw #$7414
db $0C : dw #$0001
db $30 : dw #$F010
db $08 : dw #$0001
db $00
.endhdmatable2

.fade
JSR .hdma
LDA !frame
AND #$03
BNE +
LDA !brightness
INC A
STA !brightness
CMP #$0F
BCC +
INC !submode
REP #$20
LDA.w #Diag_Fari
STA !textindex
LDX.b #Diag_Fari>>16
STX !textindexbank
LDA #$3FF0
STA !textbufferloc
LDA #$0020
STA !textbuffersize
SEP #$20
+
RTS

.main
JSR .hdma

LDA !frame
AND #$03
BEQ +
STZ !vramupdate
RTS
+
LDA #$01
STA !vramupdate

PHB : PHK : PLB

REP #$20
LDA !textindex
STA $00
LDX !textindexbank
STX $02
LDA [$00]
CMP #$0006
BEQ .newline
CMP #$000A
BEQ .newpara
CMP #$0004
BEQ .newpage
SEP #$20
STA $211B
XBA
STA $211B
LDA #$20
STA $211C
LDA $2134 : STA $00
LDA $2135 : STA $01
LDA $2136 : CLC : ADC #$C4 : STA $02
LDY #$1F
-
LDA [$00],y
STA !textbuffer,y
DEY : BPL -

LDA !textindex
INC A
STA !textindex
BNE +
LDA !textindex+1
INC A
STA !textindex+1
BNE +
LDA !textindexbank
INC A
STA !textindexbank
+
REP #$20
LDA !textbufferloc
CLC : ADC #$0010
STA !textbufferloc
SEP #$20
BRA +
.newline
.newpara
.newpage
SEP #$20
STZ !vramupdate
+
PLB : RTS