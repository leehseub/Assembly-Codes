	AREA ARMex, CODE, READONLY
	ENTRY
start
	LDR r0,TEMPADDR
	
	MOV r1,#1
	; 1! = 1
	
	MOV r2,r1,LSL#1
	; 2! = 2x1 = 2
	
	MOV r3,r2,LSL#1
	ADD r3,r3,r2
	; 3! = (2!)x2 + 2! = 3x2x1 = 6
	
	MOV r4,r3,LSL#2
	; 4! = (3!)x4 = 4x3x2x1 = 24(DEC) = 18(HEX)
	
	MOV r5,r4,LSL#2
	ADD r5,r5,r4
	; 5! = (4!)x4 + 4! = 5x4x3x2x1 = 120(DEC) = 78(HEX)
	
	MOV r6,r5,LSL#2
	ADD r6,r6,r5,LSL#1
	; 6! = (5!)x4 + (5!)x2 = 6x5x4x3x2x1 = 720(DEC) = 2D0(HEX)
	
	MOV r7,r6,LSL#2
	ADD r7,r7,r6,LSL#1
	ADD r7,r7,r6
	; 7! = (6!)x4 + (6!)x2 + 6! = 7x6x5x4x3x2x1 = 5040(DEC) = 13B0(HEX)
	
	MOV r8,r7,LSL#3
	; 8! = (7!)x8 = 8x7x6x5x4x3x2x1 = 40320(DEC) = 9D80(HEX)
	
	MOV r9,r8,LSL#3
	ADD r9,r9,r8
	; 9! = (8!)x8 + 8! = 9x8x7x6x5x4x3x2x1 = 362880(DEC) = 58980(HEX)
	
	MOV r10,r9,LSL#3
	ADD r10,r10,r9,LSL#1
	; 10! = (9!)x8 + (9!)x2 = 10x9x8x7x6x5x4x3x2x1 = 3628800(DEC) = 375F00(HEX)
	
	STR r1,[r0],#4
	STR r2,[r0],#4
	STR r3,[r0],#4
	STR r4,[r0],#4
	STR r5,[r0],#4
	STR r6,[r0],#4
	STR r7,[r0],#4
	STR r8,[r0],#4
	STR r9,[r0],#4
	STR r10,[r0]
	
TEMPADDR	&	&40000000

	END
