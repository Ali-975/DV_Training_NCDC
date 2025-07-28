#include <stdio.h>

int main (){
    int yr;
    printf("Enter the year you want to find whether a leapyear or not: \n");
    scanf("%d", &yr);

    if (yr % 4 == 0){
        printf("Yes! this is a leap year. \n");
    }
    else{
        printf("No! this is not a leap year. \n");
    }
    return 0;
}