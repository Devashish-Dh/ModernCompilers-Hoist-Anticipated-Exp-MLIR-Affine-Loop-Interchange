int cse_phi_example(int a, int b, int c) {
    int x, y;
    if (c > 10) {
        // Common expression 1
        x = a * b; 
        y = x + 10;
    } else {
        // Common expression 2
        x = a * b; 
        y = x + 20;
    }
    // 'a * b' is anticipated in the entry block.
    // Your pass should hoist 'a * b' to the entry block.
    return y;
}
