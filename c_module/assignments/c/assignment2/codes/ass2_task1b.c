#include <stdio.h>
#define N 10

int main(){
    float sum = 0, incr;
    printf("Enter the positive number of Interval less than 1.\n");
    scanf("%f", &incr);
    if(incr > 1){
        printf("Warning! Enter number less than 1. \n");
        return 0;
    }

    else{
        while(sum < N){
            sum += incr;
            // printf("Sum. %.2f\n", sum);
        }
    }
    printf("After multiple increments. %.2f\n", sum);
    return 0;
}