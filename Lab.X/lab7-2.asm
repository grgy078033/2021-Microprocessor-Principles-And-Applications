LIST p = 18f4520
; PIC18F4520 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)
  
  L1 EQU 0X14
  L2 EQU 0X15
  ORG 0x00
  
  DELAY MACRO NUM1, NUM2 ; DELAY d'200', d'89'
    LOCAL LOOP1 ; innerloop, use local to prevent compiler error
    LOCAL LOOP2 ; outerloop
    MOVLW NUM2 ; 1 cycle
    MOVWF L2 ; L2 = 89
    LOOP2:
	MOVLW NUM1 ; 1 cycle
	MOVWF L1 ; L1 = 200
    LOOP1:
	NOP ; 1 cycle
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1,1 ; 1 cycle
	BRA LOOP1 ; 1 cycle
	DECFSZ L2,1
	BRA LOOP2
ENDM ; 2+(2+7*200+2)*45 = 63182 , close to 0.25sec
     ; 2+(2+7*200+2)*90 = 126362 , close to 0.5sec
     ; 2+(2+7*200+2)*180 = 252722 , close to 1.0 sec
START:
INITIAL:
    MOVLW 0x0F ; configure A/D
    MOVWF ADCON1 ; set digital I/O
    
    CLRF PORTB ; clear PORTB
    BSF TRISB, 0 ; set RB0 as input, TRISB = 0000 0001
    CLRF LATD ; clear LATD
    BCF TRISD, 0 ; set RD0 as output, TRISD = 0000 0000
    BCF TRISD, 1 ; set RD1 as output, TRISD = 0000 0000
    BCF TRISD, 2 ; set RD2 as output, TRISD = 0000 0000
    BCF TRISD, 3 ; set RD3 as output, TRISD = 0000 0000
    BSF INTCON, RBIE
    BSF INTCON, GIE
STATE_1:
    BSF LATD, 0
    BCF LATD, 1
    BCF LATD, 2
    BCF LATD, 3
    DELAY d'200', d'180'
    DELAY d'200', d'90'
    DELAY d'200', d'45'
    BCF LATD, 0
    BSF LATD, 1
    BCF LATD, 2
    BCF LATD, 3
    DELAY d'200', d'180'
    DELAY d'200', d'90'
    DELAY d'200', d'45'
    BCF LATD, 0
    BCF LATD, 1
    BSF LATD, 2
    BCF LATD, 3
    DELAY d'200', d'180'
    DELAY d'200', d'90'
    DELAY d'200', d'45'
    BCF LATD, 0
    BCF LATD, 1
    BCF LATD, 2
    BSF LATD, 3
    DELAY d'200', d'180'
    DELAY d'200', d'90'
    DELAY d'200', d'45'
MAIN:
    GOTO MAIN
END
    
ISR: ; Intterupt Service Routine
    ORG 0x08
    BTG WREG, 0
    BCF INTCON, RBIF 
    RETFIE


