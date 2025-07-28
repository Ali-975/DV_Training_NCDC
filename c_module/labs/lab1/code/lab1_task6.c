#include <stdio.h>
#include <math.h>

int main(){
    double a, b, c;

    printf("Enter the value a: \n");
    scanf("%lf", &a);

    printf("Enter the value b: \n");
    scanf("%lf", &b);

    printf("Enter the value c: \n");
    scanf("%lf", &c);

    // double max = pow(b, a) ;
    double max = (-b + (pow(((b * b) - (4 * a * c)), 0.5) )) / (2 * a);
    double min = (-b - (pow(((b * b) - (4 * a * c)), 0.5) )) / (2 * a);
    
    printf("The min value is: %f \n", min);
    printf("The max value is: %lf \n", max);

    return 0;
}