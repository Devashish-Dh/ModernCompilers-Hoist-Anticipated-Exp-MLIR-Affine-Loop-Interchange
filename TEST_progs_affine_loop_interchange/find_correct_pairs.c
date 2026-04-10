void triple_nest(int a[100][100][100]) {
    for (int k = 0; k < 100; k++) {
        // Gap 1: Is it empty?
        for (int i = 0; i < 100; i++) {
            // Gap 2: Is it empty?
            for (int j = 0; j < 100; j++) {
                a[k][i][j] = 0;
            }
        }
    }
}