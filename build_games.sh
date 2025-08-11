#!/bin/bash
# Build script for BSD Games on macOS
# This script compiles each game individually

set -e

GAMES_DIR="games"
BUILD_DIR="build"
INSTALL_DIR="/usr/local/games"

# Create build directory
mkdir -p "$BUILD_DIR"

echo "Building BSD Games for macOS..."

# Function to build a simple single-file game
build_simple_game() {
    local game_name=$1
    local source_file=$2
    
    echo "Building $game_name..."
    
    if [ -f "$GAMES_DIR/$game_name/$source_file" ]; then
        cc -o "$BUILD_DIR/$game_name" "$GAMES_DIR/$game_name/$source_file" -lm -lcurses 2>/dev/null || \
        cc -o "$BUILD_DIR/$game_name" "$GAMES_DIR/$game_name/$source_file" -lm 2>/dev/null || \
        cc -o "$BUILD_DIR/$game_name" "$GAMES_DIR/$game_name/$source_file" 2>/dev/null || {
            echo "Failed to build $game_name"
            return 1
        }
        echo "✓ $game_name built successfully"
    else
        echo "✗ Source file $source_file not found for $game_name"
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
        if [ -f "$GAMES_DIR/$game_name/$file" ]; then
            all_sources="$all_sources $GAMES_DIR/$game_name/$file"
        else
            echo "✗ Source file $file not found for $game_name"
            return 1
        fi
    done
    
    if [ -n "$all_sources" ]; then
        cc -o "$BUILD_DIR/$game_name" $all_sources -lm -lcurses 2>/dev/null || \
        cc -o "$BUILD_DIR/$game_name" $all_sources -lm 2>/dev/null || \
        cc -o "$BUILD_DIR/$game_name" $all_sources 2>/dev/null || {
            echo "Failed to build $game_name"
            return 1
        }
        echo "✓ $game_name built successfully"
    fi
}

# Start building games
echo "========================================"

# Simple single-file games
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

echo "========================================"
echo "Build complete!"
echo "Built games are in the '$BUILD_DIR' directory:"
ls -la "$BUILD_DIR"
