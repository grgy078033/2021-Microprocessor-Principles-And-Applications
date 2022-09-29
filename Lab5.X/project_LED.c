#include <xc.h>
#include <pic18f4520.h>
#include <stdlib.h> // for random function
#include <time.h> // for time function

#pragma config OSC = INTIO67   // Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
#pragma config FCMEN = OFF     // Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
#pragma config IESO = OFF      // Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

// #pragma config2L
#pragma config PWRT = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = SBORDIS // Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config BORV = 3        // Brown Out Reset Voltage bits (Minimum setting)

// #pragma config2H
#pragma config WDT = OFF       // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768   // Watchdog Timer Postscale Select bits (1:32768)

// #pragma config3H
#pragma config CCP2MX = PORTC  // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF    // PORTB A/D Enable bit (PORTB<4:0> pins are #pragma configured as analog input channels on Reset)
#pragma config LPT1OSC = OFF   // Low-Power Timer1 Oscillator Enable bit (Timer1 #pragma configured for higher power operation)
#pragma config MCLRE = ON      // MCLR Pin Enable bit (MCLR pin enabled// RE3 input pin disabled)

// #pragma config4L
#pragma config STVREN = ON     // Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
#pragma config LVP = OFF       // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config XINST = OFF     // Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

// #pragma config5L
#pragma config CP0 = OFF       // Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
#pragma config CP1 = OFF       // Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
#pragma config CP2 = OFF       // Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
#pragma config CP3 = OFF       // Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

// #pragma config5H
#pragma config CPB = OFF       // Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
#pragma config CPD = OFF       // Data EEPROM Code Protection bit (Data EEPROM not code-protected)

// #pragma config6L
#pragma config WRT0 = OFF      // Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
#pragma config WRT1 = OFF      // Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
#pragma config WRT2 = OFF      // Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
#pragma config WRT3 = OFF      // Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

// #pragma config6H
#pragma config WRTC = OFF      // Configuration Register Write Protection bit (Configuration registers(300000-3000FFh) not write-protected)
#pragma config WRTB = OFF      // Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
#pragma config WRTD = OFF      // Data EEPROM Write Protection bit (Data EEPROM not write-protected)

// #pragma config7L
#pragma config EBTR0 = OFF     // Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR1 = OFF     // Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR2 = OFF     // Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR3 = OFF     // Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

// #pragma config7H
#pragma config EBTRB = OFF  // Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

int target = 0;
int choose = 0;

void select_target(){
    // set random target
    int randnum = (unsigned int)(rand()%8)+1;
    target = randnum;
    
    // set target LED on
    if(randnum == 1 )PORTAbits.RA0 = 1;
    else if(randnum == 2 )PORTAbits.RA1 = 1;
    else if(randnum == 3 )PORTAbits.RA2 = 1;
    else if(randnum == 4 )PORTAbits.RA3 = 1;
    else if(randnum == 5 )PORTAbits.RA4 = 1;
    else if(randnum == 6 )PORTAbits.RA5 = 1;
    else if(randnum == 7 )PORTAbits.RA6 = 1;
    else if(randnum == 8 )PORTAbits.RA7 = 1;

    return;
}

void running_LED(){
    int count = 1;
    while(1){
        // click stop button
        if(PORTCbits.RC0 == 0){  
            choose = count - 1;
            break;
        }
        
        // set target LED on
        if(target == 1){
            PORTA = 0b00000001;
        }else if(target == 2){
            PORTA = 0b00000010;
        }else if(target == 3){
            PORTA = 0b00000100;
        }else if(target == 4){
            PORTA = 0b00001000;
        }else if(target == 5){
            PORTA = 0b00010000;
        }else if(target == 6){
            PORTA = 0b00100000;
        }else if(target == 7){
            PORTA = 0b01000000;
        }else if(target == 8){
            PORTA = 0b10000000;
        }
        
        // LED running
        choose = count;
        if(count == 1){            
            PORTAbits.RA0 = 1; 
        }else if(count == 2){
            PORTAbits.RA1 = 1;            
        }else if(count == 3){
            PORTAbits.RA2 = 1;            
        }else if(count == 4){
            PORTAbits.RA3 = 1;            
        }else if(count == 5){
            PORTAbits.RA4 = 1;            
        }else if(count == 6){
            PORTAbits.RA5 = 1;            
        }else if(count == 7){
            PORTAbits.RA6 = 1;           
        }else if(count == 8){
            PORTAbits.RA7 = 1;
            count = 0;
        }
        count++;
        _delay(75000);
    }
}
void win_LED(){
    // show winning
    PORTA = 0b00000001;
    _delay(9000);
    PORTA = 0b00000011;
    _delay(9000);
    PORTA = 0b00000111;
    _delay(9000);
    PORTA = 0b00001111;
    _delay(9000);
    PORTA = 0b00011111;
    _delay(9000);
    PORTA = 0b00111111;
    _delay(9000);
    PORTA = 0b01111111;
    _delay(9000);
    PORTA = 0b11111111;
    _delay(9000);
    PORTA = 0b01111111;
    _delay(9000);
    PORTA = 0b00111111;
    _delay(9000);
    PORTA = 0b00011111;
    _delay(9000);
    PORTA = 0b00001111;
    _delay(9000);
    PORTA = 0b00000111;
    _delay(9000);
    PORTA = 0b00000011;
    _delay(9000);
    PORTA = 0b00000001;
    _delay(9000);
    PORTA = 0b00000000;
    _delay(9000);
    for(int i = 0; i < 6; i++){
        PORTA = 0b01010101;
        _delay(9000);
        PORTA = 0b10101010;
        _delay(9000);
    }
    PORTA = 0;
    _delay(9000);
    for(int i = 0; i < 2; i++){
        PORTA = 255;
        _delay(25000);
        PORTA = 0;
        _delay(25000);
    }
    PORTBbits.RB0 = 1;// output RB0 = 1 to the other PIC18F4520 as a input signal
}

void finish(){
    //return;
}

void main(void) {
    
    while(1){
        // setting seed
        srand(time(NULL));
        
        // set LED
        TRISA = 0;
        LATA = 0;//led output
        
        //set PIC18F4520 connect signal
        TRISBbits.TRISB0 = 0; // set RB0 as output signal
        PORTBbits.RB0 = 0; // set RB0 = 0 first

        // set buttons
        TRISCbits.TRISC0 = 1; // start button
        TRISCbits.TRISC1 = 1; // game button
        TRISCbits.TRISC2 = 1;
        LATC = 0;
        PORTCbits.RC2 = 1;
        
        _delay(200);
        // click start button
        while(1){    
            _delay(100);
            if(PORTCbits.RC0 == 0){     
                break;
            }
        };
        select_target();
        
        // click hopping button
        while(1){    
            _delay(100);
            if(PORTCbits.RC1 == 0){
                break;
            }      
        };
        running_LED();
        
        // check whether hit
        if(target == choose){
            //LED action & output signal
            win_LED();
            _delay(250);
            while(1) {
                if(PORTCbits.RC2 == 0){
                    break;
                }
            };
            _delay(250);
        }
        _delay(50000);
        continue;
    }
}
