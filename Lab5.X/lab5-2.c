#include "xc.h"

extern unsigned int divide_signed(unsigned char a, unsigned char b);

void main(void) {
    //volatile unsigned int res = divide_signed(-20, -4); // ans:(5, 0)
    //volatile unsigned int res = divide_signed(127, -6); // ans:(235, 1)
    //volatile unsigned int res = divide_signed(-12, -7); // ans:(1, 11)
    //volatile unsigned int res = divide_signed(-128, 5); // ans:(231, 13)
    volatile unsigned int res = divide_signed(-3, -5);  // ans:(0, 13)
    
    char *p; // creat a pointer
    p = (char*)&res; // pointer p point to the low byte of res address
    
    volatile unsigned char quotient = *(p+1); // high byte of res
    volatile unsigned char remainder = *p; // low byte of res
    while(1) {};
    return;
} 