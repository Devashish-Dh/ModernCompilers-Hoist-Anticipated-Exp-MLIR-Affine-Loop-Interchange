#include <math.h>
#include <stdio.h>

void function_call_hoisting(int cond, double x) {
    if (cond > 10) {
        double range = exp(x); // Pure: Should hoist to entry
        printf("High: %f\n", range);
    } else {
        double range = exp(x); // Pure: Should hoist to entry
        printf("Low: %f\n", range);
    }
}
