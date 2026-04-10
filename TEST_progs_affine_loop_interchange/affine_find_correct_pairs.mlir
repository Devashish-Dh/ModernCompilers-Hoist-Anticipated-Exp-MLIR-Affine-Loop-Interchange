
  func.func @triple_nest(%arg0: memref<?x100x100xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    affine.for %arg1 = 0 to 100 {
      affine.for %arg2 = 0 to 100 {
        affine.for %arg3 = 0 to 100 {
          affine.store %c0_i32, %arg0[%arg1, %arg2, %arg3] : memref<?x100x100xi32>
        }
      }
    }
    return
  }
