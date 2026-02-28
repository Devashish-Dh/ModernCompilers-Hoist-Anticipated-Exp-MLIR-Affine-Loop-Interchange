; ModuleID = 'GIVEN_TESTS.ll'
source_filename = "GIVEN_TESTS.ll"

; Function Attrs: nounwind uwtable
define dso_local i32 @simple_if_else(i32 noundef %0, ptr noundef %1) #0 {
  %3 = icmp ugt i32 %0, 2
  %hoisted.1 = mul i32 %0, %0
  %hoisted.2 = add i32 %hoisted.1, %0
  %hoisted.3 = add i32 %hoisted.2, 5
  br i1 %3, label %4, label %5

4:                                                ; preds = %2
  br label %6

5:                                                ; preds = %2
  br label %6

6:                                                ; preds = %5, %4
  %7 = phi i32 [ %hoisted.3, %4 ], [ %hoisted.3, %5 ]
  ret i32 %7
}

; Function Attrs: nounwind uwtable
define dso_local i32 @simple_if_else_multiple(i32 noundef %0, ptr noundef %1) #0 {
  %3 = icmp ugt i32 %0, 3
  %hoisted.1 = mul i32 %0, %0
  %hoisted.2 = add i32 %hoisted.1, %0
  %hoisted.3 = add i32 %hoisted.2, 5
  br i1 %3, label %4, label %5

4:                                                ; preds = %2
  br label %9

5:                                                ; preds = %2
  %6 = icmp ugt i32 %0, 2
  br i1 %6, label %7, label %8

7:                                                ; preds = %5
  br label %9

8:                                                ; preds = %5
  br label %9

9:                                                ; preds = %8, %7, %4
  %10 = phi i32 [ %hoisted.3, %4 ], [ %hoisted.3, %7 ], [ %hoisted.3, %8 ]
  ret i32 %10
}

; Function Attrs: nounwind uwtable
define dso_local i32 @if_else_memory(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  %7 = load i32, ptr %4, align 4
  store i32 %7, ptr %6, align 4
  %8 = load i32, ptr %6, align 4
  %9 = icmp ugt i32 %8, 2
  br i1 %9, label %10, label %17

10:                                               ; preds = %2
  %11 = load i32, ptr %6, align 4
  %12 = load i32, ptr %6, align 4
  %13 = mul i32 %11, %12
  %14 = load i32, ptr %6, align 4
  %15 = add i32 %13, %14
  %16 = add i32 %15, 5
  store i32 %16, ptr %6, align 4
  br label %24

17:                                               ; preds = %2
  %18 = load i32, ptr %6, align 4
  %19 = load i32, ptr %6, align 4
  %20 = mul i32 %18, %19
  %21 = load i32, ptr %6, align 4
  %22 = add i32 %20, %21
  %23 = add i32 %22, 3
  store i32 %23, ptr %6, align 4
  br label %24

24:                                               ; preds = %17, %10
  %25 = load i32, ptr %6, align 4
  ret i32 %25
}

; Function Attrs: nounwind uwtable
define dso_local i32 @for_loop_invariant_expr(i32 noundef %0, ptr noundef %1) #0 {
  %hoisted.1 = mul nsw i32 %0, %0
  br label %3

3:                                                ; preds = %8, %2
  %4 = phi i32 [ 0, %2 ], [ %10, %8 ]
  %5 = icmp ult i32 %4, 10
  br i1 %5, label %8, label %6

6:                                                ; preds = %3
  %7 = srem i32 %hoisted.1, %0
  ret i32 %7

8:                                                ; preds = %3
  %9 = srem i32 %hoisted.1, %0
  %10 = add i32 %4, 1
  br label %3
}

; Function Attrs: nounwind uwtable
define dso_local i32 @switch(i32 noundef %0, ptr noundef %1) #0 {
  %hoisted.0 = mul i32 %0, %0
  %hoisted.1 = add i32 %hoisted.0, %0
  %hoisted.2 = add i32 %hoisted.1, 3
  switch i32 %0, label %5 [
    i32 0, label %3
    i32 1, label %3
    i32 2, label %4
    i32 3, label %4
  ]

3:                                                ; preds = %2, %2
  br label %6

4:                                                ; preds = %2, %2
  br label %6

5:                                                ; preds = %2
  br label %6

