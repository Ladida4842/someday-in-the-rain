db $B1,$D2	;A ME
db " "		;_
db $C9		;NO
db " "		;_
db $C5,$B6	;NA KA
db " "		;_
db $B2,$C2,$B6	;I TSU KA
db "          "	; ROM name 21 bytes total

db $25		; ROM layout (ExHiROM)
db $02		; Cartridge type (ROM+SRAM)
db $0D		; ROM size (64MBit, or 8MB)
db $07		; SRAM size (1MBit, or 128KB)
db $00		; Country code (Japan NTSC)
db $00		; Licensee code (Null)
db $00		; Version number (v1.0)
dw ~$0000 	; Checksum complement
dw $0000 	; Checksum

dw $FFFF,$FFFF	;[null]
dw $FFFF 	;	COP	(native)
dw BRK		;	BRK	(native)
dw $FFFF 	;	ABORT	(native)
dw $FFFF	;	NMI	(native)
dw $FFFF	;[null]	RESET	(native)
dw IRQ		;	IRQ	(native)
INIT: JML ladida_logo
dw $FFFF	;	COP	(emulation)
dw $FFFF	;[null] BRK	(emulation)
dw $FFFF	;	ABORT	(emulation)
dw $FFFF	;	NMI	(emulation)
dw INIT		;	RESET	(emulation)
dw BRK		;	IRQ/BRK	(emulation)