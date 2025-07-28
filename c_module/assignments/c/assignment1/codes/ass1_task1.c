#include <stdio.h>
// using namespace std;

int main(){
    int per;
    printf("Enter the grades of student: \n");
    scanf("%d", &per);

    if(per >= 73){
        printf("The student got A grade \n");
    }

    else if(per >= 68 && per < 73){
        printf("The student got B grade \n");
    }

    else if(per >= 63 && per < 68){
        printf("The student got C grade \n");
    }

    else if(per >= 58 && per < 63){
        printf("The student got D grade \n");
    }

    else if(per >= 52 && per < 58){
        printf("The student got E grade \n");
    }

    else if(per >= 47 && per < 52){
        printf("The student got F grade \n");
    }

    else if(per >= 41 && per < 47){
        printf("The student got G grade \n");
    }

    else{
        printf("The student is failed \n");
    }
    return 0;
}