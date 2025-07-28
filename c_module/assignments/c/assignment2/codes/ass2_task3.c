#include <stdio.h>

int main(){
    int pr, typ;

    printf("Enter the types of toys.\n");
    scanf("%d", &typ);

    if(2 >= typ){
        printf("Warning! Enter number greater than 2. \n");
        return 0;
    }

    else{
        pr = (typ * (typ - 1)) / 2;
    }
    printf("There are (%d) pairs of (%d) types.\n", pr, typ);
    return 0;
}