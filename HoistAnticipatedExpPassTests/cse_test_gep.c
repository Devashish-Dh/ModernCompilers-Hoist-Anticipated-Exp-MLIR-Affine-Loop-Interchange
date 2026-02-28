// Focus: Redundant pointer arithmetic for arrays and structs.
struct Point {
    int x, y;
};

void test_gep_lcse(struct Point *p, int *arr, int offset) {
    // Part A: Struct member access
    // LLVM generates a GEP for p->y.
    int *y1 = &p->y;
    int *y2 = &p->y; // REDUNDANT
    
    // Part B: Array indexing
    // LLVM generates a GEP for &arr[offset + 2].
    int *addr1 = &arr[offset + 2];
    int *addr2 = &arr[offset + 2]; // REDUNDANT
    
    // Only one GEP for p->y and one for arr[offset+2] should remain.
    *y1 = 10;
    *y2 = 20; 
    *addr1 = 100;
    *addr2 = 200;
}
