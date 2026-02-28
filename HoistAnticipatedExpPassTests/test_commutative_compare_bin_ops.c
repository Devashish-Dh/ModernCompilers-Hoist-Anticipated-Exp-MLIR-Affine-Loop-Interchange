// Focus: Commutative math and comparison normalization.
int test_commutativity_lcse(int a, int b) {
    // Part A: Binary Operator Commutativity
    int sum1 = a + b;
    int sum2 = b + a; // REDUNDANT (if your key hashes operands in sorted order)
    
    int mul1 = a * b;
    int mul2 = b * a; // REDUNDANT
    
    // Part B: Comparison Normalization
    // a < b is logically equivalent to b > a.
    int cmp1 = (a < b);
    int cmp2 = (b > a); // REDUNDANT (if your key normalizes predicates)
    
    return sum1 + sum2 + mul1 + mul2 + cmp1 + cmp2;
}
