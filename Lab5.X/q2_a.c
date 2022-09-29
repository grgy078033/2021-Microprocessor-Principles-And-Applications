/*
 * File:   q2_a.c
 * Author: grgy0
 *
 * Created on 2022?1?13?, ?? 7:07
 */

#include <pic18f4520.h>
#include <xc.h>
#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

void __interrupt(high_priority) Hi_ISR() {
    PORTDbits.RD0 = !RD0; // toggle RD0
    INTCONbits.INT0IF = 0; // clear flag bit
}
void main(void) {
    TRISBbits.RB0 = 1; //RB0 as input
    TRISDbits.RD0 = 0; //RD0 as output
    PORTDbits.RD0 = 0; //set LED off first
    
    INTCONbits.GIE = 1; // global interrupt enable bit
    INTCONbits.INT0IE = 1; // interrupt enable bit
    INTCONbits.INT0IF = 0; // clear flag bit first
    
    INTCON2bits.RBPU = 1; // PORTB Pull-up enable bit
    INTCON2bits.INTEDG0 = 0; // edge select bit
    
    while(1){}
    return;
}
