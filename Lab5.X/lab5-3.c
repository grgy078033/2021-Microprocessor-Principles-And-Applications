#include "xc.h"

extern unsigned char mysqrt(unsigned int a);

void main(void) {
    //volatile unsigned int res = mysqrt(0); // ans: 0x00
    volatile unsigned int res = mysqrt(10); // ans: 0x03
    //volatile unsigned int res = mysqrt(15); // ans: 0x03
    //volatile unsigned int res = mysqrt(400); // ans: 0x14
    //volatile unsigned int res = mysqrt(800);  // ans: 0x1C
    //volatile unsigned int res = mysqrt(1300); // ans: 0x24
    //volatile unsigned int res = mysqrt(1600); // ans: 0x28
    
    //char *p; // creat a pointer
    //p = (char*)&res; // pointer p point to the low byte of res address
    
    //volatile unsigned char quotient = *(p+1); // high byte of res
    //volatile unsigned char remainder = *p; // low byte of res
    while(1) {};
    return;
} 