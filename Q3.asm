org 100h

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    CALL GET_INPUT    
    CALL NEW_LINE
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    CALL INIT1
    CALL TO_BINARY
    
    
    
    CALL INIT2
    CALL TO_BINARY
    
    CALL NEW_LINE
    
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    
    CALL TO_HEX    

ret

GET_INPUT:
    LEA DX, NUM
    MOV AH, 0AH
    INT 21H
    
;    MOV AH, 1
;    INT 21H
;    MOV BH, AL
;    INT 21H
;    MOV BL, AL
;    
;;    MOV AL, BH
;;    MOV CL, 10
;;    MUL CL
;;    ADD AL, BL
;;    MOV AH, 0
;    ADD NUM1, BH
;    ADD NUM2, BL
    RET

INIT1:
    SUB NUM1,'1'
    MOV AL, NUM1
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    RET

INIT2:
    MOV AL, NUM2
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    RET

INIT:
    MOV AL, NUM1
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    RET

TO_BINARY:
    ; convert first digit to value 0..15 from ascii:
    MOV AL, NUM[2]
    CMP AL, '0'
    JAE F1
    
    F1:
    CMP AL, '9'
    JA F2
    
    SUB AL, 30H
    JMP NUM1_READY
                  
                  
    F2:
    OR AL, 0010000B
    SUB AL, 57H
    
    NUM1_READY:
    MOV BL, 16
    MUL BL
    
    MOV TEMP, AX

    MOV AL, NUM[3]
    CMP AL, '0'
    JAE G1
    
    G1:
    CMP AL, '9'
    JA G2
    
    SUB AL, 30H
    JMP NUM2_READY
    
    G2:
    OR AL, 0010000B
    SUB AL, 57H
    
    NUM2_READY:
    XOR AH, AH
    ADD TEMP, AX
    PUSH TEMP
    
    MOV DI, 2
    
    NEXT_DIGIT:
    
    CMP TEMP, 0
    JE STOP
    
    MOV AX, TEMP
    MOV AH, 0
    MOV BL, 10
    DIV BL
    MOV RESULT[DI], AH
    ADD RESULT[DI], '0'
    
    XOR AH, AH
    ADD TEMP, AX
    
    DEC DI
    JMP NEXT_DIGIT
    
    STOP:
    POP TEMP
    
    MOV BL, B.TEMP
    MOV CX, 8
    
    PRINT:
    MOV AH, 2
    MOV DL, '0'
    TEST BL, 10000000B
    MOV DL, '1'
    
    ZERO:
        INT 21H
        SHL BL, 1
        LOOP PRINT

    MOV DL, 'B'
    INT 21H
    RET
    
TO_HEX:
    CALL INIT
    MOV AH, 0
    MOV BL, 16
    
    DIVIDE_H:
        DIV BL
        MOV DL, AH
        MOV AH, 0
        PUSH DX
        INC CX
        CMP AX, 0
        JNE DIVIDE_H
        JMP DISPLAY_H
        
    GRT_9:
        ADD DX, 7
        JMP SHOW_CHAR 
        
    DISPLAY_H:        
        POP DX
        CMP DX, 9
        JG GRT_9
    
    SHOW_CHAR:
        ADD DX, 48    
        CALL DISPLAY_CHAR
        LOOP DISPLAY_H
        
    JMP EXIT    
        

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

MSG1 DB 'Input hexadecimal value: $' 
MSG2 DB 'in binary$'
MSG3 DB 'in octal$'
NUM DB 10, ?, 10 DUP(?)
TEMP DW ?
RESULT DB '000',- 0

NUM1 DB ?
NUM2 DB ?

