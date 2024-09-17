
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
    MOV DX, OFFSET BUFFER 
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
    MOV DI, 76
    
    ; MOVE STRING DOWNWARDS
    STR_LOOP1:    
        
        MOV DL, BUFFER[2]
        MOV DH, 00001011B
        MOV ES:[DI], DX
        MOV DL, [BUFFER+3]
        MOV ES:[DI+2], DX
        MOV DL, [BUFFER+4]
        MOV ES:[DI+4], DX
  
        CMP CX,1
        JG DO1
        JE DO2
        
        ; CLEAR PREVIOUS ROW
        DO1:
        MOV ES:[DI], 00000000B 
        MOV ES:[DI+2], 00000000B
        MOV ES:[DI+4], 00000000B 
        ADD DI, 160
        LOOP STR_LOOP1
        
        ; CLEAR MIDDLE CHARACTER WHEN AT THE BOTTOM
        DO2:
        MOV ES:[DI+2], 00000000B         
    LOOP STR_LOOP1
    
    MOV CX, 25
    
    ; MOVE MIDDLE CHARACTER UPWARDS
    STR_LOOP2:
        CMP CX,1
        JG DO3
        
        ; 
        DO3:
        MOV AX, DI
        SUB DI, 160 
        MOV AX, DI
        MOV DL, BUFFER[3]
        MOV DH, 00001011B
        MOV ES:[DI+2], DX 
        CMP CX, 2
        JNE DO4
        LOOP STR_LOOP2
        
        DO4:
        MOV ES:[DI+2], 00000000B
        LOOP STR_LOOP2
        
    MOV CX, 38
    MOV BX, 40
    MOV DI, 3916
    
    ; MOVE LEFT CHARACTER TO LEFT
    STR_LOOP3:
        MOV DL, BUFFER[2]
        MOV DH, 00000000B
        MOV ES:[DI], DX
        SUB DI, 2
        MOV DL, BUFFER[2]
        MOV DH, 00001011B
        MOV ES:[DI], DX
    LOOP STR_LOOP3                  
        
    MOV CX, 39
    MOV DI, 3920
    
    ; MOVE RIGHT CHARACTER TO RIGHT
    STR_LOOP4:
        MOV DL, BUFFER[4]
        MOV DH, 00000000B
        MOV ES:[DI], DX
        ADD DI, 2
        MOV DL, BUFFER[4]
        MOV DH, 00001011B
        MOV ES:[DI], DX
    LOOP STR_LOOP4
    
    MOV CX, 24
    MOV DI, 3840
    
    ; MOVE LEFT CHARACTER UPWARDS
    STR_LOOP5:
        MOV DL, BUFFER[2]
        MOV DH, 00000000B
        MOV ES:[DI], DX
        SUB DI, 160
        MOV DL, BUFFER[2]
        MOV DH, 00001011B
        MOV ES:[DI], DX
    LOOP STR_LOOP5
    
    MOV CX, 24
    MOV DI, 3998
    
    ; MOVE RIGTH CHARACTER UPWARDS
    STR_LOOP6:
        MOV DL, BUFFER[4]
        MOV DH, 00000000B
        MOV ES:[DI], DX
        SUB DI, 160
        MOV DL, BUFFER[4]
        MOV DH, 00001011B
        MOV ES:[DI], DX
    LOOP STR_LOOP6
    
    MOV CX, 38
    MOV DI, 0
    
    ; MOVE LEFT CHARACTER RIGHT
    STR_LOOP7:
        MOV DL, BUFFER[2]
        MOV DH, 00000000B
        MOV ES:[DI], DX
        ADD DI, 2
        MOV DL, BUFFER[2]
        MOV DH, 00001011B
        MOV ES:[DI], DX
    LOOP STR_LOOP7
    
    MOV CX, 40
    MOV DI, 160
    
    ; MOVE RIGHT CHARACTER LEFT
    STR_LOOP8:
        MOV DL, BUFFER[4]
        MOV DH, 00000000B
        MOV ES:[DI], DX
        SUB DI, 2
        MOV DL, BUFFER[4]
        MOV DH, 00001011B
        MOV ES:[DI], DX
    LOOP STR_LOOP8   
        
RET
DISP_STR ENDP

MSG1 DB "INPUT STRING: $"
BUFFER DB 10, ?, 10 DUP(?)
