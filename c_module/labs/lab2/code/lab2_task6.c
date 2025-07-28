#include <stdio.h>
#include <math.h>

int main(){
    int x1, x2, y1, y2;
    char dir;

    // Initial Position of a player
    printf("Enter the co-ordinates of initial point. \n");
    printf("x1 =  ");
    scanf("%d", &x1);

    printf("y1 =  ");
    scanf("%d", &y1);

    // Obstacle Position
    printf("Enter the co-ordinates of obstacle. \n");
    printf("x2 =  ");
    scanf("%d", &x2);

    printf("y2 =  ");
    scanf("%d", &y2);

    // The Position player want to move
    int i = 0;
    while(i == 0){
        printf("Enter the direction you want to go... \n");
        scanf(" %c", &dir);

        switch(dir){
            case 'u':       //If the Player goes up
                x1 = x1;
                y1 = y1 - 1;
                break;

            case 'd':       //If the Player goes down
                x1 = x1;
                y1 = y1 + 1;
                break;

            case 'l':       //If the Player goes left
                x1 = x1 - 1;
                y1 = y1;
                break;

            case 'r':       //If the Player goes right
                x1 = x1 + 1;
                y1 = y1;
                break;

            default:
                break;
        }

        // Player Exceed the Boundary
        if ((x1 == 0) || (y1 == 0) || (x1 == 5) || (y1 == 5)){
            printf("Sorry You exceed the boundary. \n");
            printf("Game Over \n");
            return 0;
        }

        // Player Hit the Obstacle
        else if((x1 == x2) && (y1 == y2)){
            printf("Sorry You collide with the obstacle. \n");
            printf("Game Over \n");
            return 0;
        }

        // Player go the correct direction
        else{
            printf("Next move\n");
        }
            
    }
    return 0;
}