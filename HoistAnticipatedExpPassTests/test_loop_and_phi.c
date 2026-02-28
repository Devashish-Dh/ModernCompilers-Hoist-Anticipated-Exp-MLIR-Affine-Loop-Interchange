int loop_phi_mixed(int a, int b, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        int inv = a * b;    // Should hoist to preheader
        int var = i * a;    // Depends on PHI: Should stay in loop
        sum += inv + var;
    }
    int j = a * b;
    return sum;
}
