void illegal_interchange(int a[100][100]) {
    for (int i = 1; i < 100; i++) {
        for (int j = 0; j < 100; j++) {
            // This depends on the PREVIOUS row
            a[i][j] = a[i-1][j] + 1;
        }
    }
}