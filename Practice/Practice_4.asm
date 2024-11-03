;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Wed Oct 9 2024
; Processor: 8086
; Compiler:  MASM32
;
; Before starting simulation set Internal Memory Size 
; in the 8086 model properties to 0x10000
;====================================================================

PROCED1 SEGMENT 'CODE'
ISR1 PROC FAR
ASSUME CS:PROCED1, DS:DATA
ORG 01000H ; write code within below starting at address 08000H
   PUSHF ; push 16-bit operands
   PUSH AX ; save program context
   PUSH DX
   
   ;<write the ISR code here>
   MOV DX, PIC2
   MOV AL, 0BFH
   OUT DX, AL
   STI
   
   CALL FAR PTR TESTING
   ; end of ISR code
   
   POP DX ; retrieve program context
   POP AX
   POPF ; pop 16-bit operands
   IRET ; return from interrupt
ISR1 ENDP ; end of procedure
PROCED1 ENDS

PROCED2 SEGMENT 'CODE'
ISR2 PROC FAR
ASSUME CS:PROCED2, DS:DATA
ORG 02000H ; write code within below starting at address 09000H
   PUSHF ; push 16-bit operands
   PUSH AX ; save program context
   PUSH DX
   
   ;<write the ISR code here>
   CALL FAR PTR EMERGENCY
   ; end of ISR code

   POP DX ; retrieve program context
   POP AX
   POPF ; pop 16-bit operands
   IRET ; return from interrupt
ISR2 ENDP ; end of procedure
PROCED2 ENDS

DATA SEGMENT
ORG 03000H
   PORTA EQU 0F0H	; 8255 PPI 1
   PORTB EQU 0F2H
   PORTC EQU 0F4H
   COM_REG1 EQU 0F6H
   
   PORTD EQU 0F8H	; 8255 PPI 2
   PORTE EQU 0FAH
   PORTF EQU 0FCH
   COM_REG2 EQU 0FEH
   
   PORT_T EQU 0E8H	; 8253 Timer
   COM_REGT EQU 0EEH
   
   PIC1 EQU 0E0H	; 8259 PIC
   PIC2 EQU 0E2H
   ICW1 EQU 013H
   ICW2 EQU 080H
   ICW4 EQU 003H
   OCW1 EQU 0EFH
   ;1110 1111 = EF
   ;1011 1111 = BF
   
   MENU1 DB "[1] Coke Large","$"
   MENU2 DB "[2] Coke Medium","$"
   MENU3 DB "[3] Sprite Large","$"
   MENU4 DB "[4] Sprite Medium  ","$"
   MSG1 DB "Dispensing...","$"
   MSG2 DB "  S  ","$"
   MSG3 DB "Enjoy your drink!","$"
   MSG4 DB "Testing valves...","$"
   MSG5 DB "Emergency Stop!","$"
DATA ENDS

STK SEGMENT STACK
   BOS DW 64d DUP (?)
   TOS LABEL WORD
STK ENDS

CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE, DS:DATA, SS:STK
	
	ORG 04000H

