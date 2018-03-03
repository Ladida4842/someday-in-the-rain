Joypad:
LDA $4212
AND #$01
BNE Joypad

REP #$30

;p1
LDX !joy1raw
LDA $4218
STA !joy1raw
TXA
EOR !joy1raw
AND !joy1raw
XBA
STA !joy1press
TXA
AND !joy1raw
XBA
STA !joy1held

;p2
LDX !joy2raw
LDA $421A
STA !joy2raw
TXA
EOR !joy2raw
AND !joy2raw
XBA
STA !joy2press
TXA
AND !joy2raw
XBA
STA !joy2held

SEP #$20
LDX #$0000
LDA $4016
BNE +
STX !joy1raw
STX !joy1press
STX !joy1held

+
LDA $4017
BNE +
STX !joy2raw
STX !joy2press
STX !joy2held

+
SEP #$10
RTS