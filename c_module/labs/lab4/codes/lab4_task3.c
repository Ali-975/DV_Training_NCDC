#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define N 10

int main(){
    srand(time (NULL));
    int Elements[N];

    for(int i = 0; i < N; i++){
        Elements[i] = rand() % (20 - 1);
    }

    printf("Elements        Value       Histogram\n");
    for(int i = 0; i < N; i++){
        if(Elements[i] < 10){
            printf("   %d              %d         ", i, Elements[i]);
        }else{
            printf("   %d              %d        ", i, Elements[i]);
        }
        for(int j = 0; j < Elements[i]; j++){
            printf("*");
        }
        printf("\n");
    }

    return 0;
}