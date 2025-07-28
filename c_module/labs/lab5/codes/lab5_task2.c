#include <stdio.h>
#define N 3

void vector(int vec[][N], char c, int row, int col){
    for(int i = 0; i < row; i++){
        for(int j = 0; j < col; j++){
            printf("Enter the Row # (%d) and Column # (%d):   ", i+1, j+1);
            scanf("%d", &vec[i][j]);
        }
    }
}

void axby(int dot[][N], int x[][N], int y[][N], int a, int b){
    for(int i = 0; i < N; i++){
        dot[0][i] = (a * x[0][i]) + (b * y[0][i]);
    }
}

void dot_prod(int DOT[N][N], int X[N][N], int Y[N][N]){
    int Xt[N][N];
    for(int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            Xt[j][i] = X[i][j] ;
        }
    }

    for(int i = 0; i < N; i++){
        for(int j = 0; j < N; j++){
            DOT[i][j] = 0;
            for(int k = 0; k < N; k++){
                DOT[i][j] += (Xt[i][k] * Y[k][j]);
            }
        }
    }
}

int main(){
    int a, b, x[1][N], y[1][N], dot[1][N] = {0};
    int X[N][N], Y[N][N], DOT[N][N] = {0};
    char c;
    int choice;

    printf("Enter the scallar values.\n");
    printf("\nEnter the value of a:   ");
    scanf("%d", &a);
    printf("\nEnter the value of b:   ");
    scanf("%d", &b);

    printf("\n\nPress 0 for axby and Press 1 for dot product.\n");
    scanf("%d", &choice);

    // ax[N] + by[N]
    if(choice == 0){
        printf("\n\nEnter the Vector X values.\n");
        c = 'x';
        vector(x, c, 1, N);

        printf("\n\nEnter the Vector Y values.\n");
        c = 'y';
        vector(y, c, 1, N);

        axby(dot, x, y, a, b);
        printf("\n\nThe dot product is given below.\n");
        for(int i = 0; i < N; i++){
            printf("%d, ", dot[0][i]);
        }
    }
    else{
        printf("\n\nEnter the Vector X values.\n");
        c = 'x';
        vector(X, c, N, N);

        printf("\n\nEnter the Vector Y values.\n");
        c = 'y';
        vector(Y, c, N, N);

        dot_prod(DOT, X, Y);

        for(int i = 0; i < N; i++){
            for(int j = 0; j < N; j++){
                printf("%d, ", DOT[i][j]);
            }
            printf("\n\n");
        }
    }
    
    printf("\n\n");

    return 0;
}