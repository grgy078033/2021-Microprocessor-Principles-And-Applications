LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
Initial:
    
start:
    MOVLW 0x00 ; W = 0x00
    MOVWF TRISA ; W -> TRISA = 0x00 (F0)
    MOVLW 0x01 ; W = 0x01
    MOVWF TRISB ; W -> TRISB = 0x01 (F1)
    MOVLW 0x06 ;WREG = 6
    MOVWF TRISC ; W -> TRISC = 0x06 (for loop)
    RCALL Fib
    RCALL finish
Fib:
    CLRF WREG ; clear W
    MOVFF TRISA, WREG ; TRISA -> W
    ADDWF TRISB, 0 ; W + TRISB -> W
    MOVFF TRISB, TRISA ; TRISB -> TRISA
    MOVFF WREG, TRISB ; W -> TRISB
    MOVLW 0x10 ; W = 0x0C
    DECFSZ TRISC ; TRISC - 1, if TRISC = 0, skip
    MOVWF PCL ; PCL = 0x10
    RETURN
finish:
    MOVFF TRISA, 0x00; TRISA -> 0x00
end
    


