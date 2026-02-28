int test_bitwise_select_lcse(int a, int b, int c) {
    // Bitwise ops are commutative
    int and1 = a & b;
    int and2 = b & a; // REDUNDANT
    
    // Select logic
    // (a > 0 ? b : c)
    int sel1 = (a > 0) ? b : c;
    int sel2 = (a > 0) ? b : c; // REDUNDANT
    
    return and1 ^ and2 ^ sel1 ^ sel2;
}
