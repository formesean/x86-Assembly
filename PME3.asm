
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    CALL GET_INPUT    
    CALL NEW_LINE
    CALL INIT
    CALL CHECK
    
    CONT2:
    CALL INIT
    
    CALL TO_BINARY    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

    JMP EXIT
ret

GET_INPUT:    
    MOV AH, 1
    INT 21H
    MOV NUM1, AL
    INT 21H
    MOV NUM2, AL

    RET

CHECK:
    CMP NUM1, 'A'
    JE CONVERTA1
    CMP NUM1, 'B'
    JE CONVERTB1
    CMP NUM1, 'C'
    JE CONVERTC1 
    CMP NUM1, 'D'
    JE CONVERTD1 
    CMP NUM1, 'E'
    JE CONVERTE1
    CMP NUM1, 'F'
    JE CONVERTF1
    
    CONT1: 
    CMP NUM2, 'A'
    JE CONVERTA2
    CMP NUM2, 'B'
    JE CONVERTB2
    CMP NUM2, 'C'
    JE CONVERTC2 
    CMP NUM2, 'D'
    JE CONVERTD2 
    CMP NUM2, 'E'
    JE CONVERTE2
    CMP NUM2, 'F'
    JE CONVERTF2
    RET   

CONVERTA1:
    MOV NUM1, 10
    JMP CONT1
        
CONVERTB1:
    MOV NUM1, 11
    JMP CONT1    
    
CONVERTC1:
    MOV NUM1, 12
    JMP CONT1

CONVERTD1:
    MOV NUM1, 13
    JMP CONT1

CONVERTE1:
    MOV NUM1, 14
    JMP CONT1

CONVERTF1:
    MOV NUM1, 15
    JMP CONT1

CONVERTA2:
    MOV NUM2, 10
    JMP CONT2

CONVERTB2:
    MOV NUM2, 11
    JMP CONT2    
    
CONVERTC2:
    MOV NUM2, 12
    JMP CONT2

CONVERTD2:
    MOV NUM2, 13
    JMP CONT2

CONVERTE2:
    MOV NUM2, 14
    JMP CONT2

CONVERTF2:
    MOV NUM2, 15
    JMP CONT2

INIT:
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    RET

TO_BINARY:
    MOV AL, NUM1
    SUB AL, '0'
    MOV BL, 2
    
    DIVIDE:
        DIV BL
        MOV DL, AH
        XOR AH, AH
        PUSH DX
        INC CX
        CMP CX, 4
        JNE DIVIDE
        
    XOR CX, CX
        
    DISPLAY:
        POP DX
        ADD DX, '0'
        CALL DISPLAY_CHAR
        INC CX
        CMP CX, 4
        JNE DISPLAY
    
    MOV DL, ' '
    CALL DISPLAY_CHAR
    CALL CHECK
        
    CALL INIT
        
    MOV AL, NUM2
    SUB AL, '0'
    MOV BL, 2
    
    DIVIDE2:
        DIV BL
        MOV DL, AH
        XOR AH, AH
        PUSH DX
        INC CX
        CMP CX, 4
        JNE DIVIDE2
        
    XOR CX, CX
        
    DISPLAY2:
        POP DX
        ADD DX, '0'
        CALL DISPLAY_CHAR
        INC CX
        CMP CX, 4
        JNE DISPLAY2
        
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

MSG1 DB 'Input hexadecimal value: $' 
MSG2 DB ' in binary$'
MSG3 DB ' in octal$'
NUM DB 10, ?, 10 DUP(?)
NUM1 DB ?
NUM2 DB ?



