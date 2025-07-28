#include <stdio.h>
#define P 10 // Even Number

int main(){
    // int eco[5] = {0, 0, 0, 0, 0};
    // int fcl[5] = {0, 0, 0, 0, 0};
    int eco[P/2];
    int fcl[P/2];
    int plane[P];
    int a, type;
    char seat, choice, buy;;
    int status = 0, estatus = 0, fstatus = 0;

    // Initializing plane is empty/ has no reservation
    for(int i = 0; i < P; i++){
        plane[i] = 0;
    }

    // Assigning the seats to Economy section and First Class section
    for(int i = 0; i < P; i++){
        if(i < (P / 2)){
            eco[i] = plane[i];
        }
        else{
            fcl[i - P/2] = plane[i];
        }
    }

    // Plane Outlook
    printf("\n\n    Plane Outlook\n\n");
    for(int i = 0; i < 11; i++){
        if((i == 1) || (i == 6)){
            printf("----------"); printf("------------ \n");
            printf("|       |  "); printf("          | \n");
            printf("|   %d   |  ", i); printf("          | \n");
            printf("|       |  "); printf("          | \n");
        }

        else if((i % 2 == 0) && (i > 1) && (i < 5)){
            printf("--------|  "); printf("  |-------- \n");
            printf("|       |  "); printf("  |       | \n");
            printf("|   %d   |  ", i); printf("  |   %d   | \n",i+1);
            printf("|       |  "); printf("  |       | \n");
        }

        else if((i % 2 != 0) && (i > 6) && (i < 10)){
            printf("--------|  "); printf("  |-------- \n");
            printf("|       |  "); printf("  |       | \n");
            printf("|   %d   |  ", i); printf("  |   %d   | \n",i+1);
            printf("|       |  "); printf("  |       | \n");
        }

        if(i == 4){
            printf("---------    --------- \n");
            printf("|                    | \n");
            printf("|                    | \n");
            printf("|                    | \n");
        }
    }
    printf("---------------------- \n\n\n");

    // // Plane Outlook
    // printf("Plane Outlook\n\n\n");
    // printf("---------------------- \n");
    // printf("|       |            | \n");
    // printf("|   1   |            | \n");
    // printf("|       |            | \n");
    // printf("--------|    |-------- \n");
    // printf("|       |    |       | \n");
    // printf("|   2   |    |   3   | \n");
    // printf("|       |    |       | \n");
    // printf("--------|    |-------- \n");
    // printf("|       |    |       | \n");
    // printf("|   4   |    |   5   | \n");
    // printf("|       |    |       | \n");
    // printf("---------    --------- \n");
    // printf("|                    | \n");
    // printf("|                    | \n");
    // printf("|                    | \n");
    // printf("---------    --------- \n");
    // printf("|       |            | \n");
    // printf("|   6   |            | \n");
    // printf("|       |            | \n");
    // printf("--------|    |-------- \n");
    // printf("|       |    |       | \n");
    // printf("|   7   |    |   8   | \n");
    // printf("|       |    |       | \n");
    // printf("--------|    |-------- \n");
    // printf("|       |    |       | \n");
    // printf("|   9   |    |   10  | \n");
    // printf("|       |    |       | \n");
    // printf("---------------------- \n");

    // Ticket Booking
    do{
        // Select the Type of flight
        printf("Please select the type of flight.\n");
        printf("Press 1 for first class.\n");
        printf("Press 2 for economy.\n");
        scanf("%d", &type);
        
        //==========================================================================
        //=======================E C O N O M Y ==== S E A T S=======================
        //==========================================================================
        if(type == 2){
            economy_class:
            // Select the seats
            printf("Do you want any perticular seat (Yes/No).\n");
            scanf(" %c", &seat);

            // For Particular Seat selection
            if((seat == 'y') || (seat == 'Y')){
                printf("Please select the seat from 1 to 5.\n");
                scanf("%d", &a);

                if((a >= 0) && (a <= 5)){
                    if(eco[a - 1] == 1){
                        printf("The seat is already reserved.\n");
                        goto skip;
                    }

                    else{
                        printf("You have successfuly booked the seat number (%d).\n", a);
                        eco[a - 1] = 1;

                        printf("_________________________________________________ \n");
                        printf("|          B O A R D I N G    P A S S           | \n");
                        printf("|                                               | \n");
                        printf("|    Seat No: (%d)           Type: ECONOMY       | \n", a);
                        printf("|                                               | \n");
                        printf("|_______________________________________________| \n");
                        goto skip;
                    }    printf("|       |            | \n");
                    printf("|   1   |            | \n");
                    printf("|       |            | \n");
                }

                else{
                    printf("Wrong Selection of Seat.\n");
                    goto skip;
                }
            }

            // For automatic Seat selection
            else{
                for(int i=0; i<5; i++){
                    status = i + 1;
                    if(eco[i] == 0){
                        printf("You have successfuly booked the seat number (%d).\n", i+1);
                        eco[i] = 1;

                        printf("_________________________________________________ \n");
                        printf("|          B O A R D I N G    P A S S           | \n");
                        printf("|                                               | \n");
                        printf("|    Seat No: (%d)           Type: ECONOMY       | \n", eco[i]);
                        printf("|                                               | \n");
                        printf("|_______________________________________________| \n");

                        goto skip;
                    }
                    else if(status == 5){
                        printf("\nSorry! The Economy Class section has no seat left.\n");
                        
                        if(fstatus == 0){
                            printf("\nWould you like to take seat in First Class.\n");
                            scanf(" %c", &choice);

                            estatus = 1;

                            if((choice == 'y') || (choice == 'Y')){
                                goto first_class;
                            }

                            else{
                                printf("\nNext flight leaves in 3 hours.\n");
                            }
                        }

                        else{
                            printf("\nNext flight leaves in 3 hours.\n");
                        }
                    }
                }
            }
        }

        //==========================================================================
        //==================F I R S T ==== C L A S S ==== S E A T S=================
        //==========================================================================
        else if(type == 1){
            first_class:
            // Select the seats
            printf("Do you want any perticular seat (Yes/No).\n");
            scanf(" %c", &seat);

            // For Particular Seat selection
            if((seat == 'y') || (seat == 'Y')){
                printf("Please select the seat from 1 to 5.\n");
                scanf("%d", &a);

                if((a >= 0) && (a <= 5)){
                    if(fcl[a - 1] == 1){
                        printf("The seat is already reserved.\n");
                        goto skip;
                    }
                    else{
                        printf("You have successfuly booked the seat number (%d).\n", a);
                        fcl[a - 1] = 1;

                        printf("_________________________________________________ \n");
                        printf("|          B O A R D I N G    P A S S           | \n");
                        printf("|                                               | \n");
                        printf("|    Seat No: (%d)           Type: FIRST CLASS   | \n", a);
                        printf("|                                               | \n");
                        printf("|_______________________________________________| \n");
                        
                        goto skip;
                    }
                }
                else{
                    printf("\n\nWrong Selection of Seat.\n");
                    goto skip;
                }
            }

            // For automatic Seat selection
            else{
                for(int i=0; i<5; i++){
                    status = i + 1;
                    if(fcl[i] == 0){
                        printf("You have successfuly booked the seat number (%d).\n", i+1);
                        fcl[i] = 1;

                        printf("_________________________________________________ \n");
                        printf("|          B O A R D I N G    P A S S           | \n");
                        printf("|                                               | \n");
                        printf("|    Seat No: (%d)           Type: FIRST CLASS   | \n", fcl[i]);
                        printf("|                                               | \n");
                        printf("|_______________________________________________| \n");

                        goto skip;
                    }
                    else if(status == 5){
                        printf("\nSorry! The First Class section has no seat left.\n");

                        if(estatus == 0){
                            printf("\nWould you like to take seat in Economy Class.\n");
                            scanf(" %c", &choice);

                            fstatus = 1;

                            if((choice == 'y') || (choice == 'Y')){
                                goto economy_class;
                            }

                            else{
                                printf("\nNext flight leaves in 3 hours.\n");
                            }
                        }

                        else{
                            printf("\nNext flight leaves in 3 hours.\n");
                        }
                    }
                }
            }
        }

        else{
            printf("\n\nWrong choice.\n");
            
            return 0;
        }
        skip:
        printf("\n\nThe seating chart Now\n");

        printf("\nThe Economy Class Seats.\n");
        for(int i = 0; i < 5; i++){
            printf("%d, ",eco[i]);
        }

        printf("\n\nThe First Class Seats.\n");
        for(int i = 0; i < 5; i++){
            printf("%d, ",fcl[i]);
        }
        printf("\n\n");

        printf("\nDo you want to continue buying.\n");
        scanf(" %c", &buy);
    }while((buy == 'Y') || (buy == 'y'));

    return 0;
}