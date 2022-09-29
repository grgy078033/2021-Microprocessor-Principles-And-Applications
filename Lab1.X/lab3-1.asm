LIST p = 18f4520
    #include<p18f4520.inC>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
start:
    CLRF WREG ; clear WREG
    CLRF TRISA ; clear TRISA
    MOVLW 0xC2 ; WREG = 0xC2
    MOVWF TRISA ; TRISA = WREG -> TRISA = 0xC2 = '11000010'
    MOVWF TRISB ; TRISB = WREG -> TRISB = 0xC2 = '11000010'
    MOVLW B'10000000' ; WREG = '10000000'
continue:
    ANDWF TRISB, 0 ; WREG 'AND' TRISB = 
		    ;		          10000000
		    ;	             AND  11000010
		    ;		    ---------------
		    ;		 WREG  =  10000000  To determine whether to keep
		    ;				    the signed bit or not
    RRNCF TRISA ; TRISA right shift 1 bit = '01100001'
    IORWF TRISA, 1 ; WREG 'OR' TRISA = 
		   ;  		        10000000
		   ;		    OR  01100001
		   ;		   --------------
		   ;	      TRISA  =  11100001
end


