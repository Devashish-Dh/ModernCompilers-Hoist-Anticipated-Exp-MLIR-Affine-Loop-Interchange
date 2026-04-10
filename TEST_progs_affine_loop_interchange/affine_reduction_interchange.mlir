  func.func @reduction_interchange(%arg0: memref<?x100xi32>, %arg1: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    affine.for %arg2 = 0 to 100 {
      affine.for %arg3 = 0 to 100 {
        %0 = affine.load %arg0[%arg2, %arg3] : memref<?x100xi32>
        %1 = affine.load %arg1[0] : memref<?xi32>
        %2 = arith.addi %1, %0 : i32
        affine.store %2, %arg1[0] : memref<?xi32>
      }
    }
    return
  }
