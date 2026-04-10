#map = affine_map<(d0) -> (d0)>
  func.func @triangular(%arg0: memref<?x100xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    affine.for %arg1 = 0 to 100 {
      %0 = arith.index_cast %arg1 : index to i32
      affine.for %arg2 = 0 to #map(%arg1) {
        %1 = arith.index_cast %arg2 : index to i32
        %2 = arith.addi %0, %1 : i32
        affine.store %2, %arg0[%arg1, %arg2] : memref<?x100xi32>
      }
    }
    return
  }
