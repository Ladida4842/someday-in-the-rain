;Rainy
;(Variable-Width Text Rendering System for SNES)
;by Ladida
;
;input: 1BPP text in 16x16 format, actual size=15x15
;output: 2BPP text with shadow, __x16


*script stuff goes here*

rainy:
;read script
*generate sfx*
LDA [!scriptaddr]	;<--need to calculate this
.recheck
BEQ .space
CMP #$FF
BEQ .control_chars
TAY
LDA !textbank
ASL : TAX
TYA
JMP (.special_handler,x)

.space
;*handle space*
;*increase script, handle overflow*
BRA .endscriptread

.control_chars
JSR .inc_scriptaddr
CMP #$21
BCS .special_char
ASL : TAX
JMP (.control_chars+5)
dw .bank_change		;x00
dw .header		;x01
dw .capitalize		;x02
dw .jump_script		;x03
dw .jump_asm		;x04
dw .prompt		;x05
dw .wait		;x06
dw .gen_sfx		;x07
dw .quake		;x08
dw .horz_tab		;x09
dw .newline		;x0A
dw .diag_options	;x0B
dw .clear_screen	;x0C
dw .color		;x0D
dw .lowercase		;x0E
dw .uppercase		;x0F
dw .boldface		;x10
dw .italicize		;x11
dw .underline		;x12
dw .strikethrough	;x13
dw .superscript		;x14
dw .subscript		;x15
dw .clear_format	;x16
dw .change_character	;x17
dw .change_emotion	;x18
dw .change_speaker	;x19
dw .print		;x1A
dw .flash_screen	;x1B
dw .addr_dec		;x1C
dw .addr_hex		;x1D
dw .addr_char		;x1E
dw .return		;x1F
dw .label		;x20

.special_char
SBC #$21

.bank_change
JSR .inc_scriptaddr
STA !textbank
JSR .inc_scriptaddr
JMP .recheck

.jump_script
LDA !scriptaddr
CLC : ADC #$04
STA !scriptreturn
LDA !scriptaddr+1
ADC #$00
STA !scriptreturn+1
LDA !scriptaddr+2
ADC #$00
STA !scriptreturn+2
JSR .inc_scriptaddr
STA $00
JSR .inc_scriptaddr
STA $01
JSR .inc_scriptaddr
STA !scriptaddr+2
LDA $01
STA !scriptaddr+1
LDA $00
STA !scriptaddr
LDA [!scriptaddr]
JMP .recheck

.jump_asm
LDA !scriptaddr
CLC : ADC #$04
STA !scriptreturn
LDA !scriptaddr+1
ADC #$00
STA !scriptreturn+1
LDA !scriptaddr+2
ADC #$00
STA !scriptreturn+2
JSR .inc_scriptaddr
STA $00
JSR .inc_scriptaddr
STA $01
JSR .inc_scriptaddr
STA $02
JML [$0000]

.return
LDA !scriptreturn
STA !scriptaddr
LDA !scriptreturn+1
STA !scriptaddr+1
LDA !scriptreturn+2
STA !scriptaddr+2
LDA [!scriptaddr]
JMP .recheck

.print
JSR .inc_scriptaddr
XBA
JSR .inc_scriptaddr
XBA
JMP .skipbank


.special_handler
dw .bank0_handle
dw .bank1_handle
dw .bank2_handle
dw .bank3_handle

.bank0_handle
;*handle dakuten*
.bank1_handle
.bank2_handle
.bank3_handle
BRA .begin_render

.inc_scriptaddr
LDA !scriptaddr
CLC : ADC #$01
STA !scriptaddr
LDA !scriptaddr+1
ADC #$00
STA !scriptaddr+1
LDA !scriptaddr+2
ADC #$00
STA !scriptaddr+2
LDA [!scriptaddr]
RTS


.endscriptread
RTL? or RTS

;get address of letter GFX in ROM (or maybe SRAM)

.not_control
XBA
LDA !textbank
XBA
.skipbank
REP #$20
ASL #5			;multiply by 32 (size of each character)
STA $00
LDX #$41		;characters are in bottom of bank $41
STX $02


;for below:
;$main = raw letter gfx straight from ROM (1BPP), 32/$20 bytes
;$preshad = $main offset by 1,1 (1BPP), 32/$20 bytes
;$render = $main converted to 2BPP, 64/$40 bytes
;$shadow = $preshad converted to 2BPP, 64/$40 bytes
;$main2 = $render|$shadow, 64/$40 bytes
;$charwidth = width of character in pixels, 1 byte

;store to temp RAM

%WRAMRW(00, #!char_1bpp&$FFFF, #$7E, $00, $02, #$0020)


;create shadow

REP #$20
LDX #$1C
-
LDA !char_1bpp,x
LSR A
EOR #$FFFF
STA !shad_1bpp+2,x
DEX : BPL -
LDA #$FFFF
STA !shad_1bpp
SEP #$20


;1BPP->2BPP conversion for letter

LDX #$1F : STX $00 : LDX #$3E
-
PHX : LDX $00
LDA !char_1bpp,x
PLX
STA !char_2bpp,x
DEC $00 : DEX #2 : BPL -


;1BPP->2BPP conversion for shadow

LDX #$1F : STX $00 : LDX #$3F
-
PHX : LDX $00
LDA !shad_1bpp,x
PLX
STA !shad_2bpp,x
DEC $00 : DEX
LDA #$FF : STA !shad_2bpp,x
DEX : BPL -


;combine letter and shadow

REP #$20
LDX #$3E
-
LDA !char_2bpp,x
ORA !shad_2bpp,x
STA !char_render,x
DEX #2 : BPL -


;calculate character width
LDX #$1C
STZ $00
--
LDA !char_1bpp,x
LDY #$10
-
DEY
LSR A
BCC -
CPY $00
BCC +
STY $00
+
DEX #2 : BPL --
SEP #$20
LDA $00
STA !char_width


LDA $cursorline
ASL #6
STA $00
STZ $01
REP #$30
LDA $cursorpos
AND #$00FF
LSR #3
CLC : ADC $00
ADC #$7000