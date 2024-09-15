org 100h

    LEA DX, MSG_PROMPT
    MOV AH, 9
    INT 21H
    
    MOV BX, 2
    
    CALL GET_INPUT    
    CALL NEW_LINE
    
    CALL PASSWORD_CHECKER   

ret

PASSWORD_CHECKER:
    LEA SI, PASSWORD
    LEA DI, INPUT+2
    MOV AL, [SI]
    MOV BL, [DI]
    
    CMP AL, BL
    JNE ERROR_PROMPT
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

GET_INPUT:
    MOV AH, 7
    INT 21H
    
    CMP AL, 13
    JE END_INPUT
    
    MOV [INPUT+BX], AL
    MOV AH, 2
    MOV DL, '*'
    INT 21H
    
    INC BX
    LOOP GET_INPUT
    
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

MSG_PROMPT DB 'ENTER PASSWORD: $'
SUCCESS_MSG DB 'Access Granted!$'
ERROR_MSG DB 'Access Denied!$' 
INPUT DB 15, ?, 15 DUP(?)
PASSWORD DB 'SEAN'
