LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
Initial:

start:
    BRA 0x04
    clrf WREG ;clear WREG
    clrf TRISD ;clear TRISD
    
    addlw 0x0F ;WREG = 15
loop:
    addwf TRISD, 1 ;WREG + TRISD -> TRISD
    decfsz WREG ; WREG - 1, if WREG = 0, skip 'goto'
    goto loop
continue:
    addwf TRISD, 0 ;WREG + TRISD -> WREG
end


