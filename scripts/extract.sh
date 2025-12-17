#!/usr/bin/env bash
# scripts/extract.sh - Reverse process for Watch Face Studio .wfs files
# This script takes a .wfs file, removes the 16-byte validation tail
# ("normal_watchface"), and extracts the contents into the src/ folder.

set -euo pipefail

PROJECT_NAME="DuelingBatteries"                # Name of your watch face project
SRC_DIR="$(dirname "$0")/../src"               # Destination folder for extracted files
BUILD_DIR="$(dirname "$0")/../build"           # Source folder containing .wfs file
WFS_FILE="${BUILD_DIR}/${PROJECT_NAME}.wfs"    # Input .wfs file as modified by Watch Face Studio
ZIP_FILE="${BUILD_DIR}/${PROJECT_NAME}.zip"    # Temporary zip file without tail


# -------------------------------
# Step 0: Check for required .wfs file
# -------------------------------
if [ ! -f "$WFS_FILE" ]; then
  echo "Error: $WFS_FILE not found. Did you run build.sh first?"
  exit 1
fi

# -------------------------------
# Step 1: Strip the 16-byte validation tail
# Use head to remove the last 16 bytes from the .wfs file.
# -------------------------------
# Get file size
FILE_SIZE=$(stat -c%s "$WFS_FILE")
# Compute size minus 16
TRIM_SIZE=$((FILE_SIZE - 16))
# Write trimmed file as a valid zip
head -c "$TRIM_SIZE" "$WFS_FILE" > "$ZIP_FILE"

# -------------------------------
# Step 2: Extract the zip contents into src/
# -------------------------------
rm -rf "$SRC_DIR"
mkdir -p "$SRC_DIR"
unzip -q "$ZIP_FILE" -d "$SRC_DIR"

echo "Extracted \"$WFS_FILE\" into $SRC_DIR successfully."