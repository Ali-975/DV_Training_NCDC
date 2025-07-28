#include <stdio.h>
#include <stdlib.h>

struct Node {
    char desc[100];
    int priority;
    int year;
    int month;
    int day;
    struct Node* next;
};

struct Node* head = NULL;

// Compare the dates
int  compare_dates(int yr1, int mon1, int d1, int yr2, int mon2, int d2) {
    if (yr1 != yr2){
        return yr1 - yr2;
    }
    if (mon1 != mon2){
        return mon1 - mon2;
    }
    else{
        return d1 - d2;
    }
}

// Add
void add(char* desc, int priority, int yr, int mon, int d) {
    struct Node* new_node = (struct Node*)malloc(sizeof(struct Node));
    for (int i = 0; i < 100; i++){
        new_node->desc[i] = desc[i];
    }
    new_node->priority = priority;
    new_node->year = yr;
    new_node->month = mon;
    new_node->day = d;
    new_node->next = NULL;

    if (head == NULL || 
             compare_dates(yr, mon, d, head->year, head->month, head->day) < 0){
        new_node->next = head;
        head = new_node;
    }
    else{
        struct Node* current = head;
        while (current->next != NULL && 
                 compare_dates(yr, mon, d, current->next->year, current->next->month, current->next->day) >= 0){
            current = current->next;
        }
        new_node->next = current->next;
        current->next = new_node;
    }

    printf("The new task is added successfully!\n");
}

// Update
void update(char* desc, int newPriority, int newY, int newM, int newD){
    struct Node *temp = head, *prev = NULL;
    while (temp != NULL){
        int match = 1;
        for (int i = 0; i < 100; i++){
            if (desc[i] != temp->desc[i]){
                match = 0;
                break;
            }
            if (desc[i] == '\0'){
                break;
            }
        }

        if (match){
            // First Remove
            if (prev == NULL){
                head = temp->next;
            }
            else{
                prev->next = temp->next;
            }

            // Update in temp
            temp->priority = newPriority;
            temp->year = newY;
            temp->month = newM;
            temp->day = newD;
            temp->next = NULL;

            // Insert the updated value
            if (head == NULL || 
                     compare_dates(newY, newM, newD, head->year, head->month, head->day) < 0){
                temp->next = head;
                head = temp;
            }
            else{
                struct Node* current = head;
                while (current->next != NULL && 
                         compare_dates(newY, newM, newD, current->next->year, current->next->month, current->next->day) >= 0){
                    current = current->next;
                }
                temp->next = current->next;
                current->next = temp;
            }

            printf("The task is updated successfully!\n");
            return;
        }

        prev = temp;
        temp = temp->next;
    }
    printf("Record not found.\n");
}

// Remove
void delete(char* desc){
    struct Node *temp = head, *prev = NULL;
    while (temp != NULL){
        int match = 1;
        for (int i = 0; i < 100; i++){
            if (desc[i] != temp->desc[i]){
                match = 0;
                break;
            }
            if (desc[i] == '\0'){
                break;
            }
        }

        if (match){
            if (prev == NULL){
                head = temp->next;
            }
            else{
                prev->next = temp->next;
            }
            free(temp);
            printf("The task is removed Successfully!\n");
            return;
        }

        prev = temp;
        temp = temp->next;
    }

    printf("Record not found.\n");
}

// Display
void display(){
    struct Node* current = head;
    if (current == NULL){
        printf("There is no tasks.\n");
        return;
    }

    printf("\n------- Node List -------\n\n");
    while (current != NULL){
        printf("Description: %s\n", current->desc);
        printf("Priority: %d\n", current->priority);
        printf("Due Date: %04d-%02d-%02d\n\n", current->year, current->month, current->day);
        current = current->next;
    }
}

// MAIN
int main(){
    int choice;
    char desc[100];
    int priority, yr, mon, d;

    do{
        printf("\n-------- Task Manager Menu --------:\n");
        printf("Press 1 for Add a New Task.\n");
        printf("Press 2 for Remove task.\n");
        printf("Press 3 for Display task.\n");
        printf("Press 4 for Update task.\n");
        printf("Press 5 for Exit.\n");
        scanf("%d", &choice);
        getchar(); // clear newline

        switch (choice){
            case 1:
                printf("Enter description: ");
                fgets(desc, sizeof(desc), stdin);

                int i = 0;
                while (desc[i] != '\0'){
                    if (desc[i] == '\n'){
                        desc[i] = '\0';
                        break;
                    }
                    i++;
                }

                printf("Enter priority (1=High, 2=Med, 3=Low): ");
                scanf("%d", &priority);

                printf("\nEnter due date (format: YYYY MM DD)\n\n");
                printf("Enter year: ");
                scanf("%d", &yr);
                printf("Enter month: ");
                scanf("%d", &mon);
                printf("Enter day: ");
                scanf("%d", &d);

                add(desc, priority, yr, mon, d);
                break;

            case 2:
                printf("Enter description to remove: ");
                fgets(desc, sizeof(desc), stdin);

                i = 0;
                while (desc[i] != '\0'){
                    if (desc[i] == '\n'){
                        desc[i] = '\0';
                        break;
                    }
                    i++;
                }
                delete(desc);
                break;

            case 3:
                display();
                break;

            case 4:
                printf("Enter description to update: ");
                fgets(desc, sizeof(desc), stdin);
                for (int i = 0; desc[i]; i++){
                    if (desc[i] == '\n'){
                        desc[i] = '\0';
                        break;
                    }
                }

                printf("Enter new priority: ");
                scanf("%d", &priority);

                printf("Enter new due date (YYYY MM DD): ");
                printf("Enter year: ");
                scanf("%d", &yr);
                printf("Enter month: ");
                scanf("%d", &mon);
                printf("Enter day: ");
                scanf("%d", &d);

                update(desc, priority, yr, mon, d);
                break;

            case 5:
                printf("Exiting...\n");
                break;

            default:
                printf("Wrong choice.\n");
        }
    } while (choice != 5);

    return 0;
}