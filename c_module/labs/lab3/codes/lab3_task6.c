#include <stdio.h>

int main (){
    int min;

    printf("Enter the minutes (0-59) \n");
    scanf("%d", &min);
    printf("\n\n");

    for (int i = 0; i < min; i++){
        for (int j = 0; j < 60; j++){
            if(i < 10){
                printf("0");
            }
            printf("%d", i);
            printf(" : ");
            if(j < 10){
                printf("0");
            }
            printf("%d", j);
            printf("\n");
        }
        printf("\n");
    }
    return 0;
}