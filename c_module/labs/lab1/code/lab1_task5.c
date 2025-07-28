#include <stdio.h>

int main(){
    float v1, r1, r2, r3; // assume the values
    float i1, i2, i3; // calculate the values
    float v2; // Node V2 value

    printf("Enter the Voltage V1: \n");
    scanf("%f", &v1);

    printf("Enter the current i1: \n");
    scanf("%f", &r1);

    printf("Enter the current i2: \n");
    scanf("%f", &r2);

    printf("Enter the current i3: \n");
    scanf("%f", &r3);

    // v1 = 12;
    // r1 = 4;
    // r2 = 6;
    // r3 = 3;

    v2 = v1 / (1 + (r1 / r2) + (r1/r3));

    i1 = (v1 - v2) / r1;
    i2 = v2 / r2;
    i3 = v2 / r3;

    printf("The Nodal Voltage are: %f \n", v2);
    printf("The current i1 is: %f \n", i1);
    printf("The current i1 is: %f \n", i2);
    printf("The current i1 is: %f \n", i3);
    return 0;
}