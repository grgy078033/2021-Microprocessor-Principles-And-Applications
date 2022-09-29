LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
    
Initial:

start:
    clrf WREG ;clear WREG
    addlw 0x00D99BFF
end


