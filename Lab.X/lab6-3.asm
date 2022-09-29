LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
	
	L1 EQU 0X14
	L2 EQU 0X15
 
	ORG 0x0

DELAY macro num1, num2 ; DELAY d'200', d'89'
    local LOOP1 ; innerloop, use local to prevent compiler error
    local LOOP2 ; outerloop
    MOVLW num2 ; 1 cycle
    MOVWF L2
    LOOP2:
	MOVLW num1 ; 1 cycle
	MOVWF L1
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
check_press:
    BTFSC PORTA, 4 ; check button press
    BRA check_press ; button not press, goto check_press
pre_state1:
    CLRF LATD ; LATD = 0000 0000
    BTG LATD, 0 ; LATD = 0000 0001
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state1_1 ; button not press, goto state1_1
    BRA pre_state2 ; if button press, goto pre_state2
state1_1:
    BTG LATD, 0 ; LATD = 0000 0000
    BTG LATD, 1 ; LATD = 0000 0010
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state1_2 ; button not press, goto state1_2
    BRA pre_state2 ; if button press, goto pre_state2
state1_2:
    BTG LATD, 1 ; LATD = 0000 0000
    BTG LATD, 2 ; LATD = 0000 0100
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state1_3 ; button not press, goto state1_3
    BRA pre_state2 ; if button press, goto pre_state2
state1_3:
    BTG LATD, 2 ; LATD = 0000 0000
    BTG LATD, 3 ; LATD = 0000 1000
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state1_4 ; button not press, goto state1_4
    BRA pre_state2 ; if button press, goto pre_state2
state1_4:
    BTG LATD, 3 ; LATD = 0000 0000
    BTG LATD, 0 ; LATD = 0000 0001
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state1_1 ; button not press, goto state1_1
    BRA pre_state2 ; if button press, goto pre_state2
pre_state2:
    CLRF LATD ; LATD = 0000 0000
    BTG LATD, 0 ; LATD = 0000 0001
    BTG LATD, 1 ; LATD = 0000 0011
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state2_1 ; button not press, goto state2_1
    BRA pre_state3 ; if button press, goto pre_state3
state2_1:
    BTG LATD, 0 ; LATD = 0000 0010
    BTG LATD, 2 ; LATD = 0000 0110
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state2_2 ; button not press, goto state2_2
    BRA pre_state3 ; if button press, goto pre_state3
state2_2:
    BTG LATD, 1 ; LATD = 0000 0100
    BTG LATD, 3 ; LATD = 0000 1100
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state2_3 ; button not press, goto state2_3
    BRA pre_state3 ; if button press, goto pre_state3
state2_3:
    BTG LATD, 2 ; LATD = 0000 1000
    BTG LATD, 0 ; LATD = 0000 1001
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state2_4 ; button not press, goto state2_4
    BRA pre_state3 ; if button press, goto pre_state3
state2_4:
    BTG LATD, 3 ; LATD = 0000 0001
    BTG LATD, 1 ; LATD = 0000 0011
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state2_1 ; button not press, goto state2_1
    BRA pre_state3 ; if button press, goto pre_state3
pre_state3:
    CLRF LATD ; LATD = 0000 0000
    BTG LATD, 0 ; LATD = 0000 0001
    BTG LATD, 1 ; LATD = 0000 0011
    BTG LATD, 2 ; LATD = 0000 0111
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state3_1 ; button not press, goto state3_1
    BRA pre_state1 ; if button press, goto pre_state1
state3_1:
    BTG LATD, 0 ; LATD = 0000 0110
    BTG LATD, 3 ; LATD = 0000 1110
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state3_2 ; button not press, goto state3_2
    BRA pre_state1 ; if button press, goto pre_state1
state3_2:
    BTG LATD, 1 ; LATD = 0000 1100
    BTG LATD, 0 ; LATD = 0000 1101
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state3_3 ; button not press, goto state3_3
    BRA pre_state1 ; if button press, goto pre_state1
state3_3:
    BTG LATD, 2 ; LATD = 0000 1100
    BTG LATD, 1 ; LATD = 0000 1011
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state3_4 ; button not press, goto state3_4
    BRA pre_state1 ; if button press, goto pre_state1
state3_4:
    BTG LATD, 3 ; LATD = 0000 0011
    BTG LATD, 2 ; LATD = 0000 0111
    DELAY d'200', d'89' ; delay for 0.5s
    BTFSC PORTA, 4 ; check button press
    BRA state3_1 ; button not press, goto state3_1
    BRA pre_state1 ; if button press, goto pre_state1
end