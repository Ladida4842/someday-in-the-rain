;$00-$0F		;RESERVED FOR TEMP RAM

!gamemode = $10		;current game mode
!subgamemode = $11	;current sub game mode
!brightness = $12	;mirror of $2100
!frame = $13		;current frame #, increases each frame

!fadetimer = $14	;timer for fade-ins and fade-outs
			;can be used as general timer
			;except during fade-ins/fade-outs

!sfx0 = $15		;mirror of $2140
!sfx1 = $16		;mirror of $2141
!sfx2 = $17		;mirror of $2142
!sfx3 = $18		;mirror of $2143

!unplugged = $19	;possible values are x00, x40, and x80
			;x80 = no controller in port 1
			;x40 = port 1 is not a snes controller

!layer1x = $1A		;mirror of $210D
!layer1y = $1C		;mirror of $210E
!layer2x = $1E		;mirror of $210F
!layer2y = $20		;mirror of $2110
!layer3x = $22		;mirror of $2111
!layer3y = $24		;mirror of $2112

!joypressL = $26	;axlr---- (tapping)
!joypressH = $27	;byetUDLR (tapping)
!joyheldL = $28		;axlr---- (holding)
!joyheldH = $29		;byetUDLR (holding)
!joydisL = $2A		;axlr---- (disabling)
!joydisH = $2B		;byetUDLR (disabling)
!joyraw = $2C		;2 bytes. dont touch (raw control)

!mainscr = $2E		;mirror of $212C
!subscr = $2F		;mirror of $212D
!hdmareg = $30		;mirror of $420C
!cgwsel = $31		;mirror of $2130
!cgadsub = $32		;mirror of $2131

!gfxmode = $33		;mirror of $2105
!layer1map = $34	;mirror of $2107
!layer2map = $35	;mirror of $2108
!layer3map = $36	;mirror of $2109

;$37-$DF		;EMPTY

!scriptaddr = $E0	;3 bytes. location of current letter
!scriptreturn = $E3	;3 bytes. return addr when jump is used
!textbank = $E6		;1 byte. current text bank

!decomp1 = $EB		;3 bytes. source address
!decomp2 = $EE		;2 bytes. amount of data transferred
!decomp3 = $F0		;16 bytes

;$0100-$01FF		;RESERVED FOR STACK
			;most of it should be unused, however

!oam = $0200
!oamx = !oam+0
!oamy = !oam+1
!oamt = !oam+2
!oamp = !oam+3
!hoam = !oam+$0100
!hoamx = !hoam+0
!hoamy = !hoam+1
!hoamt = !hoam+2
!hoamp = !hoam+3
!oamup = !oam+$0200
!oamdata = !oamup+$0020
!hoamdata = !oamdata+$0040

!color = $04A0		;entire palette. 512 bytes
!bgcolor = $06A0	;fixed color in BGR555. converted to $2132

;$06A2-$0FFF		;EMPTY

!char_1bpp = $1000	;32($20) bytes
!shad_1bpp = $1020	;32($20) bytes
!char_2bpp = $1040	;64($40) bytes
!shad_2bpp = $1080	;64($40) bytes
!char_render = $10C0	;64($40) bytes
!char_width = $1100	;1 byte

;$1101-$1FFF		;EMPTY

;$7E2000-$7EFFFF	;EMPTY

;$7F0000+		;EMPTY