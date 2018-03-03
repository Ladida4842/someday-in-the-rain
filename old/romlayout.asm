db "SAMUDEI IN ZA REIN   " ; ROM title 21 bytes
db $25			; ROM layout ($20)

db $02			; Cartridge type

db $0D			; ROM size

db $07			; SRAM size

db $00			; Country code

db $00			; Licensee code

db $00			; Version number

dw $FFFF 		; Check sum complement

dw $0000 		; Check sum

db $FF,$FF,$FF,$FF 	; Nothing

dw $FFFF 		; COP vector (native mode)

dw $FFFF 		; BRK vector (native mode)

dw $FFFF 		; Abort vector (native mode)

dw NMI			; NMI vector (native mode)

dw $FFFF		; unused

dw IRQ			; IRQ

db $FF,$FF,$FF,$FF 	; Nothing

dw $FFFF		; COP vector (emulation mode)

dw $FFFF		; unused

dw $FFFF		; Abort vector (emulation mode)

dw $0000		; NMI vector (emulation mode)

dw Reset		; Reset (start game)

dw $FFFF		; IRQ/BRK (emulation mode)