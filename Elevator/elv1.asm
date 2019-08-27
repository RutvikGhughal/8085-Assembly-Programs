cpu "8085.tbl"
hof "int8"

org 9000h

GTHEX: EQU 030EH    ;Gets hex digits and stores them in DE register pair

MVI A,8BH 			;Sets the mode to mode 0 - Port A is output, Port B is input
OUT 43H
;INITIAL FLOOR

CALL GTHEX
MOV A,E 			; Get level of boss from keyboard
STA 8800H 			; Store boss level in 8800H

GROUND:

MVI A,01H 			; Initial elevator in binary 00000001
OUT 40H 			; Display elevator position on LCI

MVI A,00H 			; current level 0 stored in 8000H
STA 8000H

LDA 8800H 			; To get the floor boss is on and store in accumulator
MOV B,A 			; Store Boss level in register B
LDA 8800H 			; To get the floor boss is on and store in accumulator
IN 41H 				; Get the current Floor button structure from input port B of LCI
ANA B 				; Compare to check if boss floor is HIGH
JNZ BOSS 			; Special(priority) routine for Boss

IN 41H 				; Again get the current floor structure from input port B of LCI 
MOV B,A 			; Store it in register B
MVI C,01H 			; Acts as an iterator that goes to each floor
MVI D,08H 			; Points to the highest floor first and then comes down till highest occupied floor is found

LOOP:
DCR D 				; Go one floor down
MOV A,D 			; Store the current floor in accumulator to check if it is not the ground floor
CPI 00H 			; Compare with 00H to check if it is ground floor
JZ GROUND 			; If ground go to GROUND label

MOV A,C 			; Get the iterator(binary) to get the highest occupied lift position
RRC 				; Make the elevator go one unit down				
MOV C,A 			; Store the iterator back
MOV A,B 			; Get the current floor structure that we got from port  of LCI
ANA C 				; Check if floor shown by iterator C is switched to HIGH on port B
JZ LOOP

MOV A,C
STA 8001H			; 8001 STORES HIGHEST FLOOR (POW(2,FLOOR))

MOV A,D 
STA 8000H 			; 8000 STORES HIGHEST FLOOR

;MOVE UP
MVI A,01H 			; Store initial lift position to 8001H via the accumulator
STA 8001H

INR D 				; Increase the maximum occupied floor by 1- for initialiazion

UP:
LDA 8001H 			; Get the current lift position from 8001H
OUT 40H 			; Display the curent lift position
RLC  				; Move the Lift up
STA 8001H 			; Store the updated lift position back to 8001H
CALL DELAY 			; Wait for a second
DCR D 				; Use the maximum occupied floor as counter
JNZ UP

LDA 8001H 			; Get the current lift position from 8001H
RRC 				; Go one floor down
STA 8001H 			; Store the update lift location

DOWN:

LDA 8001H  			; Get the current lift position from 8001H
OUT 40H				; Display the current lift position on port A of LCI


MOV B,A 			; Store the current lift position in register B
CALL DELAY

IN 41H 				; Get the current floor structure from port B of input of LCI
ANA B 				; To check if current floor position is on HIGH state 
JZ L2 				; If not HIGH goto L2
CALL DELAY 			; If HIGH, i.e button is pressed - wait 3 seconds
CALL DELAY
CALL DELAY
L2:

LDA 8001H  			; Get the current lift position from 8001H
RRC					; Make the lift go one floor down
STA 8001H 			; Store back the updated lift position

LDA 8000H 			; Get the highest floor (to use as an iterator)
DCR A 				; Decrease the iterator
STA 8000H 			; Store it back to 8000H

CPI 00H 			; Check if iterator is 00H - reached ground
JNZ DOWN 			; If ground floor not reached goto DOWN label
MVI A,01H 			; If reached ground ground floor show the elevator on ground floor
OUT 40H
CALL DELAY 			; Wait for 3 seconds on the ground floor
CALL DELAY
CALL DELAY

JMP GROUND

DELAY:        ;Delay function to delay machine by 1 second
MVI C,03H
OUTLOOP:
LXI H,0A604H
INLOOP:       ;reapeatedly run inloop as many times as
DCX H       ;frequency of microprocessor
MOV A,H
ORA L
JNZ INLOOP
DCR C
JNZ OUTLOOP
RET

RST 5

; The whole code below works to give priority access to the boss floor
; The working is similar to normal execution except the lift goes directly to boss floor
; Then the lift goes back to the ground floor
BOSS:
LDA 8800H
MOV D, A
MOV A, 01H
STA 8001H

BUP:
LDA 8001H
OUT 40H
RLC 
STA 8001H
CALL DELAY
MOV A, D
RRC
MOV D, A
CPI 01H
JZ BDOW
JMP BUP

CALL DELAY
CALL DELAY
CALL DELAY

BDOW:
OUT 40H
LDA 8001H
OUT 40H
MOV B,A
CPI 01H
JZ BDON
CALL DELAY

LDA 8001H
RRC
STA 8001H

LDA 8000H
DCR A
STA 8000H

JMP BDOW

BDON:
MVI A,01H
STA 8001H
OUT 40H
CALL DELAY
CALL DELAY
CALL DELAY

JMP GROUND