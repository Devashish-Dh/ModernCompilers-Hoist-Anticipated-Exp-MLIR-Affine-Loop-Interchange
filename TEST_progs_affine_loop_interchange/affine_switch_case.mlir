  func.func @switch_test(%arg0: i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %c30_i32 = arith.constant 30 : i32
    %c20_i32 = arith.constant 20 : i32
    %c10_i32 = arith.constant 10 : i32
    cf.switch %arg0 : i32, [
      default: ^bb1(%c0_i32 : i32),
      1: ^bb1(%c10_i32 : i32),
      2: ^bb1(%c20_i32 : i32),
      3: ^bb1(%c30_i32 : i32)
    ]
  ^bb1(%0: i32):  // 4 preds: ^bb0, ^bb0, ^bb0, ^bb0
    return %0 : i32
  }
