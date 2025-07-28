#include <stdio.h>
#include "bit_ops.h"

/* Returns the Nth bit of X. Assumes 0 <= N <= 31. */
unsigned get_bit(unsigned x, unsigned n) {
    int a = (x >> n) & 1;
    /* YOUR CODE HERE */
    return a /* UPDATE WITH THE CORRECT RETURN VALUE*/
}

/* Set the nth bit of the value of x to v. Assumes 0 <= N <= 31, and V is 0 or 1 */
void set_bit(unsigned *x, unsigned n, unsigned v) {
    if (v == 0){
        *x = *x & ~(v << n);
    }
    else{
        *x = *x | (v << n);
    }
    /* YOUR CODE HERE */
}

/* Flips the Nth bit in X. Assumes 0 <= N <= 31.*/
void flip_bit(unsigned *x, unsigned n) {
    *x = *x ^ (1 << n);
    /* YOUR CODE HERE */
}

