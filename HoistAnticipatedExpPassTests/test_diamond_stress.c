int global_stress_test(int a, int b, int c) {
    int x, y;

    // Both branches compute 'a * b'
    if (c > 10) {
        // Path A: 'a * b' is computed here
        x = a * b;
        y = x + 5; 
    } else {
        // Path B: 'a * b' is computed here too
        // BUT: we redefine 'a' first.
        // This should KILL the 'a * b' anticipated from entry!
        a = c + 1; 
        x = a * b;
        y = x - 2;
    }

    // The result of 'a * b' is used again here
    return y + (a * b);
}
