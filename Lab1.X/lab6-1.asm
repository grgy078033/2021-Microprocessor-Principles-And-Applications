LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
	
	L1 EQU 0X14
	L2 EQU 0X15
 
	ORG 0x0

DELAY macro num1, num2
    local loop1
    local loop2
    MOVLW num2
    MOVLW L2
    LOOP2:
	MOVLW num1
	MOVWF L2
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
    CLRF TRISA
    CLRF TRISD
init:
    MOVLW 0x0F ; configure A/D
    MOVWF ADCON1 ; set digital I/O
    CLRF PORTA ; clear PORTA
    BSF TRISA, 3 ; set RA4 as input, TRISA = 0000 1000
    CLRF LATD ; clear LATD
    BCF TRISD, 0 ; set RD0 as output, TRISD = 0000 0000
    BCF TRISD, 1 ; set RD1 as output, TRISD = 0000 0000
    BCF TRISD, 2 ; set RD2 as output, TRISD = 0000 0000
    BCF TRISD, 3 ; set RD3 as output, TRISD = 0000 0000
    BSF LATD, 1 ; let RD1 be light first
    BSF LATD, 3 ; let RD3 be light first
check_press:
    BTFSC PORTA, 3
    BRA check_press
    BRA light_up
light_up:
    BTG LATD, 0
    BTG LATD, 1
    BTG LATD, 2
    BTG LATD, 3
    DELAY d'200', d'180'
    BRA check_press
end