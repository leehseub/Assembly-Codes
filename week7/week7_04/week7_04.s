	AREA ARMex, CODE, READONLY
	ENTRY
start
	LDR r0,floating_point01
	LDR r1,floating_point02
	
	MOV r2,r0,LSR#31
	; sign bit1
	
	MOV r3,r0,LSL#1
	MOV r3,r3,LSR#24
	; exponent1
	
	MOV r4,r0,LSL#9
	MOV r4,r4,LSR#9
	ADD r4,r4,#0x00800000
	; mantissa1
	
	MOV r5,r1,LSR#31
	; sign bit2
	
	MOV r6,r1,LSL#1
	MOV r6,r6,LSR#24
	; exponent2
	
	MOV r7,r1,LSL#9
	MOV r7,r7,LSR#9
	ADD r7,r7,#0x00800000
	; mantissa2
	
	CMP r2,r5
	BEQ float_addition
	BNE float_subtraction

float_addition
	CMP r3,r6
	;compare exponent
	SUBLT r8,r6,r3
	SUBGT r8,r3,r6
	MOVLT r4,r4,LSR r8
	MOVGT r7,r7,LSR r8
	
	ADD r9,r4,r7
	MOV r10,r9,LSR#23
	
	CMP r10,#1
	;Check left side of dot is 1
	
	ADDGT r8,r8,#1
	MOVGT r9,r9,LSR#1
	;if greater than 1, Shift Right 1 bit
	
	SUBLT r8,r8,#1
	MOVLT r9,r9,LSL#1
	;if lower than 1, Shift Left 1 bit

	SUB r9,r9,#0x00800000
	;get mantissa
	
	CMP r3,r6
	ADDGE r10,r3,r8
	ADDLT r10,r6,r8
	MOV r2,r2,LSL#8
	ADD r11,r10,r2
	MOV r11,r11,LSL#23
	ADD r11,r11,r9
	
	B str_state

float_subtraction
	CMP r3,r6
	;compare exponent
	SUBLT r8,r6,r3
	SUBGT r8,r3,r6
	MOVLT r4,r4,LSR r8
	MOVGT r7,r7,LSR r8
	
	CMP r4,r7
	SUBLT r9,r7,r4
	SUBGT r9,r4,r7
	
	MOV r10,r9,LSR#23
	
	CMP r10,#1
	;Check left side of dot is 1
	
	ADDGT r8,r8,#1
	MOVGT r9,r9,LSR#1
	;if greater than 1, Shift Right 1 bit
	
	SUBLT r8,r8,#1
	MOVLT r9,r9,LSL#1
	;if lower than 1, Shift Left 1 bit
	
	SUB r9,r9,#0x00800000
	;get mantissa
	
	CMP r4,r7
	MOVGT r2,r2,LSL#8
	MOVLE r2,r5,LSL#8
	CMP r3,r6
	ADDGT r3,r3,r8
	ADDLE r3,r6,r8
	ADD r10,r3,r2
	MOV r11,r10,LSL#23
	ADD r11,r11,r9
	
	B str_state
	
str_state
	LDR r0,TEMPADDR
	STR r11,[r0]
	MOV pc,lr
	
	
floating_point01 & 0x42680000	; 58(DEC) = 3A(HEX)
;floating_point01 & 0xC2680000	; -58(DEC) = FFFF FFFF FFFF FFC6(HEX)
;floating_point02 & 0x42280000	; 42(DEC) = 2A(HEX)
floating_point02 & 0xC2280000	; -42(DEC) = FFFF FFFF FFFF FFD6(HEX)

TEMPADDR	&	&40000000

	END