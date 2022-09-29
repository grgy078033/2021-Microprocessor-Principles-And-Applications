#include "xc.inc"
GLOBAL _divide_signed
    
PSECT mytext, local, class=CODE, reloc=2

_divide_signed:
    MOVFF WREG, TRISA // TRISA = remainder
    MOVFF 0x001, TRISB // TRISB = divisor
    MOVLW 0x08 // WREG = 8
    MOVFF WREG, TXREG // WREG -> TXREG = 8 (for loop)
    CLRF TRISC // for left 8 bit of remainder
    CLRF TRISD // for checking whether the remainder(bit 0 of TRISD) and
		// divisor(bit 1 of TRISD) is negative or not
    CLRF LATD // for final_check_remainder
    CLRF LATE // for final_check_divisor
check_remainder:
    BTFSS TRISA, 7 // check if remainder is negative or not
	GOTO check_divisor // remainder is positive, go to check divisor
    MOVLW 0xFF // WREG = '11111111' (mask)
    XORWF TRISA, F // 1's complement
    MOVLW 0x01 // WREG = 1
    ADDWF TRISA, F // +1 after 1's complement = 2's complement
    BSF TRISD, 0 // TRISA(remainder) is negative
check_divisor:
    BTFSS TRISB, 7 // check if divisor is negative or not
	GOTO start // divisor is positive, go to start
    MOVLW 0xFF // WREG = '11111111' (mask)
    XORWF TRISB, F // 1's complement
    MOVLW 0x01 // WREG = 1
    ADDWF TRISB, F // +1 after 1's complement = 2's complement
    BSF TRISD, 1 // TRISB(divisor) is negative
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
final_check_remainder:
    MOVLW 0x01
    BTFSS TRISD, 0 // check whether input remainder is negative or not
	GOTO final_check_divisor // if positive, go to check divisor
    MOVFF WREG, LATD // if negative, LATD = '00000001'
final_check_divisor:
    MOVLW 0x01
    BTFSS TRISD, 1 // check whether input divisor is negative or not
	GOTO final_check // if positive, go to final check
    MOVFF WREG, LATE // if negative, LATE = '00000001'
final_check:
    CLRF WREG // WREG = 0
    ADDWF LATD, W // WREG = LATD
    XORWF LATE, W // WREG 'XOR' LATE -> if 1, do 2's complement
		    //			  if 0, do nothing
    BTFSS WREG, 0 // to check the result of LATD XOR LATE
	GOTO fix_remainder // if 0, do nothing and go to fix_remainder
fix_quotient:
    //quotient (8bit)
    MOVLW 0xFF // WREG = '11111111' (mask)
    XORWF TRISA, F // 1's complement
    MOVLW 0x01 // WREG = 1
    ADDWF TRISA, F // +1 after 1's complement = 2's complement
fix_remainder:
    //remainder (4bit)
    BTFSS LATD, 0 // to check whether the remainder is positive or not
	GOTO done // if positive, go to done	
    MOVLW 0xFF // WREG = '11111111' (mask)
    XORWF TRISC, F // 1's complement
    MOVLW 0x01 // WREG = 1
    ADDWF TRISC, F // +1 after 1's complement = 2's complement
    MOVLW 0x0F // WREG = '00001111' (mask)
    ANDWF TRISC, F // to keep the 4 bit at right(the remainder we want)
done:
    // TRISA = quotient
    // TRISC = remainder
    MOVFF TRISA, 0x002 // quotient -> high address(high byte of res)
    MOVFF TRISC, 0x001 // remainder -> low address(low byte of res)
    RETURN 


