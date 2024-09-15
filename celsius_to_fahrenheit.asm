org 100h

    LEA DX, MSG_PROMPT
    MOV AH, 9
    INT 21H
    
    MOV BX, 2
    
    CALL GET_INPUT    
    CALL NEW_LINE
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    CALL TO_FARENHEIT
    CALL DISPLAY_FARENHEIT
ret

DISPLAY_FARENHEIT:
    XOR BX, BX
    MOV AX, FARENHEIT

    MOV BL, 10                  ; MOV 10 TO FOR DIVISION
    DIV BL                      ; AX/BL, STORE QUOTIENT TO AL & REMAINDER TO AH
    MOV REMAINDER, AH
    MOV AH, 0H
    DIV BL
    MOV BH, AH 
          
    MOV DL, AL                  ; MOVE HUNDREDS TO DL
    ADD DL, '0'      
    CALL DISPLAY_CHAR
    
    MOV DL, BH                  ; MOVE TENS TO DL
    ADD DL, '0'      
    CALL DISPLAY_CHAR
    
    MOV DL, REMAINDER           ; MOVE ONES TO DL
    ADD DL, '0'      
    CALL DISPLAY_CHAR
    
    RET

TO_FARENHEIT:
    XOR BX, BX
    XOR DX, DX
    MOV AX, NUM
    MOV BL, 9
    MUL BL

    MOV BL, 5
    DIV BL 
    ADD AX, 32       
    MOV AH, 0
    MOV FARENHEIT, AX
    
    RET

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
    ADD NUM, AX
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

MSG_PROMPT DB 'Enter Celcius (2 Digit): $'
MSG2 DB 'Farenheit is: $' 
NUM DW ?
FARENHEIT DW ?
REMAINDER DB ?
