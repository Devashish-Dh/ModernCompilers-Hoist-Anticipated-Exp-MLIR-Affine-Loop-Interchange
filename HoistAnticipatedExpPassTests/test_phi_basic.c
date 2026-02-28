int phi_example(int a, int b, int c) {
    int result;
    if (c > 10) {
        result = a + b; // Path 1
    } else {
        result = a - b; // Path 2
    }
    // The join point: result depends on which branch was taken
    return result; 
}
