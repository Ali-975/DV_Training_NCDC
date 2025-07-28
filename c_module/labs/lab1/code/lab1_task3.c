#include <stdio.h>

int main(){
    char upper = 65, lower = 97, space = 32, num = 48, dash = 45;

    printf("My name is: %c%c%c%c%c%c%c%c%c%c%c%c%c \n",upper+12, lower+20, lower+3, lower+3, lower, lower+18, lower+18, lower+8, lower+17, space, upper, lower+11, lower+8);
    printf("My CNIC Number is: %c%c%c%c%c%c%c%c%c%c%c%c%c%c%c \n",num+4, num+2, num+4, num+0, num+1, dash, num+3, num+7, num+6, num+8, num+8, num+9, num+4, dash, num+9);

    return 0;
}