#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main(){
    srand(time (NULL));

    int room[30];
    int x = 6, y = 5;
    int limit = x * y;
    int rob = rand() % (limit - 1);
    char choice;

    printf("Enter the direction of the robot you want to move. \n");
    printf("North up \n");
    printf("West left \n");
    printf("East  right \n");
    printf("South down \n");

    // printf("NE \n");
    // printf("SE \n");
    // printf("SW \n");
    // printf("NW \n");
    scanf(" %c", &choice);

    // DOWN
    while((rob != 0) || (rob != 1) || (rob != 2) || (rob != 3) || (rob != 4) || (rob != 5)){
        if((rob == 0) || (rob == 1) || (rob == 2) || (rob == 3) || (rob == 4) || (rob == 5)){
            if((choice == 'u') || (choice == 'U')){
                printf("Wrong Direction.\n");
            }

            else{
                rob = room[rob - 6];
            }
        }
    }

    // UP
    while((rob != 24) || (rob != 25) || (rob != 26) || (rob != 27) || (rob != 28) || (rob != 29)){
        if((rob == 24) || (rob == 25) || (rob == 26) || (rob == 27) || (rob == 28) || (rob == 29)){
            if((choice == 'u') || (choice == 'U')){
                printf("Wrong Direction.\n");
            }

            else{
                rob = room[rob + 6];
            }
        }
    }
    

    // RIGHT
    while((rob == 5) || (rob == 11) || (rob == 19) || (rob == 23) || (rob == 29)){
        if((rob == 5) || (rob == 11) || (rob == 19) || (rob == 23) || (rob == 29)){
            if((choice == 'r') || (choice == 'R')){
                printf("Wrong Direction.\n");
            }
            else{
                rob = room[rob + 1];
            }
        }
    }

    // LEFT
    while((rob == 0) || (rob == 6) || (rob == 12) || (rob == 18) || (rob == 24)){
        if((rob == 0) || (rob == 6) || (rob == 12) || (rob == 18) || (rob == 24)){
            if((choice == 'r') || (choice == 'R')){
                printf("Wrong Direction.\n");
            }
            else{
                rob = room[rob - 1];
            }
        }
    }

    return 0;
}