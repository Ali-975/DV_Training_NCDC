#include <stdio.h>
#define y 5
#define x 5

int pix_count(int pix[3]){
    int type = 10;

    if(pix[0] == 0 && pix[1] == 0 && pix[2] == 0 ){ //Black
        type = 0;
    }

    else if(pix[0] == 255 && pix[1] == 255 && pix[2] == 255 ){   //White
        type = 1;
    }

    else if(pix[0] == 255 && pix[1] == 255 && pix[2] == 0 ){ //Yellow
        type = 2;
    }

    else{
        type = 3;
    }

    return type;
}

void rgb_to_grey(int img[x][y][3], int grey[x][y]) {
    for (int i = 0; i < x; i++) {
        for (int j = 0; j < y; j++) {
            int r = img[i][j][0];
            int g = img[i][j][1];
            int b = img[i][j][2];
            grey[i][j] = (0.299 * r) + (0.587 * g) + (0.114 * b);
        }
    }
}

void convolve(float filt_img[x][y], int grey[x][y], float H[3][3]){
    int pad[x + 2][y + 2] = {0};

    // Added zero in the boundary
    for(int i = 1; i <= x; i++){
        for(int j = 1; j <= y; j++){
            pad[i][j] = grey[i - 1][j - 1];
        }
    }

    // Print the padded img
    printf("\n\n*********After zero padding*********\n\n");
    for(int i = 0; i <= (x + 1); i++){
        for(int j = 0; j <= (y + 1); j++){
            printf("%5d", pad[i][j]);
        }
        printf("\n");
    }

    // calculate the filter image
    for(int i = 1; i <= (x); i++){
        for(int j = 1; j <= (y); j++){
            filt_img[i - 1][j - 1] = (
                (pad[i - 1][j - 1]  * H[0][0]) + (pad[i - 1][j] * H[0][1])  + (pad[i - 1][j + 1]    * H[0][2]) +
                (pad[i][j - 1]      * H[1][0]) + (pad[i][j]     * H[1][1])  + (pad[i][j + 1]        * H[1][2]) +
                (pad[i + 1][j - 1]  * H[2][0]) + (pad[i + 1][j] * H[2][1])  + (pad[i + 1][j + 1]    * H[2][2]) 
            );
        }
    }
}

int main(){
    int clr_img[x][y][3] = {
        {{255, 0, 0},   {0, 255, 0},   {0, 0, 255},   {255, 255, 0}, {0, 255, 255}},
        {{255, 0, 255}, {128, 128, 128}, {255, 128, 0}, {0, 128, 255}, {128, 0, 255}},
        {{64, 64, 64}, {192, 192, 192}, {32, 32, 32}, {100, 200, 50}, {150, 50, 200}},
        {{0, 0, 0},   {255, 255, 255}, {100, 100, 255}, {255, 100, 100}, {100, 255, 100}},
        {{50, 100, 150}, {150, 100, 50}, {200, 200, 200}, {25, 75, 125}, {175, 25, 75}}
    };

    int grey_img[x][y];
    float filt_img[x][y];
    // float H[3][3] = {{1/9, 1/9, 1/9}, {1/9, 0, 1/9}, {1/9, 1/9, 1/9}};
    float H[3][3] = {
                {1/9.0, 1/9.0, 1/9.0},
                {1/9.0, 1/9.0, 1/9.0},
                {1/9.0, 1/9.0, 1/9.0}
            };

    // Part-1 Pixel Types
    int wh_count = 0, bl_count = 0, ye_count = 0;

    for(int i = 0; i < x; i++){
        for(int j = 0; j < y; j++){
            int type = pix_count(clr_img[i][j]);
            if(type == 0){
                bl_count++;
            }

            else if(type == 1){
                wh_count++;
            }

            else if(type == 2){
                ye_count++;
            }

            else{
                // printf("\nOthers.\n");
            }
        }
    }
    printf("\nOccurrence of Black pixels = %d\n", bl_count);
    printf("Occurrence of White pixels = %d\n", wh_count);
    printf("Occurrence of Yellow pixels = %d\n", ye_count);

    // Part-2 RGB to Gray
    rgb_to_grey(clr_img, grey_img);

    // Print the gray image
    printf("\n\n*****Gray Scale Image*****\n\n");
    for(int i = 0; i < x; i++){
        for(int j = 0; j < y; j++){
            printf("%5d", grey_img[i][j]);
        }
        printf("\n");
    }

    // Part-3 Convolution
    convolve(filt_img, grey_img, H);

    //Print the filtered image
    printf("\n\n*************Filtered Image*************\n\n");
    for(int i = 0; i < x; i++){
        for(int j = 0; j < y; j++){
            printf("%8.2f", filt_img[i][j]);
        }
        printf("\n");
    }
    printf("\n");

    return 0;
}

