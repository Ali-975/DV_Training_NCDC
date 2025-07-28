#include <stdio.h>

int main(){
    int cty[10];
    int avg;
    for(int i=0; i<10; i++){
        printf("Enter the population of city # (%d): ", i+1);
        scanf("%d", &cty[i]);
    }

    // Reverse the array
    printf("\n\nThe population in reverse order.\n");
    for(int i=9; i>=0; i--){
        printf("The population of city # (%d) is: %d \n", i+1, cty[i]);
        avg += cty[i];
    }

    //Max Population
    int max = cty[0];
    for(int i=0; i<9; i++){
        if(max < cty[i+1]){
            max = cty[i+1];
        }
    }

    //Min Population
    int min = cty[0];
    for(int i=0; i<9; i++){
        if(min > cty[i+1]){
            min = cty[i+1];
        }
    }
    avg = avg / 10;

    printf("\n\nThe Maximum population is: %d\n", max);
    printf("The Minimum population is: %d\n", min);
    printf("The Average population is: %d\n", avg);
    
    return 0;
}