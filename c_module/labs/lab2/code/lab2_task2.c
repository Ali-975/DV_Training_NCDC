#include <stdio.h>

int main (){
    char c = 44;
    float lati, longi;
    int deg, min, sec;
    //Take Inputs of Latitude
    printf("Enter the Latitude: \n");
    printf("Enter the Latitude's degree: \n");
    scanf("%d", &deg);
    printf("Enter the Latitude's minutes: \n");
    scanf("%d", &min);
    printf("Enter the Latitude's seconds: \n");
    scanf("%d", &sec);

    //Calculate the Latitude
    lati = deg + (min / 60) + (sec / 3600);

    //Take Inputs of Longitude
    printf("Enter the Longitude: \n");
    printf("Enter the Longitude's degree: \n");
    scanf("%d", &deg);
    printf("Enter the Longitude's minutes: \n");
    scanf("%d", &min);
    printf("Enter the Longitude's seconds: \n");
    scanf("%d", &sec);

    //Calculate the Longitude
    longi = deg + (min / 60) + (sec / 3600);

    printf("Your co-ordinates are: %f%c%f\n", lati, c, longi);

    if (lati > 0){
        printf("The location is above the equator \n");
    }
    else if (lati == 0){
        printf("The location is on the equator \n");
    }
    else{
        printf("The location is below the equator \n");
    }
    return 0;
}