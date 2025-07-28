#include <stdio.h>
#define t 12

int main(){
    // int t;
    float avg = 0;

    // printf("How many digitized signals you want to enter:     \n");
    // scanf("%d", &t);

    float v[t];

    v[0] = 0.25;
    v[1] = 0.5;
    v[2] = 0.1;
    v[3] = 1.0;
    v[4] = 0.75;
    v[5] = 0.5;
    v[6] = -0.5;
    v[7] = -0.2;
    v[8] = -0.75;
    v[9] = -1.0;
    v[10] = -0.75;
    v[11] = -0.5;

    // // Initialize
    // for(int i = 0; i < t; i++){
    //     v[i] = 0;
    // }

    // // Take input signals
    // printf("Enter the digitized signals one by one.\n");
    // for(int i = 0; i < t; i++){
    //     printf("\nEnter the value at signal [%d]:     ", i+1);
    //     scanf("%f", &v[i]);
    // }

    // Part-2 Calculate DC average
    for(int i = 0; i < t; i++){
        avg += v[i];
    }
    avg = avg / t;
    printf("\n\nThe Average is:  %.2f\n", avg);

    // Part-3 Check the X-axis cross?
    if((v[0] >= 0) && (v[1] > 0)){
        for(int i = 0; i < t; i++){
            if(v[i] < 0){
                printf("\nThe signal crosses the x-axis at x = [%d].\n", i);
                goto next;
            }
            // else{
            //     printf("\nThe signal is +ve & above the x-axis.\n");
            // }
        }
        printf("\nThe signal is +ve & above the x-axis.\n");
    }
    else{
        for(int i = 0; i < t; i++){
            if(v[i] > 0){
                printf("\nThe signal crosses the x-axis at x = [%d].\n", i);
                goto next;
            }
            // else{
            //     printf("\nThe signal is -ve & below the x-axis.\n");
            // }
        }
        printf("\nThe signal is -ve & below the x-axis.\n");
    }

    next:
    printf("\n");
    // Part-4
    for(int i = 0; i < t; i++){
        if(v[i] > 0){
            if((v[i] < v[i-1] && v[i+1] > v[i-1])){
                printf("There is a glitch at t = (%d).\n", i);
            }
        }

        else{
            if(v[i] > v[i+1] && v[i] > v[i-1]){
                printf("There is a glitch at t = (%d).\n", i);
            }
        }
    }

    return 0;
}