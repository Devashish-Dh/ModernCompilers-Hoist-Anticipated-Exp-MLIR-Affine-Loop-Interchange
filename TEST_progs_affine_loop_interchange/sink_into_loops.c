void multiple_pesky(int a[100][100], int b[100]) {
    for (int i = 0; i < 100; i++) {
        // These two live in the "Outer" block
        int factor = b[i]; 
        int threshold = i + 10; 

        for (int j = 0; j < 100; j++) {
            if (j < threshold) {
                a[i][j] *= factor;
            }
        }
    }
}