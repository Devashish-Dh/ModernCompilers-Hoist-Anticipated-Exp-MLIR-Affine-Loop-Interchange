func.func @bad_stride_nest(%arg0: memref<100x100xi32>) {
  %c0 = arith.constant 0 : i32
  // Loop 0: %arg1
  affine.for %arg1 = 0 to 100 {
    // Loop 1: %arg2
    affine.for %arg2 = 0 to 100 {
      // BAD: The inner loop IV (%arg2) is NOT in the last dimension.
      // The outer loop IV (%arg1) IS in the last dimension.
      affine.store %c0, %arg0[%arg2, %arg1] : memref<100x100xi32>
    }
  }
  return
}


func.func @test_spatial_swap(%arg0: memref<100x100xf32>) {
  %f0 = arith.constant 0.0 : f32
  // %arg1 should move INNER because it is Stride-1 for %arg0
  affine.for %arg1 = 0 to 100 {
    affine.for %arg2 = 0 to 100 {
      affine.store %f0, %arg0[%arg2, %arg1] : memref<100x100xf32>
    }
  }
  return
}

func.func @test_temporal_vs_spatial(%arg0: memref<100x100xf32>, %arg1: memref<100xf32>) {
  affine.for %i = 0 to 100 {
    affine.for %j = 0 to 100 {
      %val = affine.load %arg0[%i, %j] : memref<100x100xf32>
      // %i is INVARIANT for this load, %j is STRIDE-1 for the other
      affine.store %val, %arg1[%i] : memref<100xf32>
    }
  }
  return
}

func.func @test_parallel_reduction(%arg0: memref<100x100xf32>, %arg1: memref<1xf32>) {
  // Loop %i is parallel. Loop %j is a serial reduction.
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

func.func @the_kitchen_sink(%A: memref<100x100xf32>, %B: memref<100x100xf32>, %C: memref<100x100xf32>, %V: memref<100xf32>) {
  affine.for %i = 0 to 100 {
    affine.for %j = 0 to 100 {
      // Access 1: %j is Stride-1
      %a = affine.load %A[%i, %j] : memref<100x100xf32>
      
      // Access 2: %i is Stride-1 (Swapped!)
      %b = affine.load %B[%j, %i] : memref<100x100xf32>
      
      // Access 3: %i and %j are both used, but %j is Stride-1
      %c = arith.addf %a, %b : f32
      affine.store %c, %C[%i, %j] : memref<100x100xf32>
      
      // Access 4: %j is INVARIANT here
      %v = affine.load %V[%i] : memref<100xf32>
    }
  }
  return
}