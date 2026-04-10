void nested_if(int a[100][100]) {
    for (int i = 0; i < 100; i++) {
        for (int j = 0; j < 100; j++) {
            if (i > 50) {
                a[i][j] = 1;
            } else {
                a[i][j] = 2;
            }
        }
    }
}