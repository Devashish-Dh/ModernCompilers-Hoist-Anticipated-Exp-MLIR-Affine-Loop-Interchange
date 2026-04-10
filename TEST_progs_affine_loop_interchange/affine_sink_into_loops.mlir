#set = affine_set<(d0, d1) : (-d0 + d1 + 9 >= 0)>
  func.func @multiple_pesky(%arg0: memref<?x100xi32>, %arg1: memref<?xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    affine.for %arg2 = 0 to 100 {
      %0 = affine.load %arg1[%arg2] : memref<?xi32>
      affine.for %arg3 = 0 to 100 {
        affine.if #set(%arg3, %arg2) {
          %1 = affine.load %arg0[%arg2, %arg3] : memref<?x100xi32>
          %2 = arith.muli %1, %0 : i32
          affine.store %2, %arg0[%arg2, %arg3] : memref<?x100xi32>
        }
      }
    }
    return
  }
