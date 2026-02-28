// Compile with: clang -S -emit-llvm -O0 -Xclang -disable-O0-optnone
// Focus: verifies if BinaryOperators and Casts are collapsed.

float test_lcse_logic(int a, int b, float f_a, float f_b) {
    // Integer subexpressions
    int i1 = a + b;
    int i2 = a + b; // REDUNDANT
    int i3 = i1 * i2;
    int i4 = a + b; // REDUNDANT
    
    // Floating point subexpressions
    float f1 = f_a * f_b;
    float f2 = f_a * f_b; // REDUNDANT
    
    // Cast subexpressions
    float c1 = (float)i1;
    float c2 = (float)i1; // REDUNDANT
    
    // Your pass should leave only 1 add, 1 fmul, and 1 sitofp
    return (float)i4 + f2 + c2 + (float)i3;
}
