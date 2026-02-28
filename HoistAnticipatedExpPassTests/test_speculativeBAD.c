int speculation_safety(int a, int b) {
    int res = 0;
    if (a > 0) {
        res = 100 / b; // Potentially trapping: MUST NOT HOIST
    }
    return res;
}
