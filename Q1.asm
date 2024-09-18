
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt


org 100h

    MOV AX, 0B800H
    MOV ES, AX
    
    MOV DI, 0

    MOV DX, OFFSET MSG1
    MOV AH, 9
    INT 21H

    CALL STR_INPUT 
    CALL DISP_STR   
           
ret

STR_INPUT: 
    MOV DX, OFFSET INPUT 
    MOV AH, 0AH
    INT 21H 
    MOV AX, 0	    
    RET

DISP_STR PROC
    MOV AL, 3
    MOV AH, 0
    INT 10H
    
    XOR AX, AX
    XOR BX, AX
    MOV CX, 25
    XOR DX, DX
    MOV DI, 3918
    JMP MOVE_UP
    ; 76 3918
    ; 0*160+39*2
    ; ROW*LENGTH+CENTER+ALLOC OF CHAR
    
MOVE_UP:    
    
    MOV DL, INPUT[2]
    MOV DH, 0BH
    MOV ES:[DI], DX
    MOV DL, [INPUT+3]
    MOV ES:[DI+2], DX
    MOV DL, [INPUT+4]
    MOV ES:[DI+4], DX

    CMP CX,1
    JG CON1
    JE CON2
    
    CON1:
    MOV ES:[DI], 00H 
    MOV ES:[DI+2], 00H
    MOV ES:[DI+4], 00H 
    SUB DI, 160
    LOOP MOVE_UP
    
    CON2:
    MOV ES:[DI+2], 00H         
    LOOP MOVE_UP
    
    MOV CX, 25
    JMP MOVE_MIDDLE_CHARACTER
    
MOVE_MIDDLE_CHARACTER:
    CMP CX,1
    JG CON3

    CON3:
    MOV AX, DI
    ADD DI, 160 
    MOV AX, DI
    MOV DL, INPUT[3]
    MOV DH, 0BH
    MOV ES:[DI+2], DX 
    CMP CX, 2
    JNE CON4
    LOOP MOVE_MIDDLE_CHARACTER
    
    CON4:
    MOV ES:[DI+2], 00H
    LOOP MOVE_MIDDLE_CHARACTER
    
    MOV CX, 39
    MOV BX, 40
    MOV DI, 78
    JMP MOVE_LEFT
    
MOVE_LEFT:
    MOV DL, INPUT[2]
    MOV DH, 00H
    MOV ES:[DI], DX
    SUB DI, 2
    MOV DL, INPUT[2]
    MOV DH, 0BH
    MOV ES:[DI], DX
    LOOP MOVE_LEFT                  
        
    MOV CX, 40
    MOV DI, 78
    JMP MOVE_RIGHT

MOVE_RIGHT:
    MOV DL, INPUT[4]
    MOV DH, 00H
    MOV ES:[DI], DX
    ADD DI, 2
    MOV DL, INPUT[4]
    MOV DH, 0BH
    MOV ES:[DI], DX
    LOOP MOVE_RIGHT
    
    MOV CX, 24
    MOV DI, 0
    JMP MOVE_LEFT_DOWN
    

MOVE_LEFT_DOWN:
    MOV DL, INPUT[2]
    MOV DH, 00H
    MOV ES:[DI], DX
    ADD DI, 160
    MOV DL, INPUT[2]
    MOV DH, 0BH
    MOV ES:[DI], DX
    LOOP MOVE_LEFT_DOWN
    
    MOV CX, 24
    MOV DI, 158
    JMP MOVE_RIGHT_DOWN

MOVE_RIGHT_DOWN:
    MOV DL, INPUT[4]
    MOV DH, 00H
    MOV ES:[DI], DX
    ADD DI, 160
    MOV DL, INPUT[4]
    MOV DH, 0BH
    MOV ES:[DI], DX
    LOOP MOVE_RIGHT_DOWN
    
    MOV CX, 39
    MOV DI, 3840
    

MOVE_RIGHT_INWARDS:
    MOV DL, INPUT[2]
    MOV DH, 00H
    MOV ES:[DI], DX
    ADD DI, 2
    MOV DL, INPUT[2]
    MOV DH, 0BH
    MOV ES:[DI], DX
    LOOP MOVE_RIGHT_INWARDS
    
    MOV CX, 38
    MOV DI, 3998

MOVE_LEFT_INWARDS:
    MOV DL, INPUT[4]
    MOV DH, 00H
    MOV ES:[DI], DX
    SUB DI, 2
    MOV DL, INPUT[4]
    MOV DH, 0BH
    MOV ES:[DI], DX
    LOOP MOVE_LEFT_INWARDS
    
    MOV CX, 13
    MOV DI, 3918   

MOVE_TO_MIDDLE:
    MOV DL, INPUT[2]
    MOV DH, 0BH
    MOV ES:[DI], DX
    MOV DL, [INPUT+3]
    MOV ES:[DI+2], DX
    MOV DL, [INPUT+4]
    MOV ES:[DI+4], DX

    CMP CX,1
    JG CON5
    JE CON6
    
    CON5:
    MOV ES:[DI], 00H 
    MOV ES:[DI+2], 00H
    MOV ES:[DI+4], 00H 
    SUB DI, 160
    LOOP MOVE_TO_MIDDLE
    
    CON6:  
        
RET

MSG1 DB "INPUT STRING: $"
INPUT DB 10, ?, 10 DUP(?)
