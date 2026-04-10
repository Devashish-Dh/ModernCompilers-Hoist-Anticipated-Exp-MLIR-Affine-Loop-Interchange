void triangular(int a[100][100]) {
    for (int i = 0; i < 100; i++) {
        for (int j = 0; j < i; j++) { // j depends on i
            a[i][j] = i + j;
        }
    }
}