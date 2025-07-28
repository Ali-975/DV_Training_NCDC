#include <stdio.h>

int main(){
    int N, bin;
    int status;

    printf("Enter the width of the bytes i.e (0-8). \n");
    scanf("%d", &N);

    int s_byt[N];
    int r_byt[N];

    printf("\n\n");
    // Sender's sending packet
    printf("To send the packet generate checksum of (%d) bytes. \n", N);
    printf("Enter from LSB -----> MSB. \n");
    for(int i = 0; i < N; i++){
        printf("Enter (%d) byte: ", i);
        scanf("%d", &s_byt[i]);
    }

    printf("\n\n");
    // Reciever's recieving packet
    printf("To recieve the packet enter checksum of (%d) bytes. \n", N);
    printf("Enter from LSB -----> MSB. \n");
    for(int i = 0; i < N; i++){
        printf("Enter (%d) byte: ", i);
        scanf("%d", &r_byt[i]);
    }
    printf("\n\n");

    //Checking the checksum
    for(int i = 0; i < N; i++){
        if(r_byt[i] == s_byt[i]){
            status = 0;
        }
        else{
            status = 1;
            printf("Warning! the checksum do not match.\n");
            return 0;
        }
    }
    printf("Congratulations! The packet deliver susscessfully.\n");

    return 0;
}