#set = affine_set<(d0) : (d0 - 51 >= 0)>
  func.func @nested_if(%arg0: memref<?x100xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    affine.for %arg1 = 0 to 100 {
      affine.for %arg2 = 0 to 100 {
        affine.if #set(%arg1) {
          affine.store %c1_i32, %arg0[%arg1, %arg2] : memref<?x100xi32>
        } else {
          affine.store %c2_i32, %arg0[%arg1, %arg2] : memref<?x100xi32>
        }
      }
    }
    return
  }
