
#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

void __interrupt(high_priority) Hi_ISR() {
    //step4
    int value = ADRESH * 256 + ADRESL;
    
    //do things
    if(value <= 63) {
        LATDbits.LD0 = 0;
        LATDbits.LD1 = 0;
        LATDbits.LD2 = 0;
        LATDbits.LD3 = 0;
    }
    else if(value > 63 && value <= 127) {
        LATDbits.LD0 = 1;
        LATDbits.LD1 = 0;
        LATDbits.LD2 = 0;
        LATDbits.LD3 = 0;
    }
    else if(value > 127 && value <= 191) {
        LATDbits.LD0 = 0;
        LATDbits.LD1 = 1;
        LATDbits.LD2 = 0;
        LATDbits.LD3 = 0;
    }
    else if(value > 191 && value <= 255) {
        LATDbits.LD0 = 1;
        LATDbits.LD1 = 1;
        LATDbits.LD2 = 0;
        LATDbits.LD3 = 0;
    }
    else if(value > 255 && value <= 319) {
        LATDbits.LD0 = 0;
        LATDbits.LD1 = 0;
        LATDbits.LD2 = 1;
        LATDbits.LD3 = 0;
    }
    else if(value > 319 && value <= 383) {
        LATDbits.LD0 = 1;
        LATDbits.LD1 = 0;
        LATDbits.LD2 = 1;
        LATDbits.LD3 = 0;
    }
    else if(value > 383 && value <= 447) {
        LATDbits.LD0 = 0;
        LATDbits.LD1 = 1;
        LATDbits.LD2 = 1;
        LATDbits.LD3 = 0;
    }
    else if(value > 447 && value <= 511) {
        LATDbits.LD0 = 1;
        LATDbits.LD1 = 1;
        LATDbits.LD2 = 1;
        LATDbits.LD3 = 0;
    }
    else if(value > 511 && value <= 575) {
        LATDbits.LD0 = 0;
        LATDbits.LD1 = 0;
        LATDbits.LD2 = 0;
        LATDbits.LD3 = 1;
    }
    else if(value > 575 && value <= 639) {
        LATDbits.LD0 = 1;
        LATDbits.LD1 = 0;
        LATDbits.LD2 = 0;
        LATDbits.LD3 = 1;
    }
    else if(value > 639 && value <= 703) {
        LATDbits.LD0 = 0;
        LATDbits.LD1 = 1;
        LATDbits.LD2 = 0;
        LATDbits.LD3 = 1;
    }
    else if(value > 703 && value <= 767) {
        LATDbits.LD0 = 1;
        LATDbits.LD1 = 1;
        LATDbits.LD2 = 0;
        LATDbits.LD3 = 1;
    }
    else if(value > 767 && value <= 831) {
        LATDbits.LD0 = 0;
        LATDbits.LD1 = 0;
        LATDbits.LD2 = 1;
        LATDbits.LD3 = 1;
    }
    else if(value > 831 && value <= 895) {
        LATDbits.LD0 = 1;
        LATDbits.LD1 = 0;
        LATDbits.LD2 = 1;
        LATDbits.LD3 = 1;
    }
    else if(value > 895 && value <= 959) {
        LATDbits.LD0 = 0;
        LATDbits.LD1 = 1;
        LATDbits.LD2 = 1;
        LATDbits.LD3 = 1;
    }
    else if(value > 959 && value <= 1023) {
        LATDbits.LD0 = 1;
        LATDbits.LD1 = 1;
        LATDbits.LD2 = 1;
        LATDbits.LD3 = 1;
    }
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    //step5 & go back step3
    _delay(10); //delay at least 2Tad
    ADCON0bits.GO = 1;
}

void main(void) {
    OSCCONbits.IRCF = 0b110; // 4MHz
    TRISAbits.RA0 = 1; // analog input port
    TRISDbits.RD0 = 0; // RD0 = output
    TRISDbits.RD1 = 0; // RD1 = output
    TRISDbits.RD2 = 0; // RD2 = output
    TRISDbits.RD3 = 0; // RD3 = output
    
    //step1
    ADCON1bits.VCFG0 = 0; // VDD = 0
    ADCON1bits.VCFG1 = 0; // VSS = 0
    ADCON1bits.PCFG = 0b1110; // only AN0 = Analog input, other ANx = digital I/O
    ADCON0bits.CHS = 0b0000; // pick AN0 as analog input
    ADCON2bits.ADCS = 0b100; // 4MHz < 5.71Hz
    ADCON2bits.ACQT = 0b010; // Tad = 4*1/4µs = 1µs, set Acquisition time = 4Tad = 4µs > 2.4
    ADCON0bits.ADON = 1; // A/D Converter module is enabled
    ADCON2bits.ADFM = 1; //right justified (10bits)
    
    //step2
    PIE1bits.ADIE = 1; // Enable A/D interrupt
    PIR1bits.ADIF = 0; // Clear A/D interrupt flag bit
    INTCONbits.PEIE = 1; // Enable peripheral interrupt
    INTCONbits.GIE = 1; // Set GIE bit
    
    //step3
    ADCON0bits.GO = 1; //start conversion
    return;
}
