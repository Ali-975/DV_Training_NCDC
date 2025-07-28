#include <stdio.h>
#include <math.h>

float Grav(float a, float b, float c){
    float k = 6.67e-8;
    float F = (k * (a * b)) / (c * c);
    return F;
}

int main (){
    float F, M1, M2, d;

    printf("Enter mass M1: \n");
    scanf("%f", &M1);

    printf("Enter mass M2: \n");
    scanf("%f", &M2);

    printf("Enter distance d: \n");
    scanf("%f", &d);

    F = Grav(M1, M2, d);

    printf("The Force F = %.15f", F);

    return 0;
}