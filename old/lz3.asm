macro ReadByte()
	STX $8A
	LDA [$8A]
	INX
	BNE +
	LDX #$8000
	INC $06
	INC $8C
+
endmacro

;;usage:
;; Store dest ptr in $00-$02
;; Store src ptr in $8A-$8C
;; JSL DecompLZ3
	

DecompLZ3:
	PHB
	PEI ($03)
	PEI ($05)
	PEI ($07)
	PEI ($09)
	PEI ($0B)
	PEI ($0D)
	PEI ($0F)
	PEI ($11)
	PEI ($13)
	PEI ($8A)
	SEP #$20
	REP #$10
	LDA $02
	PHA
	PLB
	STA $05		; dest_bank (direct-copy)
	STA $0E		; dest_bank (indirect-copy)
	STA $0F		; src_bank (indirect-copy)
	INC
	STA $03		; dest_bank [plus or minus]
	LDA #$54
	STA $04		; mvn (direct-copy)
	STA $0D		; mvn (indirect-copy)
	LDA #$4C
	STA $07		; jmp (direct-copy)
	STA $10		; jmp (indirect-copy)
	LDA $8C
	STA $06		; src_bank (direct-copy)
	LDX.w #.back
	STX $08		; jmp to (direct-copy)
	LDX.w #.back2
	STX $11		; jmp to (indirect-copy)
	
	LDY $00		; dest_low
	LDX $8A		; src_low
	STZ $8A
	STZ $8B
	JMP .main
	
.end
	PLX : STX $8A
	PLX : STX $13
	PLX : STX $11
	PLX : STX $0F
	PLX : STX $0D
	PLX : STX $0B
	PLX : STX $09
	PLX : STX $07
	PLX : STX $05
	PLX : STX $03
	REP #$20
	TYA
	SEC
	SBC $00
	STA $8D		; size!!!
	SEP #$30
	PLB
	RTL			;JML $80B8EA

.case_c0
	%ReadByte()
	CMP #$00
	BPL +
	STY $0B
	REP #$21
	AND #$007F
	EOR #$FFFF
	ADC $0B
	SEP #$20
	BRA .lzcopy110
+	XBA
	%ReadByte()
	REP #$21
	ADC $00
	SEP #$20
	
.lzcopy110
	STX $0B
	TAX
-	LDA $0000,x
	STA $0000,y
	INY
	DEX
	DEC $8D
	BPL -
	JMP .back2

.case_e0_or_else
	ASL
	BPL .case_c0
	LDA $8D
	CMP #$1F
	BEQ .end

	AND #$03
	STA $8E
	EOR $8D
	ASL
	ASL
	ASL
	XBA
	%ReadByte()
	STA $8D
	XBA
	JMP .type

.case_80_or_else
	BMI .case_e0_or_else
	ASL
	BMI .case_a0

	%ReadByte()
	CMP #$00
	BPL +
	STY $0B
	REP #$21
	AND #$007F
	EOR #$FFFF
	ADC $0B
	BRA .lzcopy
+	XBA
	%ReadByte()
	REP #$21
	ADC $00
	
.lzcopy
	STX $0B
	TAX
	LDA $8D
	SEP #$20
	JMP $000D	; -> back2

.case_80_or_else_J
	JMP .case_80_or_else

.case_a0
	%ReadByte()
	CMP #$00
	BPL +
	STY $0B
	REP #$21
	AND #$007F
	EOR #$FFFF
	ADC $0B
	SEP #$20
	BRA .lzcopy101
+	XBA
	%ReadByte()
	REP #$21
	ADC $00
	SEP #$20
	
.lzcopy101
	STX $0B
	TAX
-	LDA $0000,x
	STZ $13
	ASL
	ROR $13
	ASL
	ROR $13
	ASL
	ROR $13
	ASL
	ROR $13
	ASL
	ROR $13
	ASL
	ROR $13
	ASL
	ROR $13
	ASL
	LDA $13
	ROR
	STA $0000,y
	INY
	INX
	DEC $8D
	BPL -

.back2
	LDX $0B		; <- JMP $000D
	
.main
	%ReadByte()
	STA $8D
	STZ $8E
	AND #$E0
	TRB $8D

.type
	ASL
	BCS .case_80_or_else_J
	BMI .case_40_or_60
	ASL
	BMI .case_20

.case_00
	REP #$20
	LDA $8D
	STX $8D
	
-	SEP #$20
	JMP $0004	; -> back
	
.back
	CPX $8D		; <- JMP $0004
	BCS .main
	
	INC $06
	INC $8C
	CPX #$0000
	BEQ ++
	
	DEX
	STX $0B
	REP #$21
	LDX #$8000
	STX $8D
	TYA
	SBC $0B
	TAY
	LDA $0B
	BRA -
	
++	LDX #$8000
	BRA .main

.case_20
	%ReadByte()
	STX $0B
	PHA
	PHA
	REP #$20
	
.case_20_main
	LDA $8D
	INC
	LSR
	TAX
	PLA
	
-	STA $0000,Y
	INY
	INY
	DEX
	BNE -
	
	SEP #$20
	BCC +
	STA $0000,Y
	INY
+	LDX $0B
	BRA .main
	
.case_40_or_60
	ASL
	BMI .case_60
	%ReadByte()
	XBA
	%ReadByte()

	XBA
	STX $0B
	REP #$20
	PHA
;Replace BRA .case_20_main the code itself
	LDA $8D
	INC
	LSR
	TAX
	PLA
-	STA $0000,Y
	INY
	INY
	DEX
	BNE -
	SEP #$20
	BCC +
	STA $0000,Y
	INY
+	LDX $0B
	JMP .main
	
.case_60	
	REP #$20
	
.case_60_main
	STX $0B
	LDA $8D
	INC
	LSR
	TAX
	LDA.w #$0000

-	STA $0000,Y
	INY
	INY
	DEX
	BNE -
	
	SEP #$20
	BCC +
	STA $0000,Y
	INY
+	LDX $0B
	JMP .main