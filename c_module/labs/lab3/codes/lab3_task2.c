#include <stdio.h>

int main(){
    int N, bin;
    int num;

    printf("Enter the Number. \n");
    scanf("%d", &N);
    
    //Binary Conversion
    num = N;
    printf("Binary Conversion.\n");
    printf("LSB -----> MSB.\n");
    while(num != 0){
        bin = num % 2;
        printf("%d, ",bin);
        num = num / 2;
    }
    printf("\n\n");

    //Octal Conversion
    num = N;
    printf("Octal Conversion.\n");
    printf("LSB -----> MSB.\n");
    while(num != 0){
        bin = num % 8;
        printf("%d, ",bin);
        num = num / 8;
    }
    printf("\n\n");
    
    //Hex Conversion
    num = N;
    printf("Hexadecimal Conversion.\n");
    printf("LSB -----> MSB.\n");
    while(num != 0){
        bin = num % 16;
        printf("%d, ",bin);
        num = num / 16;
    }
    printf("\n\n");

    return 0;
}