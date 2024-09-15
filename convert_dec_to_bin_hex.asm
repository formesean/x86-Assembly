org 100h

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    CALL GET_INPUT    
    CALL NEW_LINE
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

    CALL TO_BINARY
    CALL NEW_LINE
    
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    
    CALL TO_HEX    

ret

GET_INPUT:
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    MOV BH, AL
    INT 21H
    SUB AL, '0'
    MOV BL, AL
    
    MOV AL, BH
    MOV CL, 10
    MUL CL
    ADD AL, BL
    MOV AH, 0
    ADD NUM, AL
    RET

INIT:
    MOV AL, NUM
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    RET

TO_BINARY:
    CALL INIT
    MOV AH, 0
    MOV BL, 2
    
    DIVIDE_B:
        DIV BL
        MOV DL, AH
        MOV AH, 0
        PUSH DX
        INC CX
        CMP AX, 0
        JNE DIVIDE_B

    DISPLAY_B:        
        POP DX
        ADD DX, '0'
        CALL DISPLAY_CHAR
        LOOP DISPLAY_B 
    
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

MSG1 DB 'INPUT VALUE: $' 
MSG2 DB 'BINARY IS: $'
MSG3 DB 'HEX IS: $'
NUM DB ?
