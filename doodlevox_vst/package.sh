#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────────────
# package.sh — Build DoodleVox and create a platform-native installer.
#
# Usage:
#   ./package.sh [Release|Debug]        (default: Release)
#
# macOS  → .pkg installer (productbuild)
# Linux  → .deb package
# Windows→ NSIS installer  (run from MSYS2 / Git-Bash)
# ────────────────────────────────────────────────────────────────────────────
set -euo pipefail

CONFIG="${1:-Release}"
BUILD_DIR="build_installer"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Configuring ($CONFIG) …"
cmake -S "$ROOT_DIR" -B "$ROOT_DIR/$BUILD_DIR" -DCMAKE_BUILD_TYPE="$CONFIG"

echo "==> Building …"
cmake --build "$ROOT_DIR/$BUILD_DIR" --config "$CONFIG" --parallel

echo "==> Packaging …"
cd "$ROOT_DIR/$BUILD_DIR"
cpack -C "$CONFIG"

echo ""
echo "==> Done. Installer(s) are in:"
echo "    $ROOT_DIR/$BUILD_DIR/_CPack_Packages/ and $ROOT_DIR/$BUILD_DIR/"
ls -1 "$ROOT_DIR/$BUILD_DIR"/*.pkg "$ROOT_DIR/$BUILD_DIR"/*.deb "$ROOT_DIR/$BUILD_DIR"/*.exe 2>/dev/null || true
