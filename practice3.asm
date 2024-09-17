org 100h
    
    LEA DX, MSG_PROMPT
    MOV AH, 9
    INT 21H
    
    CALL GET_INPUT
    CALL CLEAR_SCREEN 

    MOV DH, 0
    MOV CX, 25
    MOV BH, 0
    
;    XOR BX, BX
;    MOV BL, INPUT[1]
;    MOV INPUT[BX+2], '$'    
    
DISPLAY:    
    CALL SET_CURSOR_POS
    PUSH DX 

    MOV SI, 2          
    MOV BL, INPUT[1] 
     
PRINT_STRING:
    CMP BL, 0
    JE END_OF_ROW 
    
;    LEA DX, INPUT[2] 
;    MOV AH, 9       
;    INT 21H

    MOV AL, INPUT[SI]
    MOV AH, 0EH
    INT 10H     

    INC SI     
    DEC BL
    JMP PRINT_STRING  

END_OF_ROW:
    DEC CX
    
    CMP CX, 0
    JE ADD_IN_BETWEEN
    CALL SET_CURSOR_POS
    
    LEA DX, BLANK
    MOV AH, 9
    INT 21H
    
    POP DX
    INC DH 
    JMP DISPLAY

ret




ADD_IN_BETWEEN:
    ; Initialize the loop counter for spaces
    MOV SI, 0            ; Counter for number of spaces (starting at 0)
    MOV DL, 39

PRINT_LINES:
    ; Set cursor position for new line
    CALL SET_CURSOR_POS

    ; Print the string with spaces
    MOV BX, SI           ; Load the current number of spaces
    MOV CH, 0            ; Row number reset
    MOV DI, 0            ; Index for the string

PRINT_STRING_WITH_SPACES:
    ; Print the current character
    MOV AL, INPUT[DI+2]  ; Load character from the string
    MOV AH, 0Eh          ; BIOS teletype output
    INT 10h              ; Print the character

    ; Print spaces if not the last character
    MOV CL, BL
PRINT_SPACES:
    CMP CL, 0
    JE PRINT_NEXT_CHAR
    MOV AH, 0Eh
    MOV AL, ' '          ; Space character
    INT 10h
    DEC CL
    JMP PRINT_SPACES

PRINT_NEXT_CHAR:
    INC DI               ; Move to the next character
    CMP DI, 3            ; Check if we reached the end of the string
    JE END_PRINT_STRING

    ; Print a space between characters
    MOV AH, 0Eh
    MOV AL, ' '          ; Space character
    INT 10h
    JMP PRINT_STRING_WITH_SPACES

END_PRINT_STRING:
    ; Move cursor left after printing each line
    CALL MOV_CURSOR_POS
    DEC DL

    ; Increment the space counter
    INC SI

    ; Check if we need to print more lines
    CMP SI, 4            ; Print 4 lines (0 to 3 spaces)
    JL PRINT_LINES

    JMP EXIT





;ADD_IN_BETWEEN:
;    MOV DL, 39
;     
;    DISPLAY1:
;        MOV CX, SPACES    
;        CALL MOV_CURSOR_POS
;    
;        MOV SI, 2          
;        MOV BL, INPUT[1]
;  
;         
;    PRINT_STRING1:
;        CMP BL, 0
;        JE END_OF_LINE 
;
;        MOV AL, INPUT[SI]
;        MOV AH, 0EH
;        INT 10H
;        
;        DEC BL
;        
;        CMP BL, 0
;        JE END_OF_LINE
;         
;        ADD_WHITE_SPACE:
;            MOV AL, ' '
;            MOV AH, 0EH
;            INT 10H
;            DEC CX
;            CMP CX, 0
;            JNZ ADD_WHITE_SPACE     
;    
;        INC SI
;        INC CX
;        JMP PRINT_STRING1  
;    
;    END_OF_LINE:
;        DEC DL
;        INC SPACES       
;        JMP DISPLAY1
;        
;    JMP EXIT
; 
 
 
 
 
 
 
 
MOV_CURSOR_POS:
    SUB DL, INPUT[1]
    ADD DL, 1
    MOV AH, 2
    INT 10H
    RET

SET_CURSOR_POS:
    MOV DL, 40
    SUB DL, INPUT[1]
    ADD DL, 1
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
SPACE DB ' $'
SPACES DW 1
