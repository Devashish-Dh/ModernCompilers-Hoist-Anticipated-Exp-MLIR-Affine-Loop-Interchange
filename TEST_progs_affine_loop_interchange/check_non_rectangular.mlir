func.func @triangular_upper(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = 0 to affine_map<(d0) -> (d0)>(%i) {
    }
  }
  return
}

func.func @triangular_lower(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = affine_map<(d0) -> (d0)>(%i) to %N {
    }
  }
  return
}

func.func @self_iv_ok(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = 0 to %N {
    }
  }
  return
}

func.func @deep_non_rect(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = 0 to %N {
      affine.for %k = 0 to affine_map<(d0) -> (d0)>(%j) {
      }
    }
  }
  return
}

func.func @imperfect_rect(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = 0 to 10 {
    }
    affine.for %j = 10 to 20 {
    }
  }
  return
}

// 1. Classic Imperfect Rectangular (Sibling loops with constant/symbolic bounds)
// isPerfectNest: FALSE | isNonRectangular: FALSE
func.func @imperfect_rect_siblings(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = 0 to 10 {
       // Loop J1
    }
    // Intervening code or sibling loop
    affine.for %k = 0 to %N {
       // Loop K
    }
  }
  return
}

// 2. Imperfect Rectangular with Intervening Ops
// isPerfectNest: FALSE | isNonRectangular: FALSE
func.func @imperfect_rect_intervening(%N: index, %A: memref<?xf32>) {
  affine.for %i = 0 to %N {
    %val = affine.load %A[%i] : memref<?xf32>  // Intervening Op
    affine.for %j = 0 to %N {
       affine.store %val, %A[%j] : memref<?xf32>
    }
  }
  return
}

// 3. Imperfect NON-RECTANGULAR (Sibling loop depends on Outer IV)
// isPerfectNest: FALSE | isNonRectangular: TRUE
func.func @imperfect_non_rect(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = 0 to 10 { 
      // Rectangular sibling
    }
    affine.for %k = 0 to affine_map<(d0) -> (d0)>(%i) {
      // NON-RECTANGULAR sibling (depends on %i)
    }
  }
  return
}

// 4. Complex Deep Imperfect Non-Rectangular
// isPerfectNest: FALSE | isNonRectangular: TRUE
func.func @complex_imperfect_non_rect(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = 0 to %N {
       // Inner nest
       affine.for %k = affine_map<(d0) -> (d0)>(%i) to %N {
         // Deep dependency on the root %i
       }
    }
  }
  return
}

// 5. Rectangular with affine.if (Legal structure, but fails 'hasAffineIf' check)
// isPerfectNest: TRUE | isNonRectangular: FALSE | hasAffineIf: TRUE
func.func @rect_with_if(%N: index) {
  affine.for %i = 0 to %N {
    affine.for %j = 0 to %N {
      affine.if affine_set<(d0) : (d0 >= 0)>(%i) {
        // Body
      }
    }
  }
  return
}