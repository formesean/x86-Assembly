
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
    
    LEA DX, MSG_PROMPT
    MOV AH, 9
    INT 21H
    
    CALL GET_INPUT
    CALL CLEAR_SCREEN
    
    XOR CX, CX
    MOV DH, 24 
    
    DISPLAY:
        MOV AL, 1
        MOV BL, 07H
        MOV CL, INPUT[1]
        
        MOV BH, INPUT[[1]
        CMP BH, 5
        JE LEN5
        
        MOV BH, 0  
        MOV DL, 41
        SUB DL, INPUT[1]
        
        START:
            LEA BP, INPUT+2
            MOV AH, 13H
            INT 10H
            
            CMP DH, 0
            JE AT_TOP
            
            LEA BP, BLANK
            MOV AH, 13H
            INT 10H
            
            DEC DH
            JMP DISPLAY
           
ret

AT_TOP PROC
    MOV AX, 0B800H
    MOV ES, AX

    XOR BX, BX
    XOR DX, DX
    
    MOV BL, INPUT[1]
    CMP BX, 5
    JE MOVE_2OUTWARDS
    
    MOV CX, 38    
    MOV DI, 76
    MOV SI, 80
    
    MOV DL, INPUT[4]
    MOV DH, 00H
    MOV ES:[SI], DX
    ADD SI, 2
    MOV DL, INPUT[4]
    MOV DH, 07H
    MOV ES:[SI], DX

    CALL MOVE_1OUTWARDS
        
    CALL MOVE_DOWN 
    CALL MOVE_DOWN
    CALL MOVE_DOWN
    CALL MOVE_DOWN
    CALL MOVE_DOWN 
    CALL MOVE_DOWN
    CALL MOVE_DOWN
    CALL MOVE_DOWN

    MOV CX, 38
    MOV DI, 3840
    MOV SI, 3998

    MOV DL, INPUT[4]
    MOV DH, 00H
    MOV ES:[SI], DX
    SUB SI, 2
    MOV DL, INPUT[4]
    MOV DH, 07H
    MOV ES:[SI], DX    
    
    CALL MOVE_1INWARDS
    
    CALL MOVE_UP
    CALL MOVE_UP
    CALL MOVE_UP
    CALL MOVE_UP

    JMP EXIT
   
AT_TOP ENDP

LEN5:  
    MOV BH, 0  
    MOV DL, 43
    SUB DL, INPUT[1]    
    JMP START

MOVE_1OUTWARDS:
    CMP CX, 0
    JE DONE1
    
    MOV DL, INPUT[2]
    MOV DH, 00H
    MOV ES:[DI], DX
    SUB DI, 2
    MOV DL, INPUT[2]
    MOV DH, 07H
    MOV ES:[DI], DX
    
    MOV DL, INPUT[4]
    MOV DH, 00H
    MOV ES:[SI], DX
    ADD SI, 2
    MOV DL, INPUT[4]
    MOV DH, 07H
    MOV ES:[SI], DX
    LOOP MOVE_1OUTWARDS
    
    DONE1:
        RET

MOVE_2OUTWARDS:
    MOV CX, 37 
    MOV DI, 76
    MOV SI, 78
    PUSH DI
    PUSH SI
    ; 72 74 76 78 80

    MOV DL, INPUT[2]
    MOV DH, 00H
    MOV ES:[DI], DX
    MOV BL, INPUT[3]
    MOV BH, 00H
    MOV ES:[SI], BX
    
    SUB DI, 2
    MOV DL, INPUT[2]
    MOV DH, 07H
    MOV ES:[DI], DX    
    SUB SI, 2
    MOV BL, INPUT[3]
    MOV BH, 07H
    MOV ES:[SI], BX
    
    PUSH DI
    PUSH SI

    MOVE_2:    
        CMP CX, 0
        JE DONE2
        
        POP SI
        POP DI
        
        MOV DL, INPUT[2]
        MOV DH, 00H
        MOV ES:[DI], DX
        MOV BL, INPUT[3]
        MOV BH, 00H
        MOV ES:[SI], BX
        
        SUB DI, 2
        MOV DL, INPUT[2]
        MOV DH, 07H
        MOV ES:[DI], DX    
        SUB SI, 2
        MOV BL, INPUT[3]
        MOV BH, 07H
        MOV ES:[SI], BX
        
        PUSH DI
        PUSH SI
        
        MOV DI, L4_HOLDER1
        MOV SI, L5_HOLDER1

        MOV DL, INPUT[5]
        MOV DH, 00H
        MOV ES:[DI], DX
        MOV BL, INPUT[6]
        MOV BH, 00H
        MOV ES:[SI], BX
        
        ADD DI, 2
        MOV DL, INPUT[5]
        MOV DH, 07H
        MOV ES:[DI], DX    
        ADD SI, 2
        MOV BL, INPUT[6]
        MOV BH, 07H
        MOV ES:[SI], BX
        
        MOV L4_HOLDER1, DI
        MOV L5_HOLDER1, SI        
        LOOP MOVE_2
    
    DONE2:
        CALL MOVE_DOWN 
        CALL MOVE_DOWN
        CALL MOVE_DOWN
        CALL MOVE_DOWN
        CALL MOVE_DOWN 
        CALL MOVE_DOWN
        CALL MOVE_DOWN
        CALL MOVE_DOWN 
       
        JMP MOVE_2INWARDS  

MOVE_DOWN: 
    MOV AL, 1
    MOV BH, 00H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 79
    MOV AH, 07H
    INT 10H
    
    MOV AL, 1
    MOV BH, 00H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 79
    MOV AH, 07H
    INT 10H 
    
    MOV AL, 1
    MOV BH, 00H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 79
    MOV AH, 07H
    INT 10H
    RET

MOVE_1INWARDS:
    CMP CX, 0
    JE DONE3
    
    MOV DL, INPUT[2]
    MOV DH, 00H
    MOV ES:[DI], DX
    ADD DI, 2
    MOV DL, INPUT[2]
    MOV DH, 07H
    MOV ES:[DI], DX
    
    MOV DL, INPUT[4]
    MOV DH, 00H
    MOV ES:[SI], DX
    SUB SI, 2
    MOV DL, INPUT[4]
    MOV DH, 07H
    MOV ES:[SI], DX   
    LOOP MOVE_1INWARDS
    
    DONE3:
        RET

MOVE_2INWARDS:
    MOV CX, 37 
    MOV DI, 3840
    MOV SI, 3842
    PUSH DI
    PUSH SI

    MOV DL, INPUT[2]
    MOV DH, 00H
    MOV ES:[DI], DX
    MOV BL, INPUT[3]
    MOV BH, 00H
    MOV ES:[SI], BX
    
    ADD DI, 2
    MOV DL, INPUT[2]
    MOV DH, 07H
    MOV ES:[DI], DX    
    ADD SI, 2
    MOV BL, INPUT[3]
    MOV BH, 07H
    MOV ES:[SI], BX
    
    PUSH DI
    PUSH SI

    MOVE_21:    
        CMP CX, 0
        JE DONE3
        
        POP SI
        POP DI
        
        MOV DL, INPUT[2]
        MOV DH, 00H
        MOV ES:[DI], DX
        MOV BL, INPUT[3]
        MOV BH, 00H
        MOV ES:[SI], BX
        
        ADD DI, 2
        MOV DL, INPUT[2]
        MOV DH, 07H
        MOV ES:[DI], DX    
        ADD SI, 2
        MOV BL, INPUT[3]
        MOV BH, 07H
        MOV ES:[SI], BX
        
        PUSH DI
        PUSH SI
        
        MOV DI, L4_HOLDER2
        MOV SI, L5_HOLDER2

        MOV DL, INPUT[5]
        MOV DH, 00H
        MOV ES:[DI], DX
        MOV BL, INPUT[6]
        MOV BH, 00H
        MOV ES:[SI], BX
        
        SUB DI, 2
        MOV DL, INPUT[5]
        MOV DH, 07H
        MOV ES:[DI], DX    
        SUB SI, 2
        MOV BL, INPUT[6]
        MOV BH, 07H
        MOV ES:[SI], BX
        
        MOV L4_HOLDER2, DI
        MOV L5_HOLDER2, SI        
        LOOP MOVE_21
    
    DONE4:
        CALL MOVE_UP
        CALL MOVE_UP
        CALL MOVE_UP
        CALL MOVE_UP 
        
        JMP EXIT

MOVE_UP: 
    MOV AL, 1
    MOV BH, 00H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 79
    MOV AH, 06H
    INT 10H
    
    MOV AL, 1
    MOV BH, 00H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 79
    MOV AH, 06H
    INT 10H 
    
    MOV AL, 1
    MOV BH, 00H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 79
    MOV AH, 06H
    INT 10H
    RET

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
INPUT DB 20, ?, 20 DUP(?)
BLANK DB '                    '
L4_HOLDER1 DW 82
L5_HOLDER1 DW 84
L4_HOLDER2 DW 3996
L5_HOLDER2 DW 3998
