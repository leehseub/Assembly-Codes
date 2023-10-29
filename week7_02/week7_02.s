	AREA ARMex, CODE, READONLY
	ENTRY
start
	LDR r0,TEMPADDR
	MOV r1,#1
	MOV r2,#2
	MOV r3,#3
	MOV r4,#4
	MOV r5,#5
	MOV r6,#6
	MOV r7,#7
	MOV r8,#8
	MOV r9,#9
	MOV r10,#10
	
	STR r1,[r0],#4
	; 1! = 1
	
	STR r2,[r0],#4
	; 2! = 2
	
	MUL r3, r2, r3
	STR r3,[r0],#4
	; 3! = 3 x 2!
	
	MUL r4,r3,r4
	STR r4,[r0],#4
	; 4! = 4 x 3!
	
	MUL r5,r4,r5
	STR r5,[r0],#4
	; 5! = 5 x 4!
	
	MUL r6,r5,r6
	STR r6,[r0],#4
	; 6! = 6 x 5!
	
	MUL r7,r6,r7
	STR r7,[r0],#4
	; 7! = 7 x 6!
	
	MUL r8,r7,r8
	STR r8,[r0],#4
	; 8! = 8 x 7!
	
	MUL r9,r8,r9
	STR r9,[r0],#4
	; 9! = 9 x 8!
	
	MUL r10,r9,r10
	STR r10,[r0],#4
	; 10! = 10 x 9!

TEMPADDR	&	&40000000

	END