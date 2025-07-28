#include <stdio.h>
#include <string.h>

int length(char *str){
    int len = strlen(str);
    return len;
}

void to_upper(char *str, int len){
    for(int i = 0; i < len; i++){
        if(str[i] >= 'a' && str[i]<= 'z'){
            str[i] = str[i] - 32;
        }
        else{
            str[i] = str[i];
        }
    }
    printf("\nThe sentence in Upper case is:     %s", str);
}

void to_lower(char *str, int len){
    for(int i = 0; i < len; i++){
        if(str[i] >= 'A' && str[i]<= 'Z'){
            str[i] = str[i] + 32;
        }
        else{
            str[i] = str[i];
        }
    }
    printf("\nThe sentence in Lower case is:     %s", str);
}

int word_count(char *str, int len){
    int count = 0;
    for(int i = 0; i < len; i++){
        if(str[i] == ' '){
            count++;
        }
    }
    return count;
}

void vowel_count(char *str, int len){
    int a, e, i, o, u;
    a = e = i = o = u = 0;
    int count = 0;

    for(int i = 0; i < len; i++){
        if(str[i] == 'a' || str[i] == 'e' || str[i] == 'i' || str[i] == 'o' || str[i] == 'u'){
            count++;
        }

        if(str[i] == 'a'){
            a++;
        }
        else if(str[i] == 'e'){
            e++;
        }
        else if(str[i] == 'i'){
            i++;
        }
        else if(str[i] == 'o'){
            o++;
        }
        else if(str[i] == 'u'){
            u++;
        }
    }
    printf("\nThe vowels in the sentence:     %d", count);
    printf("\nOcurrence of a:    %d\n", a);
    printf("Ocurrence of e:    %d\n", e);
    printf("Ocurrence of i:    %d\n", i);
    printf("Ocurrence of o:    %d\n", o);
    printf("Ocurrence of u:    %d\n", u);
}

int main(){
    char str[100];
    int size = sizeof(str);

    printf("Type any sentence.\n");
    fgets(str, size, stdin);

    // Length of string
    int len = length(str);
    printf("\nThe length of the sentence is: %d\n", len);

    // Upper Case
    to_upper(str, len);
    
    // Lower Case
    to_lower(str, len);

    // Word Count
    int count = word_count(str, len);
    printf("\nThe words in the sentence :     %d", count + 1);

    // Vowels Count
    vowel_count(str, len);

    return 0;
}