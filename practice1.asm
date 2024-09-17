org 100h

    LEA DX, MSG1_PROMPT
    MOV AH, 9
    INT 21H
    
    MOV BX, 2
    CALL GET_PASSWORD    
    CALL NEW_LINE
    
    LEA DX, MSG2_PROMPT
    MOV AH, 9
    INT 21H
    
    MOV BX, 2
    CALL GET_INPUT    
    CALL NEW_LINE
    
    CALL PASSWORD_CHECKER   

ret

PASSWORD_CHECKER:
    XOR AX, AX
    XOR CX, CX
    LEA SI, PASSWORD+2
    LEA DI, INPUT+2
    MOV CL, PASSWORD[1]
    
COMPARE:
    MOV AL, [SI]
    MOV BL, [DI]
    
    CMP AL, BL
    JNE ERROR_PROMPT
    
    INC SI
    INC DI

    LOOP COMPARE

    CALL SUCCESS_PROMPT
    
    RET
    
SUCCESS_PROMPT:
    LEA DX, SUCCESS_MSG
    MOV AH, 9
    INT 21H    
    
    RET

ERROR_PROMPT:
    LEA DX, ERROR_MSG
    MOV AH, 9
    INT 21H    
    
    RET

GET_PASSWORD:
    MOV AH, 7
    INT 21H
    
    CMP AL, 13
    JE END_PASSWORD
    
    MOV [PASSWORD+BX], AL
    INC BX
    INC PASSWORD[1]
    MOV AH, 2
    MOV DL, '*'
    INT 21H
    
    
    JMP GET_PASSWORD
    
    END_PASSWORD:
        RET

GET_INPUT:
    MOV AH, 7
    INT 21H
    
    CMP AL, 13
    JE END_INPUT
    
    MOV [INPUT+BX], AL
    INC BX
    INC INPUT[1]
    MOV AH, 2
    MOV DL, '*'
    INT 21H
    
    
    JMP GET_INPUT
    
    END_INPUT:
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

MSG1_PROMPT DB 'ENTER A NEW PASSWORD: $'
MSG2_PROMPT DB 'ENTER PASSWORD: $'
SUCCESS_MSG DB 'Access Granted!$'
ERROR_MSG DB 'Access Denied!$' 
INPUT DB 15, ?, 15 DUP(?)
PASSWORD DB 15, ?, 15 DUP(?)
