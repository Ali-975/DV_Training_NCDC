#include <stdio.h>
#include <math.h>

int main(){
    int course;
    int t_cd_hrs, sum_t_cd_hrs = 0;

    float GPA;
    float e_cd_hrs, sum_e_cd_hrs = 0;

    printf("Enter the number of Courses: \n");
    scanf("%d", &course);

    for(int i = 0; i < course; i++){
        printf("Enter the credit hours of Course # %d\n", i+1);
        scanf("%d", &t_cd_hrs);
        sum_t_cd_hrs = sum_t_cd_hrs + t_cd_hrs;

        printf("How much credit hours you earned in the Course # %d\n", i+1);
        scanf("%f", &e_cd_hrs);
        sum_e_cd_hrs = sum_e_cd_hrs + e_cd_hrs;
    }
    
    GPA = (sum_e_cd_hrs / sum_t_cd_hrs) * 4;
    printf("Your GPA is %f\n", GPA);

    return 0;
}