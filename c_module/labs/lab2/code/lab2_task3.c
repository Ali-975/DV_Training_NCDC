#include <stdio.h>

int main (){
    int num;
    int un, tn, hd;
    printf("Enter a 3 digit number: \n");
    scanf("%d", &num);

    un = num % 10;
    tn = (num / 10) % 10;
    hd = (num / 100) % 100;

    printf("The unit is. %d\n",un);
    printf("The ten is. %d\n",tn);
    printf("The hundred is. %d\n",hd);
    
    return 0;
}