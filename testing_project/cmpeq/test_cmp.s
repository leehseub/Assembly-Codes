	AREA	code_area, CODE, READONLY
		ENTRY

start
	MOV r0, #1
	MOV r1, #2
	MOV r3, #3
	
	CMP r0,#1
	CMPEQ r1,#3
	MOVEQ r3,#4
	
exit
	END