#include <stdio.h>

int main(){
    int age, piz;
    char exe;

    printf("Enter your age: \n");
    scanf("%d", &age);

    printf("Enter your pizza intake per week: \n");
    scanf("%d", &piz);

    printf("Do you exercise daily: \n");
    printf("For Yes Press 'Y' \n");
    printf("For No Press 'N' \n");
    scanf(" %c", &exe);

    if(age >= 20 && age < 25){
        if(exe == 'N'  || exe == 'n'){
            if(piz < 3){
                printf("You are fit. \n");
            }
            else{
                printf("You are Unfit \n");
            }
        }
        else{
            printf("You are Unfit \n");
        }
    }

    else if(age >= 25 && age < 35){
        if(exe == 'Y'  || exe == 'y'){
            if(piz < 7){
                printf("You are fit. \n");
            }
            else{
                printf("You are Unfit \n");
            }
        }
        else{
            printf("You are Unfit \n");
        }
    }

    else if(age >= 35 && age < 40){
        if(exe == 'N'  || exe == 'n'){
            if(piz == 0){
                printf("You are fit. \n");
            }
            else{
                printf("You are Unfit \n");
            }
        }
        else{
            printf("You are Unfit \n");
        }
    }

    else if(age >= 40 && age < 50){
        if(exe == 'Y'  || exe == 'y'){
            if(piz < 4){
                printf("You are fit. \n");
            }
            else{
                printf("You are Unfit \n");
            }
        }
        else{
            printf("You are Unfit \n");
        }
    }

    else{
        if(exe == 'Y'  || exe == 'y'){
            if(piz == 0){
                printf("You are fit. \n");
            }
            else{
                printf("You are Unfit \n");
            }
        }
        else{
            printf("You are Unfit \n");
        }
    }

    return 0;
}