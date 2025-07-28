#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main (){
    int loc;

    printf("Select the Location from (1-16) \n\n\n");
    printf("--------------------------------- \n");
    printf("|       |       |       |       | \n");
    printf("|   12  |   13  |   14  |   15  | \n");
    printf("|       |       |       |       | \n");
    printf("--------------------------------- \n");
    printf("|       |       |       |       | \n");
    printf("|   8   |   9   |   10  |   11  | \n");
    printf("|       |       |       |       | \n");
    printf("--------------------------------- \n");
    printf("|       |       |       |       | \n");
    printf("|   4   |   5   |   6   |   7   | \n");
    printf("|       |       |       |       | \n");
    printf("--------------------------------- \n");
    printf("|       |       |       |       | \n");
    printf("|   0   |   1   |   2   |   3   | \n");
    printf("|       |       |       |       | \n");
    printf("--------------------------------- \n");

    srand(time(NULL));
    int Limit = 15;
    int N = rand() % Limit; // Will generate a number between 1 and 16
    printf("The guess is: %d \n", N);

    for(int i = 0; i <= 15; i++){
        if(i == N){
            printf("Hurrah!, I have found the hidden treasure at: %d", i);
        }
    }
    printf("\n\n");
    
    return 0;
}