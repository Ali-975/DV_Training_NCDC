#include <stdio.h>
#include <math.h>
#define n 5

int main (){
    char c = 44;
    int num[n];
    int mdn, md;
    int temp, cnt = 1, max = 0;
    float mn, sum = 0;
    double sd;

    // Taking numbers
    for(int i = 0; i < n; i++){
        printf("Enter numbers one by one: \n");
        scanf("%d", &num[i]);
    }

    // Sort the array
    printf("\n");
    printf("Sorted array is\n");

    for(int i = 0; i < n; i++){
        for(int j = i; j < (n - 1); j++){
            if (num[i] > num[j + 1]){
                temp = num[i];
                num[i] = num[j + 1];
                num[j + 1] = temp;
            }
        }
        sum = sum + num[i];
    }

    // Print the sorted array
    for(int j = 0; j < n; j++){
        printf("%d%c ", num[j], c);
    }
    printf("\n");

    // Mean
    mn = sum / n;
    printf("\n");

    // Mode 
    md = num[0];
    for(int i = 0; i < n; i++){
        for(int j = i + 1; j < (n - 1); j++){
            if (num[j] == num[i]){
                cnt++;
            }
        }
        if (max < cnt){
            max = cnt;
            md = num[i];
        }
    }

    //median
    if(n % 2 != 0){     //for odd n
        mdn = num[(n / 2)];
    }
    else{
        mdn = (num[(n / 2)] + num[((n - 1) / 2)]) / 2;
    }

    // Standard Deviation
    for(int i = 0; i < n; i++){
        sd = sd + pow((num[i] - mn), 2);
    }
    sd = sd / n;
    sd = sqrt(sd);

    printf("The mean is. %.2f\n",mn);
    printf("The mode is. %d\n",md);
    printf("The median is. %d\n",mdn);
    printf("The standard Deviation is. %.2lf\n",sd);
    
    return 0;
}