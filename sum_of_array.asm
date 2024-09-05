; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
MAIN PROC
    MOV AX, 0B800H
    MOV ES, AX                      ; STORE TO DATA SEGMENT
    MOV DI, 0
    
    ;LEA SI, WORD                    ; LOAD WORD DB INTO SI
    ;MOV CX, 11                      ; LENGHT OF WORD
    
    ;.DISPLAY_WORD:                  ; DISPLAYS WORD 
    ;    MOV DL, [SI]
    ;    CALL DISPLAY_CHAR
    ;    INC SI
    ;LOOP .DISPLAY_WORD
    
    LEA SI, NUMs                     ; LOAD WORD DB INTO SI
    MOV CX, 5                       ; LENGHT OF NUM ARRAY
    
    XOR BX, BX
    
    .DISPLAY_DIGIT:                 ; DISPLAYS NUM
        MOV AX, 00H
        MOV AL, [SI]
        ADD SUM, AX
        MOV BL, 10                  ; MOV 10 TO FOR DIVISION
        DIV BL                      ; AX/BL, STORE QUOTIENT TO AL & REMAINDER TO AH
              
        MOV DL, AL                  ; MOVE TENS TO DL
        ADD DL, '0'      
        CALL DISPLAY_CHAR
        
        MOV DL, AH                  ; MOVE ONES TO DL
        ADD DL, '0'      
        CALL DISPLAY_CHAR
        
        DEC CX        
        JZ DISPLAY_EQUAL
        
        MOV DL, ' '
        CALL DISPLAY_CHAR   
        MOV DL, '+'
        CALL DISPLAY_CHAR
        MOV DL, ' '
        CALL DISPLAY_CHAR
        
        INC SI
        JMP .DISPLAY_DIGIT
        
    .READY_SUM:
        MOV AX, SUM
        MOV CX, 1
        XOR BX, BX
        
        .DISPLAY_SUM:                 ; DISPLAYS NUM
            ;MOV AH, 00H 
            MOV BL, 10                  ; MOV 10 TO FOR DIVISION
            DIV BL                      ; AX/BL, STORE QUOTIENT TO AL & REMAINDER TO AH
            MOV BH, AH
            MOV AH, 0H
            DIV BL 
                  
            MOV DL, AL                  ; MOVE HUNDREDS TO DL
            ADD DL, '0'      
            CALL DISPLAY_CHAR
            
            MOV DL, AH                  ; MOVE TENS TO DL
            ADD DL, '0'      
            CALL DISPLAY_CHAR
            
            MOV DL, BH                  ; MOVE ONES TO DL
            ADD DL, '0'      
            CALL DISPLAY_CHAR
            
            MOV DL, ' '
            CALL DISPLAY_CHAR
            INC SI
        LOOP .DISPLAY_SUM
        JMP .END
.END:           
    ret
MAIN ENDP

DISPLAY_CHAR PROC
    MOV DH, 00001011B
    MOV ES:[DI], DX
    INC DI
    INC DI
    RET  
DISPLAY_CHAR ENDP

DISPLAY_EQUAL PROC 
    MOV DL, ' '
    CALL DISPLAY_CHAR   
    MOV DL, '='
    CALL DISPLAY_CHAR
    MOV DL, ' '
    CALL DISPLAY_CHAR
    JMP .READY_SUM
DISPLAY_EQUAL ENDP
  
WORD DB 'THE SUM OF '
NUMS DB 50, 50, 50, 50, 60
SUM DW 0
