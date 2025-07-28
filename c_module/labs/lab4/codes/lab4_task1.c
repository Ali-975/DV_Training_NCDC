#include <stdio.h>
#include <string.h>

int main(){
    char str[100];
    int size = sizeof(str);
    int count;
    int a, e, i, o, u;
    a = e = i = o = u = 0;

    printf("Type any sentence.\n");
    fgets(str, size, stdin);

    int len = strlen(str);
    printf("\nThe length of the sentence is: %d\n", len);

    // Upper Case
    for(int i = 0; i < len; i++){
        if(str[i] >= 'a' && str[i]<= 'z'){
            str[i] = str[i] - 32;
        }
        else{
            str[i] = str[i];
        }
    }
    printf("\nThe sentence in Upper case is:     %s", str);
    
    // Lower Case
    for(int i = 0; i < len; i++){
        if(str[i] >= 'A' && str[i]<= 'Z'){
            str[i] = str[i] + 32;
        }
        else{
            str[i] = str[i];
        }
    }
    printf("\nThe sentence in Lower case is:     %s", str);

    // Word Count
    count = 0;
    for(int i = 0; i < len; i++){
        if(str[i] == ' '){
            count++;
        }
    }
    printf("\nThe words in the sentence :     %d", count + 1);

    // Vowels Count
    count = 0;
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
    return 0;
}