module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @nested_if(%arg0: memref<?x100xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c100 = arith.constant 100 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    %c50_i32 = arith.constant 50 : i32
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %0 = arith.index_cast %arg1 : index to i32
      scf.for %arg2 = %c0 to %c100 step %c1 {
        %1 = arith.cmpi sgt, %0, %c50_i32 : i32
        scf.if %1 {
          memref.store %c1_i32, %arg0[%arg1, %arg2] : memref<?x100xi32>
        } else {
          memref.store %c2_i32, %arg0[%arg1, %arg2] : memref<?x100xi32>
        }
      }
    }
    return
  }
}
