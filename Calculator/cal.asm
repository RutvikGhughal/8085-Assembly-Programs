cpu "8085.tbl"
hof "int8"

org 8000h

LDA 9050H
CPI 01H
JZ ADD8
CPI 10H
JZ ADD16
CPI 02H
JZ SUB8
CPI 20H
JZ SUB16
CPI 03H
JZ MUL8
CPI 30H
JZ MUL16
CPI 04H
JZ DIV8
CPI 40H
JZ DIV16

ADD8:	
	LDA 9051H
	MOV B, A
	LDA 9052H
	ADD B 
	STA 9080H
	JMP L10

ADD16: LDA 9051H
	MOV B, A
	LDA 9053H
	ADD B 
	STA 9080H
	LDA 9052H
	MOV B, A 
	LDA 9054H
	ADC B 
	STA 9081H
	JMP L10

SUB8:	
	LDA 9051H
	MOV B, A
	LDA 9052H
	SUB B 
	STA 9080H
	JMP L10

SUB16:
	LHLD 9051H
	XCHG
	LHLD 9053H
	MOV A, E
	SUB L
	STA 9080H
	MOV A, D
	SBB H
	STA 9081H
	JMP L10

MUL8:
		LDA 9051H
	    MOV B,A    
	    LDA 9052H
	    MOV D,A
	    MVI A,00H
	MULLABEL: ADD B
	    DCR D
	    JNZ MULLABEL
	    STA 9080H
	    JMP L10

MUL16:
		LHLD 9051H
		SPHL
		LHLD 9053H 
		XCHG
		LXI H, 0000H
		LXI B, 0000H
		DIVL16: DAD SP
		JNC DIVD16
		INX B
		DIVD16: DCX D
		MOV A, E
		ORA D
		JNZ DIVL16
		SHLD 9080H
		MOV L, C
		MOV H, B
		SHLD 9081H
	JMP L10

DIV8:	
	LXI H, 9051H
	JMP L10
	MOV B, M
	MVI C, 00
	INX H
	MOV A, M
	L4: CMP B
	JC L3
	SUB B
	INR C
	JMP L4
	L3: STA 9080
	MOV A, C
	STA 9081
	JMP L10

DIV16:
	LXI B, 0000H
	LHLD 9053H
	XCHG
	LHLD 9051H
	L2: MOV A, L
	SUB E
	MOV L, A
	MOV A, H
	SBB D
	MOV H, A
	JC L1
	INX B
	JMP L2
	L1: DAD D
	SHLD 9082H
	MOV L, C
	MOV H, B
	SHLD 9080H
	JMP L10

L10: RST 5