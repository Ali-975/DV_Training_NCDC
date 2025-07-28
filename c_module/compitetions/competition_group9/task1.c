#include <stdio.h>

int check(int Px1, int Py1, int Px2, int Py2, int Px3, int Py3, int Px4, int Py4, int Rx1, int Ry1, int Rx2, int Ry2, int Rx3, int Ry3, int Rx4, int Ry4){

    if((Px1 <= Rx1) && (Px2 >= Rx2) && (Px4 <= Rx4) && (Px3 >= Rx3) && (Py1 >= Ry1) && (Py2 >= Ry2) && (Py4 <= Ry4) && (Py3 <= Ry3)){
        printf("The Rectangle R overlaps Rectangle P.\n");
    }
    
    else
    {
        printf("The Rectangle is not overlap.\n");
    }
    return 0;
}

int main(){
    int x1, y1, x2, y2;
    int l1, l2, w1, w2;
    int len_rect1, len_rect2;
    int wid_rect1, wid_rect2;

    int Px1, Py1, Px2, Py2, Px3, Py3, Px4, Py4;
    int Rx1, Ry1, Rx2, Ry2, Rx3, Ry3, Rx4, Ry4;

    printf("Enter the co-ordinates of 1st rectangle. \n");
    printf("x1: ");
    scanf("%d", &x1);
    printf("y1: ");
    scanf("%d", &y1);
    printf("\n\n");

    printf("Enter the co-ordinates of 2nd rectangle. \n");
    printf("x2: ");
    scanf("%d", &x2);
    printf("y2: ");
    scanf("%d", &y2);
    printf("\n\n");

    printf("\nEnter the Length and Width of 1st rectangle. \n");
    printf("l1: ");
    scanf("%d", &l1);
    printf("w1: ");
    scanf("%d", &w1);
    printf("\n\n");

    printf("\nEnter the Length and Width of 2nd rectangle. \n");
    printf("l2: ");
    scanf("%d", &l2);
    printf("w2: ");
    scanf("%d", &w2);
    printf("\n\n");

    Px1 = x1;
    Py1 = y1;

    Px2 = x1 + w1;
    Py2 = y1;

    Px3 = x1 + w1;
    Py3 = y1 - l1;

    Px4 = x1;
    Py4 = y1 - l1;

    Rx1 = x1;
    Ry1 = y1;

    Rx2 = x1 + w1;
    Ry2 = y1;

    Rx3 = x1 + w1;
    Ry3 = y1 - l1;

    Rx4 = x1;
    Ry4 = y1 - l1;

    printf("%d\n", Px1);
    printf("%d\n", Py1);
    printf("%d\n", Px2);
    printf("%d\n", Py2);
    printf("%d\n", Px3);
    printf("%d\n", Py3);
    printf("%d\n", Px4);
    printf("%d\n", Py4);
    printf("%d\n", Rx1);
    printf("%d\n", Ry1);
    printf("%d\n", Rx2);
    printf("%d\n", Ry2);
    printf("%d\n", Px3);
    printf("%d\n", Ry3);
    printf("%d\n", Rx4);
    printf("%d\n", Ry4);


    check(Px1, Py1, Px2, Py2, Px3, Py3, Px4, Py4, Rx1, Ry1, Rx2, Ry2, Rx3, Ry3, Rx4, Ry4);

    return 0;
}