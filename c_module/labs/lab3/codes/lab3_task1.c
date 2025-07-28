#include <stdio.h>
#define N 5

int main(){
    float st_rt, avg;
    int min, max, cent = 0;
    int runs[N], balls[N];
    float t_runs = 0, t_balls = 0;
    char nout;
    int nout_cnt = 0;

    printf("Enter the last %d records of Babar Azam.\n", N);

    for(int i = 0; i < N; i++){
        printf("%d innings Run: ", i + 1);
        scanf("%d", &runs[i]);
        t_runs += runs[i];

        printf("Balls faced: ", i + 1);
        scanf("%d", &balls[i]);
        t_balls += balls[i];

        printf("Is this a Notout Inning (Yes/No): ");
        scanf(" %c", &nout);

        if((nout == 'Y') || (nout == 'y')){
            nout_cnt++;
        }
    }
    printf("\n\n");

    // Calculate Centuries
    for(int i = 0; i < N; i++){
        if(runs[i] >= 100){
            cent++;
        }
    }

    //Calculate Max Score
    max = runs[0];
    for(int i = 0; i < (N - 1); i++){
        if(runs[i] > runs[i + 1]){
            max = runs[i];
        }
    }

    //Calculate Min Score
    min = runs[0];
    for(int i = 0; i < (N - 1); i++){
        if(runs[i] < runs[i + 1]){
            if(min > runs[i+1]){
                min = runs[i + 1];
            }
        }
    }

    // Calculate Strike Rate
    st_rt = (t_runs / t_balls) * 100;

    // Calculate Batting Average
    avg = (t_runs / (N - nout_cnt));

    printf("The Strike Rate of Babar Azam is %.2f \n", st_rt);
    printf("The batting average of Babar Azam is %.2f \n", avg);
    printf("The minimum score of Babar Azam is %d \n", min);
    printf("The maximum score of Babar Azam is %d \n", max);
    printf("Babar Azam scored (%d) number of centuries. \n", cent);
    return 0;
}