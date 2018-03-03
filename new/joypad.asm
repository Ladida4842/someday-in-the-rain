joypad:
STZ !unplugged
LDA $4212
LSR : BCS $FA
REP #$30
LDA $4218
BIT #$000F
BNE .not_snescontrol
TAX
LDA $4016
LSR
BCC .no_controller
LDA !joyraw
STX !joyraw
AND !joyraw
STA !joyheldL
EOR !joyraw
STA !joypressL
LDA !joydisL
TRB !joypressL
TRB !joyheldL
STZ !joydisL
SEP #$30
RTS

.no_controller
STZ !joypressL
STZ !joyheldL
STZ !joydisL
SEP #$30
LDA #$80
STA !unplugged
RTS

.not_snescontrol
STZ !joypressL
STZ !joyheldL
STZ !joydisL
SEP #$30
LDA #$40
STA !unplugged
RTS