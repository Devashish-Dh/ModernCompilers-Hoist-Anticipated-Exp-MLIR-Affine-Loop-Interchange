#!/bin/bash

# Define the absolute path to your cgeist
CGEIST_BIN="/media/data/devashish/Polygeist/build/bin/cgeist"

for c_file in *.c; do
    # Skip if no C files are found
    [ -e "$c_file" ] || continue
    
    # Get filename without extension
    name="${c_file%.*}"
    
    echo "Processing $c_file..."

    # 1. Generate the SCF version (Standard lowering)
    $CGEIST_BIN "$c_file" -S -O0 > "scf_$name.mlir"
    
    # 2. Generate the Affine version (Raised lowering)
    $CGEIST_BIN "$c_file" -S -O0 --raise-scf-to-affine > "affine_$name.mlir"

    echo "Done: created scf_$name.mlir and affine_$name.mlir"
done

echo "------------------------------------------------"
echo "Generation complete."