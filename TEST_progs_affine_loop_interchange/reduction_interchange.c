void reduction_interchange(int a[100][100], int* sum) {
    for (int i = 0; i < 100; i++) {
        for (int j = 0; j < 100; j++) {
            // Accessing same 'sum' pointer every time
            *sum += a[i][j];
        }
    }
}