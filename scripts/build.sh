#!/usr/bin/env bash
# scripts/build.sh - Generate a Watch Face Studio .wfs file
# This script compresses the contents of the src/ folder into a zip,
# then appends the required 16-byte validation tail ("normal_watchface")
# to produce a valid .wfs file.

set -euo pipefail

PROJECT_NAME="DuelingBatteries"                 # Name of your watch face project
SRC_DIR="$(dirname "$0")/../src"                # Source folder containing project files
BUILD_DIR="$(dirname "$0")/../build"            # Destination folder for output files
ZIP_FILE="${BUILD_DIR}/${PROJECT_NAME}.zip"     # Intermediate zip file
WFS_FILE="${BUILD_DIR}/${PROJECT_NAME}.wfs"     # Final output file
TAIL_FILE="${BUILD_DIR}/validation-tail.bin"    # Temporary file for the validation tail

# -------------------------------
# Step 0: Clean build directory
# -------------------------------
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# -------------------------------
# Step 1: Compress source files into zip archive
# Important: zip the *contents* of src/, not the folder itself,
# so that project.json and assets are at the root of the archive.
# -------------------------------
(cd "$SRC_DIR" && zip -r "$ZIP_FILE" .)

# -------------------------------
# Step 2: Generate the validation tail dynamically
# Write the ASCII string "normal_watchface" as raw bytes into tail.bin.
# -------------------------------
echo -n "normal_watchface" > "$TAIL_FILE"

# -------------------------------
# Step 3: Concatenate the zip + tail into the final .wfs
# Using cat for binary concatenation.
# -------------------------------
cat "$ZIP_FILE" "$TAIL_FILE" > "$WFS_FILE"

echo "Built \"$WFS_FILE\" successfully."