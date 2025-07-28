#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define N 5

int main(){
    srand(time(NULL));
    int Limit = 2;
    float head, tail;

    for(int i = 0; i < N; i++){
        int coin = rand() % Limit; // Will generate a number between 0 and Limit
        printf("%d \n", coin);

        if(coin == 1){      //head
            head++;
        }
        else{               //tail
            tail++;
        }
    }
    printf("The occurence of head is: %.0f\n", head);
    printf("Since, The probability of head is: %.2f\n", head/N);
    printf("\n");

    printf("The occurence of tail is: %.0f\n", tail);
    printf("Since, The probability of tail is: %.2f\n", tail/N);

    
    return 0;
}