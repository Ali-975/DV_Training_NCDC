#include <stdio.h>

int main (){
    int a = 42;
    int b = 7;
    int c = 999;

    int *t = &c;    // Update t to point c
    int *u = NULL;

    printf("%d %d\n", a, *t);

    c = b;
    u = t;
    printf("%d %d\n", c, *u);

    a = 8;
    b = 8;
    printf("%d %d %d %d\n", b, c, *t, *u);

    *t = 555;   // Use a pointer dereference to change the value of c to 555
    printf("%d %d %d %d %d\n", a, b, c, *t, *u);

    c = 707;    // Change the value of c again using a direct assignment.
    printf("%d %d\n", c, *t);

    // Would happen if you tried to execute the following code? How could you fix it?
    int *v = t;
    printf("%d\n", *v);

    return 0;
}


// int *p = NULL;
    // int x = 5;
    // p = &x;
    // printf("Pointer value of p is %p\n", p);
    // printf("Dereferenced value of p is %d, and x = %d\n", *p, x);