LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
Initial:
    MOVLF macro literal, F
	MOVLW literal ; literal -> W
	MOVWF F ; W -> F
	CLRF WREG ; clear W
	endm
    RECT macro addr_x1, addr_y1, addr_x2, addr_y2, F
	ADDWF addr_x1, 0 ; W + x1 -> W
	SUBWF addr_x2, 0 ; F(x2) - W(x1) -> W(x2-x1)
	MOVWF TRISB ; W -> TRISB(x2-x1)
	CLRF WREG ; clear WREG
	ADDWF addr_y1, 0 ; W + y1 -> W
	SUBWF addr_y2, 0 ; F(y2) - W(y1) -> W(y2-y1)
	MULWF TRISB, 0 ; W(y2-y1) * TRISB(x2-x1) -> PROD
	MOVFF PROD, F ; PROD -> F
	endm
start:
    MOVLF 0x03, 0x00
    MOVLF 0x09, 0x01
    MOVLF 0x07, 0x02
    MOVLF 0x0F, 0x03
    RECT 0x00, 0x01, 0x02, 0x03, 0x04
end

