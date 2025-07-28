#include <stdio.h>
#include <stdlib.h>

struct Node {
    int value;
    struct Node* next;
};

void add(struct Node** head_ref, int value){
    struct Node* newNode = newNode = (struct Node*)malloc(sizeof(struct Node));

    if(newNode == NULL){
        printf("Memory allocation failed.\n");
        exit(1);
    }

    newNode->value = value;
    newNode->next = NULL;
    
    if(*head_ref == NULL){
        *head_ref = newNode;
    }

    else{
        struct Node* current = *head_ref;

        while(current->next != NULL){
            current = current->next;
        }

        current->next = newNode;
    }
}

void display(struct Node* head){
    while(head != NULL){
        printf("%d", head->value);
        if (head->next != NULL) printf(" -> ");
        head = head->next;
    }
    printf("\n");
}

struct Node* merge(struct Node* list1, struct Node* list2) {
    if (list1 == NULL) return list2;
    if (list2 == NULL) return list1;

    struct Node* merged = list1;
    struct Node* current = list1;

    while(current->next != NULL){
        current = current->next;
    }

    current->next = list2;

    return merged;
}

void sort(struct Node* head) {
    if(head == NULL){
        return;
    }

    int swapped;
    struct Node* head_ptr;
    struct Node* list_ptr = NULL;

    do {
        swapped = 0;
        head_ptr = head;

        while(head_ptr->next != list_ptr){
            if(head_ptr->value > head_ptr->next->value){  // Swap the value
                int temp = head_ptr->value;

                head_ptr->value = head_ptr->next->value;
                head_ptr->next->value = temp;
                swapped = 1;
            }
            head_ptr = head_ptr->next;
        }
        list_ptr = head_ptr;
    } while (swapped);
}

struct Node* merge_and_sort(struct Node* list1, struct Node* list2){
    struct Node* merged = merge(list1, list2);
    sort(merged);
    return merged;
}

int main() {
    int n1, n2, value;
    struct Node* list1 = NULL;
    struct Node* list2 = NULL;

    printf("\nEnter number of elements in List 1: ");
    scanf("%d", &n1);

    for(int i = 0; i < n1; i++){
        printf("Enter element %d of List 1: ", i + 1);
        scanf("%d", &value);
        add(&list1, value);
    }

    printf("\nEnter number of elements in List 2: ");
    scanf("%d", &n2);

    for(int i = 0; i < n2; i++){
        printf("Enter element %d of List 2: ", i + 1);
        scanf("%d", &value);
        add(&list2, value);
    }

    printf("\nList 1: ");
    display(list1);
    printf("List 2: ");
    display(list2);

    struct Node* mer_sort = merge_and_sort(list1, list2);

    printf("\nMerged and Sorted List: ");
    display(mer_sort);
    printf("\n");

    return 0;
}