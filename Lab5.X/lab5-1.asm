#include "xc.inc"
GLOBAL _divide
    
PSECT mytext, local, class=CODE, reloc=2

_divide:
 MOVFF 0x001, TRISA // TRISA = remainder
 MOVFF 0x003, TRISB // TRISB = divisor
 MOVLW 0x08 // WREG = 8
 MOVFF WREG, TXREG // WREG -> TXREG = 8 (for loop)
 CLRF TRISC // as the left 8 bit of remainder
 
 start:
    RLCF TRISA // shift the remainder register left 1 bit
    RLNCF TRISC // shift the remainder register left 1 bit
    BNC step1
	MOVLW 0x01 // WREG = 1
	ADDWF TRISC, 1 // TRISC + 1 (after left shift, if carry = 1, means 
			 //		that TRISC's LSB will be 1)
 step1:
    MOVFF TRISB, WREG // TRISB -> WREG = divisor
    SUBWF TRISC, 0, 0 // substract WREG(divisor) from TRISC(left 8 bit of remainder)
    MOVFF WREG, TRISC // WREG -> TRISC = left 8 bit of remainder - divisor
    BNN step2_2 // if remainder >= 0
step2_1:
    // if remainder < 0
    ADDWF TRISB, W // adding the left half of the remainder to divisor
    MOVFF WREG, TRISC // restroe TRISC
    RLCF TRISA // shift the remainder register left 1 bit
    RLNCF TRISC // shift the remainder register left 1 bit
    MOVLW 0xFE // generate a mask '11111110'
    ANDWF TRISA, F // set rightmost bit of remainder = 0
    BNC step3
	MOVLW 0x01 // WREG = 1
	ADDWF TRISC, F // TRISC + 1 (after left shift, if carry = 1, means 
			 //		that TRISC's LSB will be 1)
    goto step3
step2_2:
    // if remainder >= 0
    RLCF TRISA // shift the remainder register left 1 bit
    RLNCF TRISC // shift the remainder register left 1 bit
    BNC set_rightmost_bit
	MOVLW 0x01 // WREG = 1
	ADDWF TRISC, F // TRISC + 1 (after left shift, if carry = 1, means 
			 //		that TRISC's LSB will be 1)
    set_rightmost_bit:
	MOVLW 0x01
	ADDWF TRISA, F
step3:
    //repeat for 8 times
    DECFSZ TXREG
	goto step1
step4:
    RRNCF TRISA
    RRNCF TRISC // shift left half of remainder right 1 bit
    // TRISA = quotient
    // TRISC = remainder
    MOVFF TRISA, 0x002 // quotient -> high address(high byte of res)
    MOVFF TRISC, 0x001 // remainder -> low address(low byte of res)
    RETURN 