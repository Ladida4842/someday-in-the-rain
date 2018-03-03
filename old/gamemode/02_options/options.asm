table text.tbl

OptionsNMI:
LDA !submode
ASL : TAX
JMP (.ptrs,x)
.ptrs
dw .init
dw .fade
dw .display
dw .fadeout
dw .savesettings

.init
.savesettings
RTS

.display
.fade
.fadeout
LDA #$1F : STA $00
LDX.b #Options_endstoretable-Options_storetable-2
-
REP #$20
LDA Options_storetable,x
STA $01
SEP #$20
%VRAMWrite(#$00, #$1808, #$7E, #$0000, $01, #$0001)
DEX #2 : BPL -

LDX #$4A
LDA $13
LSR #4
AND #$01
BEQ +
LDX #$4B
+
STX $00
LDA !timer
ASL #2
TAX
REP #$20
LDA Options_storetable,x
STA $01
SEP #$20
%VRAMWrite(#$00, #$1800, #$7E, #$0000, $01, #$0001)
INX #2
REP #$20
LDA Options_storetable,x
STA $01
SEP #$20
%VRAMWrite(#$00, #$1800, #$7E, #$0000, $01, #$0001)

LDA !vramupdate
BEQ +
%VRAMWrite(#$00, #$1800, #$7E, #!vrambuffer, !vrambufferloc, !vrambuffersize)
+
RTS




Options:
LDA !submode
ASL : TAX
JMP (.ptrs,x)
.ptrs
dw .init
dw .fade
dw .display
dw .fadeout
dw .savesettings

.init
%WRAMWrite(00, #!color, #$7E, #OptionsTables_pal, #OptionsTables_pal>>16, #$00E0)
%VRAMWrite(#$80, #$1801, #optionspic>>16, #optionspic, #$0000, #$CC40)
%VRAMWrite(#$80, #$1801, #OptionsTables_map>>16, #OptionsTables_map, #$7800, #$0800)
%VRAMWrite(#$80, #$1801, #OptionsTables_map2>>16, #OptionsTables_map2, #$7C00, #$0800)
PEA $0000
PLA : STA !color
PLA : STA !color+1

LDA #$1F : STA $00
LDX.b #.endstoretable-.storetable-2
-
REP #$20
LDA .storetable,x
STA $01
SEP #$20
%VRAMWrite(#$00, #$1808, #$7E, #$0000, $01, #$0001)
DEX #2 : BPL -

STZ !brightness
INC !submode
STZ !timer
STZ !vramupdate

JSR .listupdate
RTS

.storetable
dw $7CB4,$7CBB
dw $7D52,$7D5D
dw $7DF6,$7DFA
dw $7E94,$7E9B
dw $7F31,$7F3E
.endstoretable

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
+
RTS

.fadeout
LDA !frame
AND #$03
BNE +
LDA !brightness
DEC A
STA !brightness
BNE +
LDA #$80
STA !brightness
INC !submode
+
RTS

.savesettings
LDX #$04
-
LDA !textspeed,x
STA !SRAMtextspeed,x
DEX : BPL -
STZ !submode
LDA #$01
STA !mode
RTS

.display
LDA !joy1press
BIT #$40
BNE +
BIT #$10
BNE +
BRA ++
+
INC !submode
RTS
++

LDA !joy1press
AND #$0C
LSR #2 : TAY
LDA !timer
CLC : ADC .moveax,y
BPL +
LDA #$04
BRA ++
+
CMP #$05
BCC ++
LDA #$00
++
STA !timer

TAX
LDA !joy1press
AND #$03 : TAY
LDA !textspeed,x
CLC : ADC .moveax,y
BPL +
LDA .ramamount,x
DEC
BRA ++
+
CMP .ramamount,x
BCC ++
LDA #$00
++
STA !textspeed,x

STA $4202
TXA : ASL : TAY
REP #$20
LDA .tableptr,y
STA $00
LDA .vramptr,y
STA !vrambufferloc
SEP #$20
LDA .tableamount,x
STA !vrambuffersize
STZ !vrambuffersize+1
CLC : ADC .tableamount,x
DEC A : TAX : STA $03
-
LDA !vrambuffersize
STA $4203
NOP #4
LDA $4216
CLC : ADC $03
TAY
LDA ($00),y
STA !vrambuffer,x
DEC $03 : DEX : BPL -
LDA #$01
STA !vramupdate
RTS

.moveax
db $00,$01,$FF,$00

.ramamount
db $03,$0D,$02,$03,$0F

.tableamount
db $06,$0A,$03,$06,$0C

.tableptr
dw .textspeed
dw .language
dw .vulgarity
dw .adult
dw .border

.vramptr
dw $7CB5
dw $7D53
dw $7DF7
dw $7E95
dw $7F32

.textspeed
db "Medium"
db " Fast "
db " Slow "

.language
db " American "
db " Mexican  "
db " British  "
db "   lol    "
db "   Nazi   "
db "motherland"
db " JAPANESE "
db "roflchina "
db "  corean  "
db "terrorist "
db "  ghetto  "
db " lolcode  "
db "   1337   "

.vulgarity
db "On "
db "Off"

.adult
db " None "
db "Little"
db " All  "

.border
db "   Basic    "
db "   Simple   "
db "   Royal    "
db "   Oeste    "
db "    Yolk    "
db "   Graph    "
db "   Bubble   "
db "  Ink blot  "
db "Van de Graaf"
db "  Vanilla   "
db " Chocolate  "
db "   Kaizo    "
db "Avant-Garde "
db "   Bonni    "
db "    None    "

.listupdate
LDX #$04
--
TXA : ASL : TAY
REP #$20
LDA .tableptr,y
STA $00
LDA .vramptr,y
STA !vrambufferloc
SEP #$20
LDA !textspeed,x
STA $4202
LDA .tableamount,x
STA $4203
STA !vrambuffersize
STZ !vrambuffersize+1
PHX
DEC : STA $02 : TAX
NOP
LDA $4216
CLC : ADC $02
TAY
-
LDA ($00),y
STA !vrambuffer,x
DEY : DEX : BPL -
%VRAMWrite(#$00, #$1800, #$7E, #!vrambuffer, !vrambufferloc, !vrambuffersize)
PLX
DEX : BMI +
BRL --
+
RTS