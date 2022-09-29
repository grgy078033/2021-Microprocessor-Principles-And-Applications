LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
Initial:

start:
    clrf WREG ;clear WREG
    clrf TRISC ;clear TRISC
    addlw D'1' ;WREG + 1 -> WREG
loop:
    addwf TRISC, 1 ;WREG + TRISC -> TRISC
    rlcf WREG, 1 ;WREG left shift 1 bit
    btfss WREG, 7 ;if the 7th bit in WREG is 1, skip 'goto loop'
    goto loop
continue:
    clrf WREG ;clear WREG
    addwf TRISC, 0 ;WREG + TRISC -> WREG
end


