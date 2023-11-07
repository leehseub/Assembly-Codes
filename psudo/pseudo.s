CR	EQU	0x0D
SPC	EQU	0x20
	AREA	pseudo, CODE, READONLY
	ENTRY
Main
	LDR	R0,=Arr1
	LDR R1,=Arr2

copy_arr_wo_space
	LDRB R2,[R0],#1
	CMP	r2,#SPC
	BEQ	copy_arr_wo_space
	STRB R2,[R1]
	ADD	R1,R1,#1
	CMP	R2,#CR
	BEQ	Done
	ADD R3,R3,#1
	BAL	copy_arr_wo_space

Done
	STRB R3,K
	MOV pc,lr

	AREA dataArray, DATA
K
	DCB	0
Arr1
	DCB	"Hello, World",CR
	ALIGN
Arr2
	DCB	0
	END
