
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
    MOV AX, 0B800H
    MOV ES, AX                      ; STORE TO DATA SEGMENT
    MOV DI, 0
    
    LEA SI, WORD                    ; LOAD WORD DB INTO SI
    MOV CX, 11                      ; LENGHT OF WORD
    
    .DISPLAY_WORD:                  ; DISPLAYS WORD 
        MOV DL, [SI]
        MOV DH, 00001011B   
        MOV ES:[DI], DX
        INC SI
        INC DI
        INC DI
    LOOP .DISPLAY_WORD
    
    LEA SI, NUMS                    ; LOAD NUMS DB INTO SI
    MOV CX, 9                       ; LENGHT OF TOTAL NUMS WITH PLUS SIGN        

    .DISPLAY_NUMS:                  ; DISPLAYS EACH CHAR IN NUMS WITH SPACE AND PLUS SIGN 
        MOV DL, [SI]
        ADD BL, DL
        ADD DL, '0'
        MOV DH, 00001011B   
        MOV ES:[DI], DX
        INC SI
        INC DI
        INC DI
        
        DEC CX                      ; DECREMENTS CX AFTER A CHAR IS DISPLAYED
        JZ .DISPLAY_EQUALS          ; DISPLAYS EQUAL SIGN WHEN CX IS 0
        CALL .SPACE
        CALL .PLUS
        CALL .SPACE     
    LOOP .DISPLAY_NUMS              ; DECREMENTS CX AFTER EACH LOOP
    
    .DISPLAY_EQUALS:                ; DISPLAYS EQUAL SIGN WITH SPACE
        CALL .SPACE
        MOV DL, '='
        MOV DH, 00001011B
        MOV ES:[DI], DX
        INC DI
        INC DI
        CALL .SPACE
        
    .DISPLAY_SUM:                   ; DISPLAY THE SUM OF NUMS (SUPPORTS 0-9 ONLY)
        MOV DL, BL
        ADD DL, '0'
        MOV DH, 00001011B
        MOV ES:[DI], DX
        INC SI
        INC DI
        INC DI
        JMP .END       
    
    .PLUS:                          ; DISPLAYS PLUS SIGN
        MOV DL, '+'
        MOV DH, 00001011B
        MOV ES:[DI], DX
        INC DI
        INC DI
        RET
        
    .SPACE:                         ; DISPLAYS WHITE SPACE
        MOV DL, ' '
        MOV DH, 00001011B
        MOV ES:[DI], DX
        INC DI
        INC DI
        RET     

.END:
ret
  
WORD DB 'THE SUM OF '
NUMS DB 1, 2, 3, 2, 1
