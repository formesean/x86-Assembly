
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

    LEA DX, MSG
    MOV AH, 9
    INT 21H
    
    LEA DX, INPUT
    MOV AH, 0AH
    INT 21H
    
    CALL NEW_LINE
    
    MOV BL, INPUT[1]
    MOV LEN, BL
    XOR BX, BX
    
    LEA SI, LEN
    MOV CX, 1
    CALL DISPLAY_2DIGIT
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

    CALL NEW_LINE
    
    CALL COUNT_VOWELS
    
ret

COUNT_VOWELS:
    LEA SI, INPUT[2]
    MOV AL, [SI]
    
    CMP [SI], 'A'
    JE COUNT1
    CMP [SI], 'E'
    JE COUNT1
    CMP [SI], 'I'
    JE COUNT1
    CMP [SI], 'O'
    JE COUNT1
    CMP [SI], 'U'
    JE COUNT1
    CMP [SI], 'a'
    JE COUNT1
    CMP [SI], 'e'
    JE COUNT1
    CMP [SI], 'i'
    JE .COUNT1
    CMP[SI], 'o'
    JE COUNT1
    CMP [SI], 'u'
    JE COUNT1
    INC SI
    RET

COUNT1:
    INC COUNT
    INC SI
    RET

DISPLAY_2DIGIT:                 ; DISPLAYS NUM
    MOV AX, 00H 
    MOV AL, [SI]
    MOV BL, 10                  ; MOV 10 TO FOR DIVISION
    DIV BL                      ; AX/BL, STORE QUOTIENT TO AL & REMAINDER TO AH
    
    MOV BH, AH      
    MOV DL, AL                  ; MOVE TENS TO DL
    ADD DL, '0'      
    CALL DISPLAY_CHAR
    
    MOV DL, BH                  ; MOVE ONES TO DL
    ADD DL, '0'      
    CALL DISPLAY_CHAR
    
    MOV DL, ' '
    MOV DH, 00001011B
    CALL DISPLAY_CHAR
    INC SI
    LOOP DISPLAY_2DIGIT
    RET

DISPLAY_CHAR:
    MOV AH, 2
    INT 21H
    RET

NEW_LINE:
    MOV DX, 13
    MOV AH, 2
    INT 21H
    MOV DX, 10
    MOV AH, 2
    INT 21H
    RET 
    
EXIT:
    MOV AH, 4CH
    INT 21H 


MSG DB 'Input string [max. 20]: $'
INPUT DB 20, ?, 20 DUP(?)
MSG2 DB '- chars inputted$'
MSG3 DB '-a_s$'

LEN DB ?
VOW_A DB ?
VOW_B DB ?

