LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	L1 EQU 0X14
	L2 EQU 0X15
	ORG 0x0

DELAY macro num1, num2 ; DELAY d'200', d'89'
    local LOOP1 ; innerloop, use local to prevent compiler error
    local LOOP2 ; outerloop
    MOVLW num2 ; 1 cycle
    MOVWF L2 ; L2 = 89
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
endm ; 2+(2+7*200+2)*89 = 124958
	
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
check_press1:
    BTFSC PORTA, 4 ; check button press
    BRA check_press1 ; button not press, goto check_press1
    BRA light_up_1 ; if button press, goto light_up_1
light_up_1:
    BTG LATD, 0 ; LATD = 0000 0001
    DELAY d'200', d'89' ; delay for 0.5s
    BTG LATD, 0 ; LATD = 0000 0000
    BRA check_press2 ; go back to check button
check_press2:
    BTFSC PORTA, 4 ; check button press
    BRA check_press2 ; button not press, goto check_press2
    BRA light_up_2 ; if button press, goto light_up_2
light_up_2:
    BTG LATD, 0 ; LATD = 0000 0001
    BTG LATD, 1 ; LATD = 0000 0011
    DELAY d'200', d'89' ; delay for 0.5s
    BTG LATD, 0 ; LATD = 0000 0010
    BTG LATD, 1 ; LATD = 0000 0000
    BRA check_press3 ; go back to check button
check_press3:
    BTFSC PORTA, 4 ; check button press
    BRA check_press3 ; button not press, goto check_press3
    BRA light_up_3 ; if button press, goto light_up_3
light_up_3:
    BTG LATD, 0 ; LATD = 0000 0001
    BTG LATD, 1 ; LATD = 0000 0011
    BTG LATD, 2 ; LATD = 0000 0111
    DELAY d'200', d'89' ; delay for 0.5s
    BTG LATD, 0 ; LATD = 0000 0110
    BTG LATD, 1 ; LATD = 0000 0100
    BTG LATD, 2 ; LATD = 0000 0000
    BRA check_press4 ; go back to check button
check_press4:
    BTFSC PORTA, 4 ; check button press
    BRA check_press4 ; button not press, goto check_press4
    BRA light_up_4 ; if button press, goto light_up_4
light_up_4:
    BTG LATD, 0 ; LATD = 0000 0001
    BTG LATD, 1 ; LATD = 0000 0011
    BTG LATD, 2 ; LATD = 0000 0111
    BTG LATD, 3 ; LATD = 0000 1111
    DELAY d'200', d'89'
    BTG LATD, 0 ; LATD = 0000 1110
    BTG LATD, 1 ; LATD = 0000 1100
    BTG LATD, 2 ; LATD = 0000 1000
    BTG LATD, 3 ; LATD = 0000 0000
    BRA check_press1 ; go back to check button
end