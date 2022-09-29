LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
start:
    CLRF WREG ; clear WREG
    CLRF TRISA ; clear TRISA
    CLRF TRISB ; clear TRISB
    CLRF TRISC ; clear TRISC
    MOVLW 0x0D ; WREG = OxOD
    MOVWF TRISB ; TRISB = WREG -> TRISB = 0x0D = '00001101'
    MOVLW 0x06 ; WREG = 0x06
    MOVWF TRISC ; TRISC = WREG -> TRISC = 0x06 = '00000110'
    CLRF WREG ; clear WREGg
continue:
    RRNCF TRISC ; TRISC shift right
    BNC next1
	ADDWF TRISB, 0 ; WREG + TRISB -> WREG
next1:
    RLCF WREG ; WREG shift left
    RRCF TRISC ; TRISC shift right
    BNC next2
	ADDWF TRISB, 0 ; WREG + TRISB -> WREG
next2:
    RLCF WREG ; WREG shift left
    RRCF TRISC ; TRISC shift right
    BNC next3
	ADDWF TRISB, 0 ; WREG + TRISB -> WREG
next3:
    RLCF WREG ; WREG shift left
    RRCF TRISC ; TRISC shift right
    BNC final
	ADDWF TRISB, 0 ; WREG + TRISB -> WREG
final:
    MOVWF TRISA ; WREG -> TRISA
end


