
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

    MOV AL, 25
    MOV AX, 2345
    MOV BX, AX
    MOV CL, AL
    MOV AL, DATA1
    
    MOV AX, DATA2
    
    MOV DATA3, AL
    
    MOV DATA4, AX
    
    MOV BX, OFFSET DATA5
    
    MOV AX, [BX]
    
    MOV DI, 02H
    MOV AX, [BX+DI]
    
    MOV AX, [BX+0002H]
    MOV AL, [DI+2]
    MOV AX, [BX+DI+0002H]
    
    INT 20H

ret

DATA1 DB 25H
DATA2 DW 1234H
DATA3 DB 0H
DATA4 DW 0H
DATA5 DW 2345H, 6789H