6:                                                ; preds = %5, %4, %3
  %7 = phi i32 [ %hoisted.2, %5 ], [ %hoisted.2, %4 ], [ %hoisted.2, %3 ]
  ret i32 %7
}

; Function Attrs: nounwind memory(none)
declare dso_local double @exp(double noundef) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @if_else_math_call(i32 noundef %0, ptr noundef %1) #0 {
  %3 = icmp ugt i32 %0, 3
  %hoisted.1 = mul i32 %0, %0
  %hoisted.3 = uitofp i32 %0 to double
  %hoisted.31 = uitofp i32 %hoisted.1 to double
  br i1 %3, label %4, label %9

4:                                                ; preds = %2
  %5 = call double @exp(double noundef %hoisted.3) #2
  %6 = fadd double %hoisted.31, %5
  %7 = fadd double %6, 5.000000e+00
  %8 = fptoui double %7 to i32
  br label %21

9:                                                ; preds = %2
  %10 = icmp ugt i32 %0, 2
  br i1 %10, label %11, label %16

11:                                               ; preds = %9
  %12 = call double @exp(double noundef %hoisted.3) #2
  %13 = fadd double %hoisted.31, %12
  %14 = fadd double %13, 3.000000e+00
  %15 = fptoui double %14 to i32
  br label %21

16:                                               ; preds = %9
  %17 = call double @exp(double noundef %hoisted.3) #2
  %18 = fadd double %hoisted.31, %17
  %19 = fadd double %18, 1.000000e+00
  %20 = fptoui double %19 to i32
  br label %21

21:                                               ; preds = %16, %11, %4
  %22 = phi i32 [ %8, %4 ], [ %15, %11 ], [ %20, %16 ]
  ret i32 %22
}

; Function Attrs: nounwind uwtable
define dso_local i32 @if_else_multiple_redundant_exprs(i32 noundef %0, ptr noundef %1) #0 {
  %3 = icmp ugt i32 %0, 2
  %hoisted.1 = mul i32 %0, %0
  %hoisted.2 = add i32 %hoisted.1, %0
  br i1 %3, label %4, label %7

4:                                                ; preds = %2
  %5 = add i32 %hoisted.2, 5
  %6 = add i32 %5, 5
  br label %9

7:                                                ; preds = %2
  %8 = add i32 %hoisted.2, 3
  br label %9

9:                                                ; preds = %7, %4
  %10 = phi i32 [ %6, %4 ], [ %hoisted.1, %7 ]
  %11 = phi i32 [ %5, %4 ], [ %8, %7 ]
  %12 = add i32 %11, %10
  ret i32 %12
}

define dso_local i32 @not_anticipated_for_loop(i32 noundef %0, ptr noundef %1) {
  br label %3

3:                                                ; preds = %8, %2
  %4 = phi i32 [ undef, %2 ], [ %10, %8 ]
  %5 = phi i32 [ 0, %2 ], [ %11, %8 ]
  %6 = icmp ult i32 %5, 10
  br i1 %6, label %8, label %7

7:                                                ; preds = %3
  ret i32 %4

8:                                                ; preds = %3
  %9 = mul nsw i32 %0, %0
  %10 = srem i32 %9, %0
  %11 = add i32 %5, 1
  br label %3, !llvm.loop !0
}

define dso_local i32 @not_anticipated_switch(i32 noundef %0, ptr noundef %1) {
  switch i32 %0, label %8 [
    i32 0, label %3
    i32 1, label %3
    i32 2, label %3
  ]

3:                                                ; preds = %2, %2, %2
  %4 = urem i32 %0, 2
  %5 = mul i32 %4, %4
  %6 = add i32 %5, %4
  %7 = add i32 %6, 3
  br label %12

8:                                                ; preds = %2
  %9 = mul i32 %0, %0
  %10 = add i32 %9, %0
  %11 = add i32 %10, 2
  br label %12

12:                                               ; preds = %8, %3
  %13 = phi i32 [ %11, %8 ], [ %7, %3 ]
  ret i32 %13
}

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind memory(none) "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind }

!0 = !{!1, !1, i64 0}
!1 = !{!"int", !2, i64 0}
!2 = !{!"omnipotent char", !3, i64 0}
!3 = !{!"Simple C/C++ TBAA"}
