  func.func @illegal_interchange(%arg0: memref<?x100xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i32 = arith.constant 1 : i32
    affine.for %arg1 = 1 to 100 {
      affine.for %arg2 = 0 to 100 {
        %0 = affine.load %arg0[%arg1 - 1, %arg2] : memref<?x100xi32>
        %1 = arith.addi %0, %c1_i32 : i32
        affine.store %1, %arg0[%arg1, %arg2] : memref<?x100xi32>
      }
    }
    return
  }
