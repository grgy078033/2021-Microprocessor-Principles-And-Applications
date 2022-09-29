#include "xc.h"

extern unsigned int divide(unsigned int a, unsigned int b);

void main(void) {
    volatile unsigned int res = divide(255, 1);
    
    char *p; // creat a pointer
    p = (char*)&res; // pointer p point to the low byte of res address
    
    volatile unsigned char quotient = *(p+1); // high byte of res
    volatile unsigned char remainder = *p; // low byte of res
    while(1) {};
    return;
} 