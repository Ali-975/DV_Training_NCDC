#include <stdio.h>
#include <time.h>
#include <stdlib.h>
// #define N 10

// Function to take the matrice values
void input_matrix(int R, int C, int M[R][C]){
    for(int i = 0; i < R; i++){
        for(int j = 0; j < C; j++){
            printf("Enter the Row # (%d) and Cloumn # (%d):   ", i+1, j+1);
            scanf("%d", &M[i][j]);
        }
    }
}

// Calculate Resultant Matrices
void matrix_mul(int M, int N, int K, int R[M][K], int A[M][N], int B[N][K]){
    for(int i = 0; i < M; i++){
        for(int j = 0; j < K; j++){
            for(int k = 0; k < N; k++){
                R[i][j] += (A[i][k] * B[k][j]);
            }
        }
    }
}

int main(){
    int M, N, K = 1;

    printf("Enter the Rows and Column for matrix A.\n");
    printf("\nEnter the Rows (M):   ");
    scanf("%d", &M);
    printf("Enter the Column (N):   ");
    scanf("%d", &N);

    int A[M][N], B[N][K], R[M][K];

    printf("\nEnter the values of matrix A.\n");
    input_matrix(M, N, A);

    printf("\nEnter the values of matrix B.\n");
    input_matrix(N, K, B);

    // Initialize the Resultant to zero to avoid garbage value
    for(int i = 0; i < M; i++){
        for(int j = 0; j < K; j++){
            R[i][j] = 0;
        }
    }
    printf("\n");

    // Calculate Resultant Matrices
    matrix_mul(M, N, K, R, A, B);

    // Print Resultant Matrices
    printf("\nThe Resultant vector is.\n\n");
    for(int i = 0; i < M; i++){
        for(int j = 0; j < K; j++){
            if(R[i][j] < 9){
                printf("%d    ", R[i][j]);
            }
            else if(R[i][j] < 99){
                printf("%d   ", R[i][j]);
            }
            else if(R[i][j] < 999){
                printf("%d  ", R[i][j]);
            }
            else{
                printf("%d      ", R[i][j]);
            }
        }
        printf("\n\n");
    }

    return 0;
}