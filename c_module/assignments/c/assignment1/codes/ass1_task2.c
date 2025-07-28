#include <stdio.h>

int main(){
    int units;
    printf("Enter the number of units consumed: \n");
    scanf("%d", &units);

    switch (units)
    {
    case 100:
        printf("you are charged by 1800 Rs.\n");
        break;

    case 200:
        printf("you are charged by 3600 Rs.\n");
        break;

    case 250:
        printf("you are charged by 7500 Rs.\n");
        break;

    case 350:
        printf("you are charged by 10500 Rs.\n");
        break;

    case 500:
        printf("you are charged by 20000 Rs.\n");
        break;

    case 400:
        printf("you are charged by 16000 Rs.\n");
        break;
    
    default:
        break;
    }
    return 0;
}