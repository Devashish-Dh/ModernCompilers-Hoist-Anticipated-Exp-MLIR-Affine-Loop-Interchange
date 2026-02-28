int diamond_hoisting(int a, int b, int c) {
    int result;
    if (c > 0) {
        // (a * b) + 10 is anticipated
        result = (a * b) + 10;
    } else {
        // (a * b) + 10 is anticipated
        result = (a * b) + 10;
    }
    // Result: One 'mul' and one 'add' in the entry block.
    return result;
}
