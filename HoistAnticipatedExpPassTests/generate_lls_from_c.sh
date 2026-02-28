#!/usr/bin/env bash

# Constants
OUTPUT_DIR="./ll_test_cases"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "Generating cleaned LLVM IR (SSA form)..."

for c_file in *.c; do
    # Ensure file exists
    [[ -f "$c_file" ]] || continue

    # Define output paths
    base_name=$(basename "$c_file" .c)
    raw_ll="$OUTPUT_DIR/${base_name}_raw.ll"
    target_ll="$OUTPUT_DIR/$base_name.ll"

    echo "Processing: $c_file"

    # 1. Generate Raw IR (has alloca/load/store)
    clang -S -emit-llvm -O0 -Xclang -disable-O0-optnone -fno-discard-value-names "$c_file" -o "$raw_ll"

    # 2. Run mem2reg to promote memory to registers (SSA form)
    # This is what makes your CSE logic actually work.
    opt -passes="mem2reg" -S "$raw_ll" -o "$target_ll"

    # Optional: Remove the raw file to keep the directory clean
    rm "$raw_ll"
done

echo "Process complete. Files located in $OUTPUT_DIR"