START:
   MOV AX, DATA
   MOV DS, AX ; set the Data Segment address
   MOV AX, STK
   MOV SS, AX ; set the Stack Segment address
   LEA SP, TOS ; set address of SP as top of stack
   CLI ; clears IF flag 
   
   MOV DX, COM_REG1	; Configuring 8255 PPI 1
   MOV AL, 10001001B
   OUT DX, AL
   
   MOV DX, COM_REG2	; Configuring 8255 PPI 2 
   MOV AL, 10000010B
   OUT DX, AL
   
   ;program the 8259
   MOV DX, PIC1 ; set I/O address to access ICW1
   MOV AL, ICW1
   OUT DX, AL ; send command word
   MOV DX, PIC2 ; set I/O address to access ICW2,ICW4
   MOV AL, ICW2
   OUT DX, AL ; send command word
   MOV AL, ICW4
   OUT DX, AL ; send command word
   STI ; enable INTR pin of 8086
   
   MOV DX, COM_REGT	; Configuring 8253 Timer
   MOV AL, 00111000B
   OUT DX, AL
   
   ;storing interrupt vector to interrupt vector table in memory
   MOV AX, OFFSET ISR1 ; get offset address of ISR1 (IP)
   MOV [ES:210H], AX ; store offset address to memory at 210H
   MOV AX, SEG ISR1 ; get segment address of ISR1 (CS)
   MOV [ES:212H], AX ; store segment address to memory at 212H
   
   MOV AX, OFFSET ISR2 ; get offset address of ISR2 (IP)
   MOV [ES:218H], AX ; store offset address to memory at 218H
   MOV AX, SEG ISR2 ; get segment address of ISR2 (CS)
   MOV [ES:21AH], AX ; store segment address to memory at 21AH
   
   ;foreground routine
   HERE:
   MOV DX, PIC2
   MOV AL, OCW1
   OUT DX, AL
   STI
   
   CALL INIT_LCD
   CALL SHOW_MENU
   CALL CHECK_DAVBL
   
   JMP ENDLESS
   
   ; MODULE: Show menu options
   SHOW_MENU:
      MOV AL, 080H	; set cursor location
      CALL INST_CTRL	; send instruction to LCD
      LEA SI, MENU1	; load string
      CALL DISPLAY_STR	; display string
      XOR AX, AX
      
      MOV AL, 0C0H
      CALL INST_CTRL
      LEA SI, MENU2
      CALL DISPLAY_STR
      XOR AX, AX
      
      MOV AL, 094H
      CALL INST_CTRL
      LEA SI, MENU3
      CALL DISPLAY_STR
      XOR AX, AX
      
      MOV AL, 0D4H
      CALL INST_CTRL
      LEA SI, MENU4
      CALL DISPLAY_STR
      XOR AX, AX
   RET
   
   ; MODULE: Check DAVBL
   CHECK_DAVBL:
      MOV DX, PORTC ; set port of DAVBL(PORTC)
      IN AL, DX ; read PORTC
      TEST AL, 10H ; check if DAVBL is high
      JZ CHECK_DAVBL ; if low then check again
      IN AL, DX ; read 4-bit keypad data
      AND AL, 0FH ; mask upper nibble
      CMP AL, 00H ; check if key pressed is 1 (00H)
      JE COKE_L ; display Coke Large
      CMP AL, 01H ; check if key pressed is 2 (01H)
      JE COKE_M ; display Coke Medium
      CMP AL, 02H ; check if key pressed is 3 (02H)
      JE SPRITE_L ; display Sprite Large
      CMP AL, 04H ; check if key pressed is 4 (04H)
      JE SPRITE_M ; display Sprite Medium
      CALL DELAY_1MS
      JMP CHECK_DAVBL
      
   ; MODULES: Each menu option
   COKE_L: 
      CALL DISPENSING	; display "Dispensing..."
      MOV CX, 07H	; set timer to 7 seconds
      MOV DX, PORTD
      MOV AL, 0001B	; set target LED output
      CALL LED_CTRL	; send instruction to LED
      CALL ENJOY
      JMP HERE
   COKE_M: 
      CALL DISPENSING
      MOV CX, 04H
      MOV DX, PORTD
      MOV AL, 0010B
      CALL LED_CTRL
      CALL ENJOY
      JMP HERE
   SPRITE_L: 
      CALL DISPENSING
      MOV CX, 07H
      MOV DX, PORTD
      MOV AL, 0100B
      CALL LED_CTRL
      CALL ENJOY
      JMP HERE
   SPRITE_M: 
      CALL DISPENSING
      MOV CX, 04H
      MOV DX, PORTD
      MOV AL, 1000B
      CALL LED_CTRL
      CALL ENJOY
      JMP HERE
      
   ; MODULE: Endless loop
   ENDLESS:
   JMP ENDLESS
      
   INST_CTRL:
      PUSH AX ; preserve value of AL
      MOV DX, PORTA ; set port of LCD data bus ()
      OUT DX, AL ; write data in AL to 
      MOV DX, PORTB ; set port of LCD control lines (PORTB)
      MOV AL, 02H ; E=1, RS=0 (access instruction reg)
      OUT DX, AL ; write data in AL to PORTB
      CALL DELAY_1MS ; delay for 1 ms
      MOV DX, PORTB ; set port of LCD control lines (PORTB)
      MOV AL, 00H ; E=0, RS=0
      OUT DX, AL ; write data in AL to PORTB
      POP AX ; restore value of AL
   RET

   DATA_CTRL:
      PUSH AX ; preserve value of AL
      MOV DX, PORTA ; set port of LCD data bus ()
      OUT DX, AL ; write data in AL to 
      MOV DX, PORTB ; set port of LCD control lines (PORTB)
      MOV AL, 03H ; E=1, RS=1 (access data register)
      OUT DX, AL ; write data in AL to PORTB
      CALL DELAY_1MS ; delay for 1 ms
      MOV DX, PORTB ; set port of LCD control lines (PORTB)
      MOV AL, 01H ; E=0, RS=1
      OUT DX, AL ; write data in AL to PORTB
      POP AX ; restore value of AL
   RET

   INIT_LCD:
      MOV AL, 38H ; 8-bit interface, dual-line display
      CALL INST_CTRL ; write instruction to LCD
      MOV AL, 08H ; display off, cursor off, blink off
      CALL INST_CTRL ; write instruction to LCD
      MOV AL, 01H ; clear display
      CALL INST_CTRL ; write instruction to LCD
      MOV AL, 06H ; increment cursor, display shift off
      CALL INST_CTRL ; write instruction to LCD
      MOV AL, 0CH ; display on, cursor off, blink off
      CALL INST_CTRL ; write instruction to LCD
   RET
   
   ; MODULE: LED Control
   LED_CTRL:
      OUT DX, AL
      
      CMP BL, 01H
      JE RESUME
      
      CMP CX, 07H
      JE D7
      CMP CX, 06H
      JE D6
      CMP CX, 05H
      JE D5
      CMP CX, 04H
      JE D4
      CMP CX, 03H
      JE D3
      CMP CX, 02H
      JE D2
      CMP CX, 01H
      JE D1
      
      RESUME:
	 CALL DELAY_1S
	 DEC CX
	 CMP CX, 00H
	 JNZ LED_CTRL
   RET
   
   ; MODULE: Display "Enjoy your drink!"
   ENJOY:
      MOV DX, PORTD
      MOV AL, 00H
      OUT DX, AL
   
      CALL INIT_LCD
      MOV AL, 0C2H
      CALL INST_CTRL
      LEA SI, MSG3
      CALL DISPLAY_STR
      CALL DELAY_1S
   RET
   
   ; MODULE: Display "Testing valves..."
   TESTING:
      CALL INIT_LCD
      MOV AL, 0C2H
      CALL INST_CTRL
      LEA SI, MSG4
      CALL DISPLAY_STR
      XOR CX, CX
      
      MOV BL, 01H
      MOV CX, 01H
      MOV DX, PORTD
      MOV AL, 0001B
      CALL LED_CTRL
      
      MOV CX, 01H
      MOV DX, PORTD
      MOV AL, 0010B
      CALL LED_CTRL
      
      MOV CX, 01H
      MOV DX, PORTD
      MOV AL, 0100B
      CALL LED_CTRL
      
      MOV CX, 01H
      MOV DX, PORTD
      MOV AL, 1000B
      CALL LED_CTRL
      
      MOV DX, PORTD
      MOV AL, 00H
      OUT DX, AL
      
      XOR BX, BX
      XOR CX, CX
      JMP HERE
   
   ; MODULE: Display "Emergency Stop!"
   EMERGENCY:
      CALL INIT_LCD
      MOV AL, 0C2H
      CALL INST_CTRL
      LEA SI, MSG5
      CALL DISPLAY_STR
      XOR CX, CX
      
      MOV BL, 01H
      MOV CX, 02H
      MOV DX, PORTD
      MOV AL, 00H
      CALL LED_CTRL

      XOR BX, BX
      XOR CX, CX
      JMP HERE
   
   ; MODULE: Dispensing
   DISPENSING:
      MOV DX, PIC2
      MOV AL, 0BFH
      OUT DX, AL
      STI
   
      CALL INIT_LCD
      MOV AL, 0C4H
      CALL INST_CTRL
      LEA SI, MSG1
      CALL DISPLAY_STR
      MOV AL, 09EH
      CALL INST_CTRL
      LEA SI, MSG2
      CALL DISPLAY_STR
      XOR CX, CX
   RET
   
   ; MODULE: Display string to LCD
   DISPLAY_STR:
      MOV AL, [SI] 
      CMP AL, '$'
      JE EXIT
      CALL DATA_CTRL
      INC SI
      JMP DISPLAY_STR
      
   EXIT:
   RET
   
   ; MODULES: Display the number of seconds
   D1: 
      MOV AL, 09EH 	; set cursor location
      CALL INST_CTRL	; send instruction to LCD
      MOV AL, '1' ; display ‘1‘
      JMP CONT
   D2: 
      MOV AL, 09EH 	; set cursor location
      CALL INST_CTRL	; send instruction to LCD
      MOV AL, '2' ; display ‘2‘
      JMP CONT
   D3: 
      MOV AL, 09EH 	; set cursor location
      CALL INST_CTRL	; send instruction to LCD
      MOV AL, '3' ; display ‘3‘
      JMP CONT
   D4: 
      MOV AL, 09EH 	; set cursor location
      CALL INST_CTRL	; send instruction to LCD
      MOV AL, '4' ; display ‘4‘
      JMP CONT
   D5: 
      MOV AL, 09EH 	; set cursor location
      CALL INST_CTRL	; send instruction to LCD
      MOV AL, '5' ; display ‘5‘
      JMP CONT
   D6: 
      MOV AL, 09EH 	; set cursor location
      CALL INST_CTRL	; send instruction to LCD
      MOV AL, '6' ; display ‘6‘
      JMP CONT
   D7: 
      MOV AL, 09EH 	; set cursor location
      CALL INST_CTRL	; send instruction to LCD
      MOV AL, '7' ; display ‘7‘
      JMP CONT
      
   CONT:
      CALL DATA_CTRL
      CALL DELAY_1MS
      JMP RESUME
      
   ; MODULE: Dispensing timer
   DELAY_1S:
      MOV DX, PORT_T	; access 8253 timer
      MOV AL, 0A0H
      OUT DX, AL
      MOV AL, 0FH
      OUT DX, AL

      LOCK_INPUT:
	 MOV DX, PORTE
	 IN AX, DX
	 XOR AH, AH
	 AND AL, 01H
	 CMP AL, 00H	; checks if remaining time is 0
	 JNE LOCK_INPUT
   RET

   DELAY_1MS:
      MOV BX, 02CAH
   L1:
      DEC BX
      NOP
      JNZ L1
      RET
   RET
   
   CALL FAR PTR EMERGENCY
CODE ENDS 
END START