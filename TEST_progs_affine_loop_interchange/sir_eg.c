  affine.for %i = 0 to %N {
    affine.for %j = 0 to %M {
      %v = affine.load %A[%j, %i] : memref<?x?xf32>
      %vd = arith.addf %v, %v : f32
      affine.store %vd, %A[%j, %i] : memref<?x?xf32>
    }
  }