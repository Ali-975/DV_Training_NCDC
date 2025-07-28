#include <stdio.h>
#include <math.h>

int main (){
    float ab, bc, ac;
    float A, B, C;
    int x1, x2, x3, y1, y2, y3;
    printf("Enter the co-ordinates of point a: \n");
    printf("x1 =  ");
    scanf("%d", &x1);

    printf("y1 =  ");
    scanf("%d", &y1);collide with the obstacle
    printf("Enter the co-ordinates of point b: \n");
    printf("x2 =  ");
    scanf("%d", &x2);

    printf("y2 =  ");
    scanf("%d", &y2);

    printf("Enter the co-ordinates of point c: \n");
    printf("x3 =  ");
    scanf("%d", &x3);

    printf("y3 =  ");
    scanf("%d", &y3);

    printf("\n");

    // Calculate the sides of Triangle
    ab = sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2));       //A
    bc = sqrt(pow((x3 - x2), 2) + pow((y3 - y2), 2));       //B
    ac = sqrt(pow((x1 - x3), 2) + pow((y1 - y3), 2));       //C

    if((ab > bc) && (ab > ac)){
        A = pow(ab, 2);
        B = pow(bc, 2);
        C = pow(ac, 2);

        printf(" %.2f", A);
        printf(" %.2f", B);
        printf(" %.2f", C);
        printf("\n");
        printf("\n");

        if(A == (B + C)){
            printf("The Triangle of co-ordinates make a rt angle Triangle \n");
        }
        else{
            printf("No! The Triangle of co-ordinates do not make a rt angle Triangle \n");
        }
    }

    else if((bc > ab) && (bc > ac)){
        A = pow(ab, 2);
        B = pow(bc, 2);
        C = pow(ac, 2);

        printf(" %.2f", A);
        printf(" %.2f", B);
        printf(" %.2f", C);
        printf("\n");
        printf("\n");

        if(B == (A + C)){
            printf("The Triangle of co-ordinates make a rt angle Triangle \n");
        }
        else{
            printf("No! The Triangle of co-ordinates do not make a rt angle Triangle \n");
        }
    }

    else if((ac > bc) && (ac > ab)){
        A = pow(ab, 2);
        B = pow(bc, 2);
        C = pow(ac, 2);

        printf(" %.2f", A);
        printf(" %.2f", B);
        printf(" %.2f", C);
        printf("\n");
        printf("\n");

        if(C == (B + A)){
            printf("The Triangle of co-ordinates make a rt angle Triangle \n");
        }
        else{
            printf("No! The Triangle of co-ordinates do not make a rt angle Triangle \n");
        }
    }

    else{
        printf("No! The Triangle of co-ordinates do not make a rt angle Triangle \n");
    }
    
    return 0;
}