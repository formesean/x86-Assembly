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
    MOV DL, 41
    SUB DL, INPUT[1]
    MOV DH, 24 
    
    PUSH DS
    POP ES
    LEA BP, INPUT+2
    MOV AH, 13H
    INT 10H
    
    MOV AX, 0B800H
    MOV ES, AX

    XOR AX, AX
    XOR BX, AX
    XOR DX, DX
    
    MOV CX, 25
    MOV DI, 3916
    
    MOV ES:[DI+2], 00H
    STR_LOOP2:
        CMP CX,1
        JG DO3
 
        DO3:
        MOV AX, DI
        SUB DI, 160 
        MOV AX, DI
        MOV DL, INPUT[3]
        MOV DH, 07H
        MOV ES:[DI+2], DX 
        CMP CX, 2
        JNE DO4
        LOOP STR_LOOP2
        
        DO4:
        MOV ES:[DI+2], 00H
        LOOP STR_LOOP2
    
    MOV CX, 38
    MOV DI, 3916
    MOV BX, 3920 
    
    AWAY:
        CMP CX, 0
        JE CONT2
        MOV DL, INPUT[2]
        MOV DH, 00H
        MOV ES:[DI], DX
        SUB DI, 2
        MOV DL, INPUT[2]
        MOV DH, 07H
        MOV ES:[DI], DX
        
        PUSH DI
        MOV DI, BX
        
        MOV DL, INPUT[4]
        MOV DH, 00H
        MOV ES:[DI], DX
        ADD DI, 2
        MOV DL, INPUT[4]
        MOV DH, 07H
        MOV ES:[DI], DX
        
        MOV BX, DI
        POP DI
        PUSH DX
        LOOP AWAY
    
    CONT2:
    MOV DI, BX
    MOV DL, INPUT[4]
    MOV DH, 00H
    MOV ES:[DI], DX
    ADD DI, 2
    MOV DL, INPUT[4]
    MOV DH, 07H
    MOV ES:[DI], DX
    
    MOV CX, 24
    MOV DI, 3840
    
    ; MOVE LEFT CHARACTER UPWARDS
    STR_LOOP5:
        MOV DL, INPUT[2]
        MOV DH, 00H
        MOV ES:[DI], DX
        SUB DI, 160
        MOV DL, INPUT[2]
        MOV DH, 07H
        MOV ES:[DI], DX
    LOOP STR_LOOP5
    
    MOV CX, 24
    MOV DI, 3998
    
    ; MOVE RIGTH CHARACTER UPWARDS
    STR_LOOP6:
        MOV DL, INPUT[4]
        MOV DH, 00H
        MOV ES:[DI], DX
        SUB DI, 160
        MOV DL, INPUT[4]
        MOV DH, 07H
        MOV ES:[DI], DX
    LOOP STR_LOOP6
    
    MOV CX, 38
    MOV DI, 0
    MOV BX, 160
        
    INWARDS:
        CMP CX, 0
        JE CONT2
        MOV DL, INPUT[2]
        MOV DH, 00H
        MOV ES:[DI], DX
        ADD DI, 2
        MOV DL, INPUT[2]
        MOV DH, 07H
        MOV ES:[DI], DX
        
        PUSH DI
        MOV DI, BX
        
        MOV DL, INPUT[4]
        MOV DH, 00H
        MOV ES:[DI], DX
        SUB DI, 2
        MOV DL, INPUT[4]
        MOV DH, 07H
        MOV ES:[DI], DX
                
        MOV BX, DI
        POP DI
        PUSH DX
        LOOP INWARDS
        
    MOV CX, 2
    MOV DI, BX 
    
    MORE:     
        MOV DL, INPUT[4]
        MOV DH, 00H
        MOV ES:[DI], DX
        SUB DI, 2
        MOV DL, INPUT[4]
        MOV DH, 07H
        MOV ES:[DI], DX
        LOOP MORE
        
    JMP EXIT                
ret

SET_CURSOR_POS:
    MOV DL, 40
    SUB DL, INPUT[1]
    ADD DL ,1
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
    
EXIT:
    MOV AH, 4CH
    INT 21H    

MSG_PROMPT DB 'ENTER A ODD STRING: $' 
INPUT DB 15, ?, 15 DUP(?)
BLANK DB '                $'
