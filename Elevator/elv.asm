cpu "8085.tbl"            ;      CPU Table monitor command
hof "int8"                ;      HEX Format

org 9000H  

MVI A, 8BH					;CONFIGURE 8255 IN MODE 0
OUT 43H						;PORTA O/P, PORTB I/P

MVI A, 01H 			          ;Load bit pattern to make PCο high
MOV B, A
OUT 40H                      ; Send it to control word register

CHECK:
IN 41H						; Read the input from port b of 8255
CMA
ANI 04H
CPI 04H
JZ END

IN 41H						; Read the input from port b of 8255
CMA
ANI 40H
CPI 40H
JZ BLINK

IN 41H						; Read the input from port b of 8255
CMA
ANI 20H
CPI 20H
JZ CHECK

JMP CHECK

BLINK:
BACK:
MOV A, B
OUT 40H                      ; Send it to control word register
MOV B, A
CALL DELAY                    ; Call Delay subroutine
MOV A, B
RLC 	                   ; Load bit pattern to make PCο Low
MOV B, A
JMP CHECK
JMP BACK                      ; Repeat


DELAY:                    ;      Delay Function
MVI C,04H                 ;      Move 04H value to C

OUTLOOP:                  ;      OUTLOOP Function
LXI D,7D10H               ;      Loads the value 9FFFH into DE registers

INLOOP:                   ;      INLOOP Function
DCX D                     ;      Decrement the value in DE by 1
MOV A,D                   ;      Move the value in register D to accumulator
ORA E                     ;      OR Accumulator with Register E
JNZ INLOOP                ;      If the result isn't one jump to INLOOP
DCR C                     ;      Decrement the value in Register D by 1
JNZ OUTLOOP               ;      As long as the memory of C is not 00H jump to OUTLOOP
RET                       ;      RET

END:
RST 5