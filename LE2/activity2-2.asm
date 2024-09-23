
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

    MOV SI, 02H
    MOV DI, 04H
    MOV AX, 0004H
    MOV BX, [AX+SI+08H]
    MOV CX, 0000H
    MOV DX, [AX+DI+08H]    

ret
