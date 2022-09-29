LIST p = 18f4520
    #INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x10 
start:
    LFSR 0, 0x100 ; FSR0 point to 0x100
    CLRF INDF0 ; clear FSR0
    CLRF WREG ; clear WREG
    CLRF TRISC ; clear TRISC
    MOVLW 0x09 ; WREG = 0x09
    MOVWF TRISC ; move WREG -> TRISC
    CLRF WREG ; clear WREG
    MOVLW 0x00 ; WREG = 0x00
loop1:
    MOVWF POSTINC0 ; move WREG -> FSR0, FSR0 point to next address
    INCF WREG ; WREG + 1
    DECFSZ TRISC ; TRISC - 1, if TRISC <= 0, skip GOTO
    GOTO loop1
continue1:
    CLRF WREG ; clear WREG
    CLRF TRISC ; clear TRISC
    LFSR 0, 0x108 ; FSR0 point to 0x108
    LFSR 1, 0x110 ; FSR1 point to 0x110
    MOVLW 0x09 ; WREG = 0x09
    MOVWF TRISC ; move WREG -> TRISC
    CLRF WREG ; clear WREG
loop2:
    MOVFF POSTDEC0, POSTINC1 ; move FSR0 -> FSR1, FSR0 point to last address
			       ;		    FSR1 point to next address
    DECFSZ TRISC ; TRISC - 1, if TRISC <= 0, skip GOTO
    GOTO loop2
end
