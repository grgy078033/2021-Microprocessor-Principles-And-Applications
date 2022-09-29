LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
	
	L1 EQU 0X14
	L2 EQU 0X15
 

DELAY macro num1, num2 ; DELAY d'200', d'180'
    local LOOP1 ; innerloop, use local to prevent compiler error
    local LOOP2 ; outerloop
    MOVLW num2 ; 1 cycle
    MOVWF L2 ; L2 = 180
    LOOP2:
	MOVLW num1 ; 1 cycle
	MOVWF L1 ; L1 = 200
    LOOP1:
	NOP ; 1 cycle
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1,1 ; 1 cycle
	BRA LOOP1 ; 1 cycle
	DECFSZ L2,1
	BRA LOOP2
endm ; 2+(2+7*200+2)*180 = 252360
	
start:
init:
    MOVLW 0x0F ; configure A/D
    MOVWF ADCON1 ; set digital I/O
    CLRF PORTA ; clear PORTA
    BSF TRISA, 4 ; set RA4 as input, TRISA = 0001 0000
    CLRF LATD ; clear LATD
    BCF TRISD, 0 ; set RD0 as output, TRISD = 0000 0000
    BCF TRISD, 1 ; set RD1 as output, TRISD = 0000 0000
    BCF TRISD, 2 ; set RD2 as output, TRISD = 0000 0000
    BCF TRISD, 3 ; set RD3 as output, TRISD = 0000 0000
    BSF LATD, 1 ; let RD1 light first, LATD = 0000 0010
    BSF LATD, 3 ; let RD3 light first, LATD = 0000 1010
check_press:
    BTFSC PORTA, 4 ; check button press
    BRA check_press ; button not press, goto check_press
    BRA light_up ; if button press, goto light_up
light_up:
    BTG LATD, 0 ; LATD = 0000 1011
    BTG LATD, 1 ; LATD = 0000 1001
    BTG LATD, 2 ; LATD = 0000 1101
    BTG LATD, 3 ; LATD = 0000 0101
    DELAY d'200', d'180' ; delay for preventing bouncing problem
    BRA check_press ; go back to check button presss
end


