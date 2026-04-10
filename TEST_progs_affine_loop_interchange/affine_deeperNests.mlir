// 1. Deep 4D Nest: Test exhaustive permutation (24 combinations) and multi-stride-1 hits.
func.func @deep_4d_spatial(%A: memref<64x64x64x64xf64>) {
  affine.for %i = 0 to 64 {
    affine.for %j = 0 to 64 {
      affine.for %k = 0 to 64 {
        affine.for %l = 0 to 64 {
          // %l is stride-1 in access 1 and 3. %j is stride-1 in access 2.
          %0 = affine.load %A[%i, %k, %j, %l] : memref<64x64x64x64xf64>
          %1 = affine.load %A[%i, %k, %l, %j] : memref<64x64x64x64xf64>
          %2 = arith.addf %0, %1 : f64
          affine.store %2, %A[%i, %k, %j, %l] : memref<64x64x64x64xf64>
        }
      }
    }
  }
  return
}

// 2. Skewed Dependency: Legality check for distance vector (1, -1). 
// Interchange [1, 0] must be REJECTED.
func.func @skewed_illegal(%A: memref<100x100xf32>) {
  affine.for %i = 1 to 100 {
    affine.for %j = 0 to 99 {
      %0 = affine.load %A[%i - 1, %j + 1] : memref<100x100xf32>
      affine.store %0, %A[%i, %j] : memref<100x100xf32>
    }
  }
  return
}

// 3. Conflict Parallel vs. Reuse: 
// %i is parallel (outer preference), %j has high temporal reuse (outer preference).
func.func @conflict_reuse_parallel(%arg0: memref<100x100xf32>, %arg1: memref<1xf32>) {
  affine.for %i = 0 to 100 {
    affine.for %j = 0 to 100 {
      %0 = affine.load %arg0[%i, %j] : memref<100x100xf32>
      %1 = affine.load %arg1[0] : memref<1xf32>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %arg1[0] : memref<1xf32>
    }
  }
  return
}

// 4. Complex Nest: Tests Imperfect structure + Triangular Loop detection.
// Your pass should skip the triangular part and optimize the k/l nest.
func.func @complex_mixed_nest(%A: memref<100x100xf32>, %B: memref<100x100xf32>) {
  affine.for %i = 0 to 100 {
    // Triangular loop: Correct Affine syntax
    affine.for %j = 0 to affine_map<(d0) -> (d0)>(%i) { 
      %0 = affine.load %A[%i, %j] : memref<100x100xf32>
      affine.store %0, %B[%i, %j] : memref<100x100xf32>
    }
    // Perfect sub-nest: %k is outer but %l should be inner for stride-1.
    affine.for %k = 0 to 100 {
      affine.for %l = 0 to 100 {
        %1 = affine.load %A[%k, %l] : memref<100x100xf32>
        affine.store %1, %B[%k, %l] : memref<100x100xf32>
      }
    }
  }
  return
}

// 5. 3D Mixed: Test if %k moves outermost due to invariance/temporal reuse.
func.func @test_3d_mixed(%A: memref<100x100x100xf32>, %B: memref<100x100x100xf32>) {
  affine.for %i = 0 to 100 {
    affine.for %j = 0 to 100 {
      affine.for %k = 0 to 100 {
        // %j is stride-1. %k is invariant to the last dimension.
        %0 = affine.load %A[%k, %i, %j] : memref<100x100x100xf32>
        affine.store %0, %B[%k, %i, %j] : memref<100x100x100xf32>
      }
    }
  }
  return
}