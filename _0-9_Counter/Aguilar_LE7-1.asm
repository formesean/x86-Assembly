;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Wed Oct 30 2024
; Processor: 8086
; Compiler:  MASM32
;
; Before starting simulation set Internal Memory Size 
; in the 8086 model properties to 0xF0000
;====================================================================

PROCED1 SEGMENT 'CODE'
ISR1 PROC FAR
ASSUME CS:PROCED1, DS:DATA
ORG 01000H ; write code within below starting at address 08000H
   PUSHF ; push 16-bit operands
   PUSH AX ; save program context
   PUSH DX
   ;<write the ISR code here>
   MOV DX, PORTA
   MOV AL, 09H
   OUT DX, AL
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
   MOV DX, PORTA
   MOV AL, 00H
   OUT DX, AL
   ; end of ISR code
   POP DX ; retrieve program context
   POP AX
   POPF ; pop 16-bit operands
   IRET ; return from interrupt
ISR2 ENDP ; end of procedure
PROCED2 ENDS

DATA SEGMENT
ORG 03000H
   PORTA EQU 0F0H
   PORTB EQU 0F2H
   PORTC EQU 0F4H
   COM_REG EQU 0F6H
   PIC1 EQU 0F8H
   PIC2 EQU 0FAH
   ICW1 EQU 013H
   ICW2 EQU 080H
   ICW4 EQU 003H
   OCW1 EQU 0FCH
DATA ENDS

STK SEGMENT STACK
   BOS DW 64d DUP (?)
   TOS LABEL WORD
STK ENDS

CODE    SEGMENT PUBLIC 'CODE'
        ASSUME CS:CODE, DS:DATA, SS:STK
	
	ORG 08000H

START:
   MOV AX, DATA
   MOV DS, AX ; set the Data Segment address
   MOV AX, STK
   MOV SS, AX ; set the Stack Segment address
   LEA SP, TOS ; set address of SP as top of stack
   CLI ; clears IF flag 
   
   ;program the 8255
   MOV DX, COM_REG
   MOV AL, 10000001B
   OUT DX, AL

   ;program the 8259
   MOV DX, PIC1 ; set I/O address to access ICW1
   MOV AL, ICW1
   OUT DX, AL ; send command word
   MOV DX, PIC2 ; set I/O address to access ICW2,ICW4 and OCW1
   MOV AL, ICW2
   OUT DX, AL ; send command word
   MOV AL, ICW4
   OUT DX, AL ; send command word
   MOV AL, OCW1
   OUT DX, AL ; send command word
   STI ; enable INTR pin of 8086
   
   ;storing interrupt vector to interrupt vector table in memory
   MOV AX, OFFSET ISR1 ; get offset address of ISR1 (IP)
   MOV [ES:200H], AX ; store offset address to memory at 200H
   MOV AX, SEG ISR1 ; get segment address of ISR1 (CS)
   MOV [ES:202H], AX ; store segment address to memory at 202H
   
   MOV AX, OFFSET ISR2 ; get offset address of ISR2 (IP)
   MOV [ES:204H], AX ; store offset address to memory at 204H
   MOV AX, SEG ISR2 ; get segment address of ISR2 (CS)
   MOV [ES:206H], AX ; store segment address to memory at 206H

   ;foreground routine
   HERE:
      MOV DX, PORTC
      IN AL, DX
      AND AL, 0FH
      
      CMP AL, 09H
      JLE DISPLAY
      MOV AL, 00H
      JMP HERE
      
   DISPLAY:
      MOV DX, PORTB
      MOV AH, 00H
      OUT DX, AL	
      JMP HERE
   
CODE ENDS
END START
