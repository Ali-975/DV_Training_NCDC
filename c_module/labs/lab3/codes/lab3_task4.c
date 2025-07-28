#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){
    srand(time(NULL));
    int Limit = 100;
    int guess;
    char choice;

    int N = rand() % Limit; // Will generate a number between 0 and 100

    int i = 1;
    do{
        printf("Enter attempt # (%d) of your guess: ", i);
        scanf("%d", &guess);
        printf("\n\n");

        if(guess == N){
            printf("Congratulations! You guess it susscessfully.\n");
            return 0;
        }

        else if(guess > N){
            printf("Your Guess Number is greater.\n");
        }

        else if(guess < N){
            printf("Your Guess Number is lesser.\n");
        }

        else{
            printf("Wrong! try again.\n");
        }
        
        printf("\n\n");
        printf("Do you want to guess again (yes/No).\n");
        scanf(" %c", &choice);
        i++;
    }
    while((choice == 'Y') || (choice == 'y'));
    
    return 0;
}