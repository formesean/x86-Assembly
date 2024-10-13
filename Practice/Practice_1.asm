;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Sun Oct 6 2024
; Processor: 8086
; Compiler:  MASM32
;
; Before starting simulation set Internal Memory Size 
; in the 8086 model properties to 0x10000
;====================================================================

DATA SEGMENT
   PORTA EQU 0B0H
   PORTB EQU 0B2H
   PORTC EQU 0B4H
   COM_REG EQU 0B6H
DATA ENDS

CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE

	ORG 0000H
	
	XOR AX, AX
	XOR BX, BX
	XOR CX, CX
	XOR DX, DX
	
START:
   MOV DX, COM_REG
   MOV AL, 10001011B
   OUT DX, AL
   
   WAIT_INPUT:
      MOV DX, PORTC
      IN AL, DX
      CMP AL, 01H
      JE _ADD
      CMP AL, 02H
      JE _SUB
      CMP AL, 04H
      JE _MUL
      CMP AL, 08H
      JE _DIV
      CMP AL, 10H
      JE _DISPLAY
      CMP AL, 20H
      JE _SWAP
      CMP AL, 40H
      JE _RESET
      JMP WAIT_INPUT

   _ADD:
      MOV DX, PORTB
      IN AL, DX		; take user input (OP1 & OP2)
      
      MOV AH, AL	; duplicate and init for number place extraction
      MOV CL, 04H	; number of shifts needed (4 bits = nibble)
      SHR AL, CL	; shift right to extract OP2 or higher nibble (D7-D4)
      AND AH, 0FH	; extract OP1 or lower nibble (D3-D0)
      
      MOV BL, AH	; move OP1 to BL 
      ADD BL, AL	; add OP2 to OP1
      
      XOR AX, AX
      MOV AL, BL
      
      MOV BL, 0AH	; divide 10 to get first digit
      DIV BL
      
      SHL AL, CL	; move lower nibble to higer nibble (moving digit to tens place)
      OR AH, AL		; combine AL to AH using OR operation
      
      MOV BL, AH
      XOR AX, AX
      
      MOV AL, BL	; ready for output
      MOV DX, PORTA
      OUT DX, AL	; output
      JMP WAIT_INPUT

   _SUB:
      MOV DX, PORTB
      IN AL, DX		; take user input (OP1 & OP2)
      
      MOV AH, AL	; duplicate and init for number place extraction
      MOV CL, 04H	; number of shifts needed (4 bits = nibble)
      SHR AL, CL	; shift right to extract OP2 or higher nibble (D7-D4)
      AND AH, 0FH	; extract OP1 or lower nibble (D3-D0)
      
      MOV BL, AH	; move OP1 to BL 
      SUB BL, AL	; subtract OP2 to OP1

      JS IS_NEGATIVE1	; jump if SF is 1
      
      XOR AX, AX
      MOV AL, BL
      
      MOV BL, 0AH	; divide 10 to get first digit
      DIV BL
      
      SHL AL, CL	; move lower nibble to higer nibble (moving digit to tens place)
      OR AH, AL		; combine AL to AH using OR operation
      MOV BL, AH  
      
      DISP_DIFF:
	 XOR AX, AX 
	 MOV AL, BL	; ready for output
	 MOV DX, PORTA
	 OUT DX, AL	; output
	 JMP WAIT_INPUT
      
      IS_NEGATIVE1:
	 MOV BL, 0AAH	; hex value for the pattern
	 JMP DISP_DIFF

   _MUL:
      MOV DX, PORTB
      IN AL, DX		; take user input (OP1 & OP2)
      
      MOV AH, AL	; duplicate and init for number place extraction
      MOV CL, 04H	; number of shifts needed (4 bits = nibble)
      SHR AL, CL	; shift right to extract OP2 or higher nibble (D7-D4)
      AND AH, 0FH	; extract OP1 or lower nibble (D3-D0)
      
      MOV BL, AL	; move OP2, ready for multplying to OP1
      MOV AL, AH	; move OP1 to AL
      XOR AH, AH	; clear AH

      MUL BL		; multply OP2 to OP1
      MOV BL, AL
      
      CMP BL, 63H	; check if BL is greater than '99'
      JG IS_3HEX
      CMP BL, 00H
      JL IS_3HEX
      
      XOR AX, AX 
      MOV AL, BL
      
      MOV BL, 0AH	; divide 10 to get first digit
      DIV BL
      
      SHL AL, CL	; move lower nibble to higer nibble (moving digit to tens place)
      OR AH, AL		; combine AL to AH using OR operation
      
      MOV BL, AH
      
      DISP_PROD:
	 XOR AX, AX
	 MOV AL, BL	; ready for output
	 MOV DX, PORTA
	 OUT DX, AL	; output
	 JMP WAIT_INPUT
      
      IS_3HEX:
	 MOV BL, 0BBH	; hex value for the pattern
	 JMP DISP_PROD

   _DIV:
      MOV DX, PORTB
      IN AL, DX		; take user input (OP1 & OP2)
      
      MOV AH, AL	; duplicate and init for number place extraction
      MOV CL, 04H	; number of shifts needed (4 bits = nibble)
      SHR AL, CL	; shift right to extract OP2 or higher nibble (D7-D4)
      AND AH, 0FH	; extract OP1 or lower nibble (D3-D0)
      
      MOV BL, AL	; move OP2, ready for dividing to OP1
      MOV AL, AH	; move OP1 to AL
      XOR AH, AH	; clear AH

      DIV BL		; divide OP2 to OP1
      MOV BL, AL

      JS IS_NEGATIVE2	; jump is SF is 1
      
      XOR AX, AX 
      MOV AL, BL
      
      MOV BL, 0AH	; divide 10 to get first digit
      DIV BL
      
      SHL AL, CL	; move lower nibble to higer nibble (moving digit to tens place)
      OR AH, AL		; combine AL to AH using OR operation
      
      MOV BL, AH
      
      DISP_QUO:
	 XOR AX, AX
	 MOV AL, BL	; ready for output
	 MOV DX, PORTA
	 OUT DX, AL	; output
	 JMP WAIT_INPUT
      
      IS_NEGATIVE2:
	 MOV BL, 0AAH	; hex value for the pattern
	 JMP DISP_QUO
	 
   _DISPLAY:
   MOV DX, PORTB
      IN AL, DX		; take user input (OP1 & OP2)
      
      MOV AH, AL	; duplicate and init for number place extraction
      MOV CL, 04H	; number of shifts needed (4 bits = nibble)
      SHR AL, CL	; shift right to extract OP2 or higher nibble (D7-D4)
      AND AH, 0FH	; extract OP1 or lower nibble (D3-D0)
      
      SHL AH, CL	; move lower nibble to higer nibble (moving digit to tens place)
      OR AL, AH		; combine AH to AL using OR operation
      
      MOV BL, AL
      XOR AX, AX
      MOV AL, BL	; ready for output
      MOV DX, PORTA
      OUT DX, AL	; output
      JMP WAIT_INPUT
   
   _SWAP:
      MOV DX, PORTB
      IN AL, DX		; take user input (OP1 & OP2)
      MOV DX, PORTA
      OUT DX, AL	; output
      JMP WAIT_INPUT
   
   _RESET:
      MOV AL, 00H
      MOV DX, PORTA
      OUT DX, AL	; output
      JMP WAIT_INPUT
	 
ENDLESS:
        JMP ENDLESS
CODE    ENDS
        END START