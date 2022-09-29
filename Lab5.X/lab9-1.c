#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

void main(void)
{
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 탎
    OSCCONbits.IRCF = 0b001;
    
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    // RB0 -> Input
    TRISB = 1;
    
    // WREG = 0b00000000
    WREG = 0b00000000;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8탎 * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x04*4 + 0b00) * 8탎 * 4
     * = 0.000512s ~= 500탎
     */
    CCPR1L = 0x04;
    CCP1CONbits.DC1B = 0b00;
    
    while(1){
        if(PORTBbits.RB0 == 1) { //button click
            WREG = 0b00000001;
            _delay(100);
        }
        if(WREG == 0b00000001) {
            if(CCP1CONbits.DC1B == 0b11) {
                CCPR1L = CCPR1L + 0x01;
                CCP1CONbits.DC1B = 0b00;
            } else {
                CCP1CONbits.DC1B = CCP1CONbits.DC1B + 0b01;
            }
            if(CCPR1L == 0x12 && CCP1CONbits.DC1B == 0b11) {
                /**
                * Duty cycle
                * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
                * = (0x12*4 + 0b11) * 8탎 * 4
                * = 0.00240s ~= 2400탎
                */
                WREG = 0b00000000;
            }
        } 
        if(WREG == 0b00000000) {
            /**
            * Duty cycle
            * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
            * = (0x04*4 + 0b00) * 8탎 * 4
            * = 0.000512s ~= 500탎
            */
           CCPR1L = 0x04;
           CCP1CONbits.DC1B = 0b00;
        }
    }
    return;
}