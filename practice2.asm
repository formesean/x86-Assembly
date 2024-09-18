org 100h
    
    LEA DX, MSG_PROMPT
    MOV AH, 9
    INT 21H
    
    CALL GET_INPUT
    CALL CLEAR_SCREEN 

    MOV DH, 0
    MOV CX, 24
    MOV BH, 0
    
    DISPLAY:    
        CALL SET_CURSOR_POS
        PUSH DX

        XOR BX, BX
        MOV BL, INPUT[1]
        MOV INPUT[BX+2], '$'
        LEA DX, INPUT+2
        MOV AH, 9
        INT 21H
        
        POP DX
        PUSH DX
        CALL SET_CURSOR_POS
        LEA DX, BLANK
        MOV AH, 9
        INT 21H
        
        POP DX
        INC DH
        LOOP DISPLAY
                 
    MOV AL, 1
    MOV BL, 07H
    MOV BH, 0
    MOV CL, INPUT[1]  
    MOV DL, 40
    SUB DL, INPUT[1]
    MOV DH, 24 
    
    PUSH DS
    POP ES
    LEA BP, INPUT+2
    MOV AH, 13H
    INT 10H
               
ret

SET_CURSOR_POS:
    MOV DL, 40
    SUB DL, INPUT[1]
    MOV AH, 2
    INT 10H
    RET    

GET_INPUT:
    LEA DX, INPUT
    MOV AH, 0AH
    INT 21H
    RET

CLEAR_SCREEN:
    MOV AL, 03H
    MOV AH, 0
    INT 10H
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

MSG_PROMPT DB 'ENTER A ODD STRING: $' 
INPUT DB 15, ?, 15 DUP(?)
BLANK DB '                $'
