#include <stdio.h>

int main(){
    int num, prev = 0, cur = 1, next;
    printf("How many times you want to print fibonacci series? \n");
    scanf("%d", &num);

    printf("The series is given below. \n");
    printf("%d, ", prev);
    for(int i = 0; i < num; i++){
        next = cur + prev;
        prev = cur;
        cur = next;
        printf("%d, ", prev);
    }
    printf("\n");
    return 0;
}