#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
#include <xc.h>
#include <PIC18F4520.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit 
#pragma config PWRT = OFF    // Power-up Enable bit
//#pragma config BOREN = ON   // Brown-out Reset Enable bit
//#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)
#define _XTAL_FREQ 200000
#define rc0 PORTCbits.RC0
#define rc1 PORTCbits.RC1 
#define rc2 PORTEbits.RE0 
#define rc3 PORTCbits.RC3 
#define rc4 PORTCbits.RC4 
#define rc5 PORTCbits.RC5 
#define rc6 PORTEbits.RE1 
#define rc7 PORTEbits.RE2 

char str[20];

void setBits(unsigned char a,unsigned char b,unsigned char c,unsigned char d,unsigned char e,unsigned char f,unsigned char g,unsigned char h){
    rc0=a;
    rc1=b;
    rc2=c;
    rc3=d;
    rc4=e;
    rc5=f;
    rc6=g;
    rc7=h;
}

void main(void) 
{
    //oscillator frequency=4MHZ
//    OSCCONbits.IRCF = 0b110;
    //Initialize TRISD
    TRISD=0;
    TRISC=0;
    TRISE=0;
    TRISA=1;
    TRISB=1;
    
    PORTC=0;
    PORTD=0;       
    PORTE=0;
    //select VREF default Vss Vdd   
    ADCON1bits.VCFG1=0b0;
    ADCON1bits.VCFG0=0b0;
    //select port control
    ADCON1bits.PCFG=0b1110;
    //select input channel AN0
    //select conversion clock
    ADCON2bits.ADCS=0b100;    
    //select acquisition time
    ADCON2bits.ACQT=0b010;
    //Turn on module
    ADCON0bits.ADON=0b1;
    //select justified method
    ADCON2bits.ADFM=0b0;
    SYSTEM_Initialize() ;
    int check = 0;
    PORTBbits.RB0=0;
    while(1) {
        //PORTBbits.RB0=0;
        //while (PORTBbits.RB0==0){};
        //PORTBbits.RB0=1;
        //__delay_ms(30);
        if (PORTBbits.RB0==1)
        {
            while (1)
            {
            unsigned int x = ADC_Read(0);
            if(0<=x&&x<23){             //1, female
            if(check == 0) {
                UART_Write_Text("Judy was a girl, ");
                check = 1;
            }
            PORTD = 0b01111111;
            setBits(0,0,0,0,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b10111111;
            setBits(0,0,0,0,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b11011111;
            setBits(0,1,0,0,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b11101111;
            setBits(1,0,1,1,1,1,1,0);
            __delay_ms(30);
            PORTD = 0b11110111;
            setBits(1,0,1,1,1,1,1,0);
            __delay_ms(30);
            PORTD = 0b11111011;
            setBits(0,1,0,0,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111101;
            setBits(0,0,0,0,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111110;
            setBits(0,0,0,0,0,0,0,0);
            __delay_ms(30);
        }
        if(23<=x&&x<46){             //2, walking
            if(check == 1) {
                UART_Write_Text("Judy was a girl, who was walking on the street. ");
                check = 0;
            }
            PORTD = 0b00111111;
            setBits(0,0,0,1,0,0,1,0);
            __delay_ms(30);
            PORTD = 0b11011111;
            setBits(1,1,0,1,0,1,0,0);
            __delay_ms(30);
            PORTD = 0b11101111;
            setBits(1,1,1,1,1,0,0,1);
            __delay_ms(30);
            PORTD = 0b11110111;
            setBits(1,1,0,1,0,1,1,1);
            __delay_ms(30);
            PORTD = 0b11111011;
            setBits(0,0,0,0,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111101;
            setBits(0,0,0,0,0,1,0,0);
            __delay_ms(30);
            PORTD = 0b11111110;
            setBits(0,0,0,0,0,0,0,0);
            __delay_ms(30);
        }  
        else if(46<=x&&x<69){       //3, melody
            if(check == 0) {
                UART_Write_Text("She was so happy so she sang a song while she went along. ");
                check = 1;
            }
            PORTD = 0b01111111;
            setBits(0,0,0,0,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b10111111;
            setBits(0,0,0,0,0,1,1,0);
            __delay_ms(30);
            PORTD = 0b11011111;
            setBits(0,0,0,0,0,1,1,0);
             PORTD = 0b11101111;
            setBits(1,1,1,1,1,1,1,0);
            __delay_ms(30);
            PORTD = 0b11110111;
            setBits(1,1,1,1,1,1,0,0);
            __delay_ms(30);
            PORTD = 0b11111011;
             setBits(0,1,0,0,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111101;
            setBits(0,0,1,0,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111110;
            setBits(0,0,0,1,0,0,0,0);
            __delay_ms(30);
        }
        else if(69<=x&&x<92){        //4, sun
            if(check == 1) {
                UART_Write_Text("It was a sunny day,  ");
                check = 0;
            }
             PORTD = 0b01111110;
            setBits(1,0,1,1,1,1,0,0);
            __delay_ms(30);
            PORTD = 0b10111101;
            setBits(0,1,0,0,0,0,1,0);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(1,0,1,0,1,0,0,1);
            __delay_ms(30);
            PORTD = 0b11100111;
            setBits(1,0,0,0,0,1,0,1);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(0,0,1,0,0,0,0,0);
            __delay_ms(30);
        }
        else if(92<=x&&x<115){      //5, drink
            if(check == 0) {
                UART_Write_Text("she felt thirsty, so she decided to get an ice coffee.  ");
                check = 1;
            }
           PORTD = 0b01111111;
            setBits(0,0,0,0,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b10111111;
            setBits(0,0,1,1,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b11001111;
            setBits(0,0,1,1,1,1,1,1);
            __delay_ms(30);
            PORTD = 0b11110111;
            setBits(1,1,1,1,1,1,1,1);
            __delay_ms(30);
            PORTD = 0b11111011;
            setBits(1,0,1,1,1,1,1,1);
            __delay_ms(30);
            PORTD = 0b11111101;
            setBits(1,0,1,1,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111110;
            setBits(0,0,0,0,0,0,0,0);
            __delay_ms(30);
        }
        else if(115<=x&&x<138){     //6, happy 
            if(check == 1) {
                UART_Write_Text("After she got the coffee, she was too excited. ");
                check = 0;
            }
            PORTD = 0b01111110;
            setBits(0,0,1,1,1,1,0,0);
            __delay_ms(30);
            PORTD = 0b10111101;
            setBits(0,1,0,0,0,0,1,0);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(1,0,1,0,1,0,0,1);
            __delay_ms(30);
            PORTD = 0b11100111;
            setBits(1,0,0,0,0,1,0,1);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(0,0,1,0,0,0,0,0);
            __delay_ms(30);
        }
        else if(138<=x&&x<161){     //7, ball
            if(check == 0) {
                UART_Write_Text("But at the meanwhile, she was hit by a ball, ");
                check = 1;
            }
            PORTD = 0b01111110;
            setBits(0,0,1,1,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b10111101;
            setBits(0,1,0,0,0,1,0,0);
            __delay_ms(30);
            PORTD = 0b11000011;
            setBits(1,0,0,0,0,0,1,0);
            __delay_ms(30);
        }
        else if(161<=x&&x<184){     //8,broken drink
            if(check == 1) {
                UART_Write_Text("and the ice coffee was split. ");
                check = 0;
            }
            PORTD = 0b10111101;
            setBits(0,1,0,0,0,0,1,0);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(0,0,1,0,0,1,0,0);
            __delay_ms(30);
            PORTD = 0b11100111;
            setBits(0,0,0,1,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b01111110;
            setBits(1,0,0,0,0,0,0,1);
            __delay_ms(30);
         
        }
        else if(184<=x&&x<210){     //9, sad
            if(check == 0) {
                UART_Write_Text("Although she felt so frustrated, ");
                check = 1;
            }
            PORTD = 0b01111110;
            setBits(0,0,1,1,1,1,0,0);
            __delay_ms(30);
            PORTD = 0b10111101;
            setBits(0,1,0,0,0,0,1,0);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(1,0,1,0,0,1,0,1);
            __delay_ms(30);
            PORTD = 0b11100111;
            setBits(1,0,0,0,1,0,0,1);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(0,0,1,0,0,0,0,0);
            __delay_ms(30);
        }
        else if(210<=x&&x<233){     //10, heart
            if(check == 1) {
                UART_Write_Text("her boy friend appeared and gave her a new ice coffee. ");
                check = 0;
            }
            PORTD = 0b01111111;
            setBits(0,1,1,0,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b10111111;
            setBits(1,0,0,1,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b11011111;
            setBits(1,0,0,0,1,0,0,0);
             PORTD = 0b11101111;
            setBits(0,1,0,0,0,1,0,0);
            __delay_ms(30);
            PORTD = 0b11110111;
            setBits(0,1,0,0,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111011;
             setBits(1,0,0,0,1,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111101;
            setBits(1,0,0,1,0,0,0,0);
            __delay_ms(30);
            PORTD = 0b11111110;
            setBits(0,1,1,0,0,0,0,0);
            __delay_ms(30);
        }
        else if(233<=x){            //11, happy
            if(check == 0) {
                UART_Write_Text("And she felt happy again. ");
                check = 1;
            }
            PORTD = 0b01111110;
            setBits(0,0,1,1,1,1,0,0);
            __delay_ms(30);
            PORTD = 0b10111101;
            setBits(0,1,0,0,0,0,1,0);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(1,0,1,0,1,0,0,1);
            __delay_ms(30);
            PORTD = 0b11100111;
            setBits(1,0,0,0,0,1,0,1);
            __delay_ms(30);
            PORTD = 0b11011011;
            setBits(0,0,1,0,0,0,0,0);
            __delay_ms(30);
        }
   }
        }
    }
    return;  
}

// old version: 
// void interrupt high_priority Hi_ISR(void)
void __interrupt(high_priority) Hi_ISR(void)
{
     if(PIR1bits.CCP1IF == 1) {
        RC2 ^= 1;
        PIR1bits.CCP1IF = 0;
        TMR3 = 0;
    }
    return;
}