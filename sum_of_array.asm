
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
    MOV AX, 0B800H
    MOV ES, AX                   ; STORE TO DATA SEGMENT
    MOV DI, 0
    MOV CX, 76                   ; LENGHT OF THE SCREEN
    
    LEA SI, NUMS
    MOV CX, 5
    
    .ADDITION:
        ADD BX, [SI]
        INC SI        
        MOV BH, 00H
    LOOP .ADDITION
    
    LEA SI, WORD
    MOV CX, 11        
     
    .DISPLAY_WORD: 
        MOV DL, [SI]
        MOV DH, 00001011B   
        MOV ES:[DI], DX
        INC SI
        INC DI
        INC DI
    LOOP .DISPLAY_WORD
    
    ADD BX, 90H
    LEA SI, BX
    MOV CX, 2

    .DISPLAY_SUM: 
        MOV DL, [SI]
        MOV DH, 00001011B   
        MOV ES:[DI], DX
        INC SI
        INC DI
        INC DI
    LOOP .DISPLAY_SUM

ret
  
WORD DB 'THE SUM OF '
NUMS DB 1, 2, 3, 4, 5

;    START:  MOV AX, DATA                   
;            MOV DS, AX 
;             
;            XOR AX, AX                     ;clearing AX
;            XOR DX, DX                     ;clearing DX
;            MOV SI, 0                      ;clearing SI  
;            
;            MOV CX, 10                     ;updating CX with size of the array
;            
; ADDITION:  ADD AX,word ptr ARRAY[SI]      ;adding lower word
;            ADC DX,word ptr ARRAY[SI+2]    ;adding upper word
;            ADD SI,4
;            LOOP ADDITION 
;            
;            MOV word ptr SUM, AX           ;storing the lower word in memory
;            MOV word ptr SUM + 2, DX       ;storing the upper word in memory
