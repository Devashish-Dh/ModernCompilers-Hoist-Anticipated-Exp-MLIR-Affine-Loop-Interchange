int nested_bubbling(int a, int b, int n) {
    int sum = 0;
    // 'a * b' is invariant for all three loops.
    // It should end up in the outermost preheader.
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            for (int k = 0; k < n; k++) {
                sum += (a * b) + k;
            }
        }
    }
    sum += (a * b);
    return sum;
}
