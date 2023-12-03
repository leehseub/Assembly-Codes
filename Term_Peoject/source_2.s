	AREA code_area, CODE, READONLY
		ENTRY

float_number_series EQU 0x0450
sorted_number_series EQU 0x00018AEC	;101100
final_result_series EQU 0x00031190	;201104

;========== Do not change this area ===========

initialization
	LDR r0, =0xDEADBEEF				; seed for random number
	LDR r1, =float_number_series	
	LDR r2, =10000  				; The number of element in stored sereis
	LDR r3, =0x0EACBA90				; constant for random number

save_float_series
	CMP r2, #0
	BEQ is_init
	BL random_float_number
	STR r0, [r1], #4
	SUB r2, r2, #1
	MOV r5, #0
	B save_float_series

random_float_number
	MOV r5, LR
	EOR r0, r0, r3
	EOR r3, r0, r3, ROR #2	; ex) 0000 1011 -> 1100 0010
	CMP r0, r1
	BLGE shift_left
	BLLT shift_right
	BX r5

shift_left
	LSL r0, r0, #1
	BX LR

shift_right
	LSR r0, r0, #1
	BX LR
	
;============================================

;========== Start your code here ===========
	
is_init
	MOV r1, #1
	LDR r11, =10000
	B   sorting				;Excepting function of NaN
	
sorting
	LDR r0, =float_number_series
    MOV r10, r1,LSL#2
	MOV r12, r1
    ADD r0, r0, r10
    CMP r11, #0
    BNE sort_loop
	CMP r11, #0
    BEQ is_str

sort_loop
	CMP r12, #0
	ADDEQ r1, r1, #1
	
	CMP r12, #0
	BEQ sorting
	
	LDR r2, [r0]    ;r2 : key

    MOV r4, r2, LSR#31  ;sign bit

	MOV r5, r2, LSL#1
	MOV r5, r5, LSR#24  ;exponent
	
	MOV r6, r2, LSL#9
	MOV r6, r6, LSR#9   ;fraction
	
	SUB r0, r0, #4
	LDR r3, [r0]
	
    MOV r7, r3, LSR#31  ;sign bit

	MOV r8, r3, LSL#1
	MOV r8, r8, LSR#24  ;exponent
	
	MOV r9, r3, LSL#9
	MOV r9, r9, LSR#9   ;fraction
	
	CMP r4, r7          
    ;compare sign bit
    ;GT : r2 = 1 & r3 = 0 (r2 is neg num & r3 is pos num)
    ;LT : r2 = 0 & r3 = 1 (r2 is pos num & r3 is neg num)
	STRGT r2, [r0]		;if key value is lower than target swap two values
	CMP r4, r7
	STRGT r3, [r0,#4]
	CMP r4, r7
	SUBGT r12, r12, #1
	CMP r4, r7
	BGT	sort_loop
	CMP r4, r7
	SUBLT r11, r11, #1
	CMP r4, r7
    ADDLT r1, r1, #1
	CMP r4, r7
	BLT sorting          ;if key value is higher than target, escape loop & compare next key

    ;if both are negative
    CMP r4,#1
    BEQ n_sort_exp

    ;if both are positive
    CMP r4,#0
    BEQ p_sort_exp
	
;exponent compare function of two negative numbers
n_sort_exp
	CMP r5, r8          ;compare exponent
    STRGT r2, [r0]      ;if r2 has bigger exponent, swap them
	CMP r5, r8
    STRGT r3, [r0,#4]
	CMP r5, r8
	SUBGT r12, r12, #1
	CMP r5, r8
    BGT sort_loop
	CMP r5, r8
	SUBLT r11, r11, #1
	CMP r5, r8
    ADDLT r1, r1, #1    ;if r3 has bigger exponent, sort next key
	CMP r5, r8
    BLT sorting
	CMP r5, r8
    BEQ n_sort_frac     ;if exponents are same, then compare fraction

;fraction compare function of two negative numbers
n_sort_frac
    CMP r6, r9
    STRGT r2, [r0]      ;if r2 is greater, swap them
	CMP r6, r9
    STRGT r3, [r0],#4
	CMP r6, r9
	SUBGT r12, r12, #1
	CMP r6, r9
    BGT sort_loop
	SUB r11, r11, #1
    ADD r1, r1, #1    ;if r3 is greater or Equal, sort next key
    B sorting

;exponent compare function of two positive numbers
p_sort_exp
	CMP r5, r8          ;compare exponent
    STRLT r2, [r0]      ;if exponent of r3 is greater, swap them
	CMP r5, r8
    STRLT r3, [r0, #4]
	CMP r5, r8
	SUBLT r12, r12, #1
	CMP r5, r8
    BLT sort_loop    
	CMP r5, r8
	SUBGT r11, r11, #1
	CMP r5, r8
    ADDGT r1, r1, #1    ;if exponent of r2 is greater, sort next key
	CMP r5, r8
    BGT sorting
	CMP r5, r8
    BEQ p_sort_frac     ;if two exponents are same, compare fraction

;fraction compare function of two positive numbers
p_sort_frac
    CMP r6, r9
    STRLT r2, [r0]      ;if fraction of r3 is greater than r3, swap
	CMP r6, r9
    STRLT r3, [r0,#4]
	CMP r6, r9
	SUBLT r12, r12, #1
	CMP r6, r9
    BLT sort_loop
	SUB r11, r11, #1
    ADD r1, r1, #1    ;if fraction of r2 is greater than or Equal to r2, sort next key
    B sorting

is_str
    LDR r0, =float_number_series
    LDR r1, =final_result_series
    LDR r2, =10000
    B is_str_loop

is_str_loop
    CMP r2, #0
    BEQ exit

    LDR r3, [r0], #4
    STR r3, [r1], #4
    SUB r2, r2, #1
    B is_str_loop

exit
	END

;========== End your code here ===========
