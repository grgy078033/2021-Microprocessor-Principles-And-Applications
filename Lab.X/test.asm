LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	CONFIG LVP = OFF
	org 0x00
	
	L1 EQU 0X14
	L2 EQU 0X15
 
	ORG 0x0

DELAY macro num1, num2
    local LOOP1
    local LOOP2
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1
	MOVWF L1
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1,1
	BRA LOOP1
	DECFSZ L2,1
	BRA LOOP2
endm
	
start:
init:
    MOVLW 0x0f ; configure A/D
    MOVWF ADCON1 ; set digital I/O
    CLRF PORTA ; clear PORTA
    BSF TRISA, 4 ; set RA4 as input, TRISB = 0001 0000
    CLRF LATD ; clear LATD
    BCF TRISD, 0 ; set RD0 as output, TRISA = 0000 0000
    BTG LATD, 0
    BCF TRISD, 1 ; set RD1 as output, TRISA = 0000 0000
    
check_press:
    BTFSC PORTA, 4
    BRA check_press
    BRA light_up
    
light_up:
    BTG LATD, 0
    BTG LATD, 1
    DELAY d'200', d'180'
    BRA check_press
end


