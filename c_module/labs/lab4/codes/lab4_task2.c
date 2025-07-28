#include <stdio.h>
#define N 3

int main(){
    int a, b, x[N], y[N], dot[N] = {0,0,0};

    printf("Enter the scallar values.\n");
    printf("\nEnter the value of a:   ");
    scanf("%d", &a);
    printf("\nEnter the value of b:   ");
    scanf("%d", &b);

    printf("\nEnter the Vector values.\n");
    for(int i = 0; i < N; i++){
        printf("\nEnter the value of x[%d]:   ", i+1);
        scanf("%d", &x[i]);
        printf("\nEnter the value of y[%d]:   ", i+1);
        scanf("%d", &y[i]);
    }

    for(int i = 0; i < N; i++){
        dot[i] = (a * x[i]) + (b * y[i]);
        printf("%d, ", dot[i]);
    }
    printf("\n\n");

    return 0;
}