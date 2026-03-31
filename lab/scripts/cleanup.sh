#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo "Cleaning up output directories..."

if [ -d "$OUT_DIR" ]; then
    rm -rf "$OUT_DIR"
    echo "Removed $OUT_DIR"
else
    echo "Output directory $OUT_DIR does not exist, nothing to clean up."
fi

echo "Cleanup completed."
