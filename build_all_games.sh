#!/bin/bash
# Comprehensive build script for BSD Games on macOS
# This script patches and compiles OpenBSD games for macOS compatibility

set -e

GAMES_DIR="games"
BUILD_DIR="build"
PATCHED_DIR="patched"

# Create directories
mkdir -p "$BUILD_DIR"
mkdir -p "$PATCHED_DIR"

echo "Building BSD Games for macOS..."
echo "Patching OpenBSD-specific code for macOS compatibility..."

# Function to create a patched version of a source file
patch_for_macos() {
    local game_name=$1
    local source_file=$2
    
    local original="$GAMES_DIR/$game_name/$source_file"
    local patched="$PATCHED_DIR/${game_name}_${source_file}"
    
    if [ ! -f "$original" ]; then
        echo "✗ Source file $source_file not found for $game_name"
        return 1
    fi
    
    # Copy original to patched location
    cp "$original" "$patched"
    
    # Apply common macOS compatibility patches
    
    # Remove pledge() calls (OpenBSD security feature not available on macOS)
    sed -i '' '/if (pledge.*== -1)/,+1d' "$patched" 2>/dev/null || true
    sed -i '' '/pledge.*NULL/d' "$patched" 2>/dev/null || true
    
    # Add u_char definition if needed
    if grep -q "u_char" "$patched" && ! grep -q "define u_char" "$patched"; then
        sed -i '' '/^#include.*unistd\.h/a\
#ifndef u_char\
#define u_char unsigned char\
#endif
' "$patched" 2>/dev/null || true
    fi
    
    # Add sys/types.h if u_char is used
    if grep -q "u_char" "$patched" && ! grep -q "sys/types.h" "$patched"; then
        sed -i '' '/^#include.*unistd\.h/a\
#include <sys/types.h>
' "$patched" 2>/dev/null || true
    fi
    
    # Replace arc4random() calls with rand() for compatibility
    sed -i '' 's/arc4random()/rand()/g' "$patched" 2>/dev/null || true
    sed -i '' 's/arc4random_uniform(/((unsigned)rand() % /g' "$patched" 2>/dev/null || true
    
    # Replace __dead with __attribute__((noreturn)) or remove it
    sed -i '' 's/__dead/__attribute__((noreturn))/g' "$patched" 2>/dev/null || true
    
    echo "$patched"
}

# Function to build a simple single-file game
build_simple_game() {
    local game_name=$1
    local source_file=$2
    
    echo "Building $game_name..."
    
    # Patch the source file for macOS
    patched_source=$(patch_for_macos "$game_name" "$source_file")
    
    if [ -f "$patched_source" ]; then
        # Try different compilation options
        if cc -o "$BUILD_DIR/$game_name" "$patched_source" -lm -lcurses 2>/dev/null; then
            echo "✓ $game_name built successfully (with curses)"
        elif cc -o "$BUILD_DIR/$game_name" "$patched_source" -lm 2>/dev/null; then
            echo "✓ $game_name built successfully (with math)"
        elif cc -o "$BUILD_DIR/$game_name" "$patched_source" 2>/dev/null; then
            echo "✓ $game_name built successfully"
        else
            echo "✗ Failed to build $game_name"
            return 1
        fi
    else
        echo "✗ Failed to patch $game_name"
        return 1
    fi
}

# Function to build multi-file games
build_multi_file_game() {
    local game_name=$1
    shift
    local source_files=("$@")
    
    echo "Building $game_name..."
    
    local all_sources=""
    for file in "${source_files[@]}"; do
        patched_source=$(patch_for_macos "$game_name" "$file")
        if [ -f "$patched_source" ]; then
            all_sources="$all_sources $patched_source"
        else
            echo "✗ Failed to patch $file for $game_name"
            return 1
        fi
    done
    
    if [ -n "$all_sources" ]; then
        if cc -o "$BUILD_DIR/$game_name" $all_sources -lm -lcurses 2>/dev/null; then
            echo "✓ $game_name built successfully (with curses)"
        elif cc -o "$BUILD_DIR/$game_name" $all_sources -lm 2>/dev/null; then
            echo "✓ $game_name built successfully (with math)"
        elif cc -o "$BUILD_DIR/$game_name" $all_sources 2>/dev/null; then
            echo "✓ $game_name built successfully"
        else
            echo "✗ Failed to build $game_name"
            return 1
        fi
    fi
}

echo "========================================"

# Start building games - simple single-file games first
echo "Building simple games..."

build_simple_game "banner" "banner.c"
build_simple_game "bcd" "bcd.c"
build_simple_game "caesar" "caesar.c"
build_simple_game "factor" "factor.c"
build_simple_game "grdc" "grdc.c"
build_simple_game "morse" "morse.c"
build_simple_game "number" "number.c"
build_simple_game "pig" "pig.c"
build_simple_game "pom" "pom.c"
build_simple_game "ppt" "ppt.c"
build_simple_game "primes" "primes.c"
build_simple_game "rain" "rain.c"
build_simple_game "random" "random.c"
build_simple_game "worms" "worms.c"
build_simple_game "wump" "wump.c"

echo ""
echo "Building games that may need curses..."
build_simple_game "snake" "snake.c"
build_simple_game "tetris" "tetris.c"

echo ""
echo "Building arithmetic game..."
build_simple_game "arithmetic" "arithmetic.c"

echo "========================================"
echo "Build complete!"
echo ""
echo "Successfully built games:"
ls -1 "$BUILD_DIR" 2>/dev/null | while read game; do
    echo "  $game"
done

echo ""
echo "To test a game, run: ./$BUILD_DIR/[game_name]"
echo "For example: ./$BUILD_DIR/banner 'Hello World'"
