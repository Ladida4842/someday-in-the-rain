norom
arch spc700

!dsp_r = $F2
!dsp_d = $F3

!io0 = $F4
!io1 = $F5
!io2 = $F6
!io3 = $F7

!vol_l0 = $00
!vol_r0 = $01
!p_l0 = $02
!p_h0 = $03
!srcn0 = $04
!adsr0_1 = $05
!adsr0_2 = $06
!gain0 = $07
!envx0 = $08
!outx0 = $09

!mvol_l = $0C
!mvol_r = $1C
!evol_l = $2C
!evol_r = $3C
!kon = $4C
!kof = $5C
!flg = $6C
!endx = $7C

!efb = $0D
!pmon = $2D
!non = $3D
!eon = $4D
!dir = $5D
!esa = $6D
!edl = $7D

!coef0 = $0F
!coef1 = $1F
!coef2 = $2F
!coef3 = $3F
!coef4 = $4F
!coef5 = $5F
!coef6 = $6F
!coef7 = $7F

!timer_ctrl = $F1
!timer0 = $FA
!timer1 = $FB
!timer2 = $FC
!timer_read0 = $FD
!timer_read1 = $FE
!timer_read2 = $FF

macro wdsp(arg1, arg2)
MOV A, #<arg1>
MOV Y, #<arg2>
MOVW !dsp_r, YA
endmacro

macro wdsp_reg(arg1, arg2)
MOV $F2, #<arg1>
MOV A, <arg2>
MOV $F3, A
endmacro

macro WaitMS(arg1)
PUSH A
PUSH Y
PUSH X
MOV Y, #<arg1>
MOV A, #$00
MOV !timer2, #$40
MOV !timer_ctrl, #$04
-
MOV A, !timer_read2
BEQ -
DEC Y
BNE -
POP X
POP Y
POP A
endmacro

macro Stall(arg1)
PUSH A
MOV A, #<arg1>
-
DEC A
BNE -
POP A
endmacro

org $0000
base $0200

spc_engine:
CLRP
%wdsp(!flg, $20)
%wdsp(!kon, 0)
%wdsp(!dir, $03)
%wdsp(!esa, 1)
%wdsp(!edl, 0)
%wdsp(!non, 0)
%wdsp(!eon, 0)
%wdsp(!mvol_l, $3F)
%wdsp(!mvol_r, $3F)
%wdsp(!evol_l, $00)
%wdsp(!evol_r, $00)
MOV A, #$00
MOV !io0, A
MOV $00, A
MOV $10, A

.loop
MOV X, !io0
BEQ +
BMI .gameover
CMP X, $10
BEQ +

%wdsp_reg(!vol_l0, .volume)
%wdsp_reg(!vol_r0, .volume)
%wdsp_reg(!p_l0, .pitchlow)
%wdsp_reg(!p_h0, .pitchhigh)
%wdsp_reg(!srcn0, .instr)
%wdsp(!adsr0_1, $0F|$70|$80)
%wdsp(!adsr0_2, $E0|$0B)
%wdsp(!gain0, $00)

SET1 $00.0
MOV !io0, #$CC
+
MOV $10, X
MOV A, $00
BEQ +
%wdsp_reg(!kon, $00)
MOV $00, #$00
+
JMP .loop

.gameover
%wdsp_reg(!kon, #$00)
CLRP
MOV $F1, #$80
JMP $FFC0

.volume
db $7F

.pitchlow
db $80

.pitchhigh
db $01

.instr
db $00