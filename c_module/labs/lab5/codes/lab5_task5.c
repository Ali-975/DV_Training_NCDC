#include <stdio.h>
#define t 12

float average(float v[]){
    float avg = 0;
    for(int i = 0; i < t; i++){
        avg += v[i];
    }
    avg = avg / t;
    return avg;
}

int z_crossings(float v[]) {
    int count = 0;
    for (int i = 0; i < (t - 1); i++) {
        if ((v[i] < 0  && v[i + 1] >= 0) ||
            (v[i] >= 0 && v[i + 1] < 0)) {
            count++;
        }
    }
    return count;
}

int glitch(float v[]) {
    int count = 0;

    for(int i = 0; i < t; i++){
        if(v[i] > 0){
            if((v[i] < v[i-1] && v[i+1] > v[i-1])){
                printf("There is a glitch at t = (%d).\n", i);
                count++;
            }
        }

        else{
            if(v[i] > v[i+1] && v[i] > v[i-1]){
                printf("There is a glitch at t = (%d).\n", i);
                count++;
            }
        }
    }

    return count;
}

void filt_sig(float v[], float tran_func[], float fil_v[]) {
    for (int i = 0; i < t; i++) {
        fil_v[i] = 0.0;
        for (int j = 0; j < 3; j++) {
            if (i - j >= 0) {
                fil_v[i] += v[i - j] * tran_func[j];
            }
        }
    }
}

int main(){
    // int t;
    float avg = 0;

    // printf("How many digitized signals you want to enter:     \n");
    // scanf("%d", &t);

    float v[t];
    float fil_v[t] = {0};
    float tran_func[3];

    tran_func[0] = 0.25;
    tran_func[1] = 0.5;
    tran_func[2] = 0.25;

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

    // Part-1 Calculate DC average
    avg = average(v);
    printf("\n\nThe Average is:  %.2f\n", avg);

    // Part-2 Check the X-axis cross?
    int count = z_crossings(v);
    printf("\nThe signal crosses the x-axis %d times.\n", count);
    printf("\n");
    
    // Part-3
    count = 0;
    count = glitch(v);
    printf("\nThere are %d number of glitches.\n", count);
    printf("\n");

    // Prt-4
    filt_sig(v, tran_func, fil_v);
    printf("Filtered signal:\n");
    for (int i = 0; i < t; i++) {
        printf("%.2f ", fil_v[i]);
    }
    printf("\n\n");

    return 0;
}