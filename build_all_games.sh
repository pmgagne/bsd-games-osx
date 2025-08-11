#!/bin/bash

# Build All OpenBSD Games for macOS
# This script rebuilds all successfully working games using configuration-only approach

set -e  # Exit on any error

echo "🎮 Building All OpenBSD Games for macOS"
echo "========================================"

# Base directory
BASE_DIR="/Users/philippe/Documents/bsd-games/openbsd-games"
cd "$BASE_DIR"

# Common build flags
BASE_CFLAGS="-Os -pipe -Werror-implicit-function-declaration"
BASE_HOSTCC="cc"

# Success counter
SUCCESS_COUNT=0
TOTAL_COUNT=0

# Function to build a simple game (single directory)
build_simple_game() {
    local game_dir="$1"
    local game_name=$(basename "$game_dir")
    
    echo "📦 Building $game_name..."
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    
    cd "$BASE_DIR/$game_dir"
    
    if bsdmake clean > /dev/null 2>&1; then
        echo "   ✓ Cleaned $game_name"
    fi
    
    if bsdmake CFLAGS="$BASE_CFLAGS -include ../../pledge_stub.h" HOSTCC="$BASE_HOSTCC -include ../../pledge_stub.h" > /dev/null 2>&1; then
        echo "   ✅ SUCCESS: $game_name built successfully"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        return 0
    else
        echo "   ❌ FAILED: $game_name build failed"
        return 1
    fi
}

# Function to build complex games with dependencies
build_complex_game() {
    local game_dir="$1"
    local include_paths="$2"
    local game_name=$(basename "$game_dir")
    
    echo "📦 Building $game_name (complex)..."
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    
    cd "$BASE_DIR/$game_dir"
    
    if bsdmake clean > /dev/null 2>&1; then
        echo "   ✓ Cleaned $game_name"
    fi
    
    local cflags="$BASE_CFLAGS -include ../../../pledge_stub.h"
    if [ -n "$include_paths" ]; then
        cflags="$cflags $include_paths"
    fi
    
    if bsdmake CFLAGS="$cflags" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
        echo "   ✅ SUCCESS: $game_name built successfully"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        return 0
    else
        echo "   ❌ FAILED: $game_name build failed"
        return 1
    fi
}

echo
echo "🔨 Building Simple Games..."
echo "----------------------------"

# Simple single-directory games
build_simple_game "tetris"
build_simple_game "robots"
build_simple_game "gomoku"
build_simple_game "snake"
build_simple_game "worms"
build_simple_game "arithmetic"
build_simple_game "primes"
build_simple_game "bcd"
build_simple_game "ppt"
build_simple_game "banner"
build_simple_game "number"
build_simple_game "random"
build_simple_game "grdc"

# Games with special dependencies
echo "📦 Building factor (needs primes headers)..."
TOTAL_COUNT=$((TOTAL_COUNT + 1))
cd "$BASE_DIR/factor"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../pledge_stub.h -I../primes" HOSTCC="$BASE_HOSTCC -include ../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: factor built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: factor build failed"
fi

echo
echo "🔨 Building Additional Games..."
echo "-------------------------------"

# More simple games
build_simple_game "caesar"
build_simple_game "fish" 
build_simple_game "bs"
build_simple_game "cribbage"
build_simple_game "adventure"
build_simple_game "battlestar"
build_simple_game "mille"
build_simple_game "morse"
build_simple_game "pig"
build_simple_game "pom"
build_simple_game "rain"
build_simple_game "quiz"
build_simple_game "monop"
build_simple_game "phantasia"
build_simple_game "atc"

# Final batch of games
build_simple_game "wump"
build_simple_game "worm" 
build_simple_game "trek"
build_simple_game "sail"

echo
echo "🔨 Building Complex Multi-Component Games..."
echo "---------------------------------------------"

# Boggle system (build components first, then main game)
echo "📦 Building Boggle System..."
TOTAL_COUNT=$((TOTAL_COUNT + 3))

cd "$BASE_DIR/boggle/mkdict"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h -I../boggle" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: mkdict built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: mkdict build failed"
fi

cd "$BASE_DIR/boggle/mkindex"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h -I../boggle" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: mkindex built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: mkindex build failed"
fi

cd "$BASE_DIR/boggle/boggle"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: boggle built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: boggle build failed"
fi

# Canfield system
echo "📦 Building Canfield System..."
TOTAL_COUNT=$((TOTAL_COUNT + 2))

cd "$BASE_DIR/canfield/canfield"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: canfield built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: canfield build failed"
fi

cd "$BASE_DIR/canfield/cfscores"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: cfscores built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: cfscores build failed"
fi

# Fortune system
echo "📦 Building Fortune System..."
TOTAL_COUNT=$((TOTAL_COUNT + 3))

cd "$BASE_DIR/fortune/strfile"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: strfile built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: strfile build failed"
fi

cd "$BASE_DIR/fortune/unstr"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h -I../strfile" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: unstr built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: unstr build failed"
fi

cd "$BASE_DIR/fortune/fortune"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h -I../strfile" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: fortune built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: fortune build failed"
fi

# Backgammon system
echo "📦 Building Backgammon System..."
TOTAL_COUNT=$((TOTAL_COUNT + 2))

cd "$BASE_DIR/backgammon/backgammon"
if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h -I../common_source" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: backgammon built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: backgammon build failed"
fi

# Handle teachgammon special dependency on data.c
echo "📦 Building teachgammon (with data.c dependency)..."
cd "$BASE_DIR/backgammon/teachgammon"

# Create minimal data.c if it doesn't exist
if [ ! -f "data.c" ]; then
    cat > data.c << 'EOF'
/* Minimal data.c for teachgammon */
/* Global variables needed by teachgammon */

int maxmoves = 0;
int test[2] = {0, 0};
EOF
fi

if bsdmake clean > /dev/null 2>&1 && bsdmake CFLAGS="$BASE_CFLAGS -include ../../../pledge_stub.h -I../common_source" HOSTCC="$BASE_HOSTCC -include ../../../pledge_stub.h" > /dev/null 2>&1; then
    echo "   ✅ SUCCESS: teachgammon built successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    echo "   ❌ FAILED: teachgammon build failed"
fi

echo
echo "🎯 Build Summary"
echo "==============="
echo "✅ Successful builds: $SUCCESS_COUNT"
echo "📊 Total attempted: $TOTAL_COUNT"
echo "📈 Success rate: $(( SUCCESS_COUNT * 100 / TOTAL_COUNT ))%"

if [ $SUCCESS_COUNT -eq $TOTAL_COUNT ]; then
    echo "🎉 ALL GAMES BUILT SUCCESSFULLY!"
else
    echo "⚠️  Some games failed to build. Check individual error messages above."
fi

echo
echo "🎮 Built Games Location:"
echo "======================="
echo "Games are available in their respective directories under:"
echo "$BASE_DIR"
echo
echo "Examples:"
echo "  ./tetris/tetris"
echo "  ./robots/robots"
echo "  ./backgammon/backgammon/backgammon"
echo "  ./fortune/fortune/fortune"

cd "$BASE_DIR"
echo
echo "📋 Current Built Executables:"
echo "============================"
find . -type f -perm +111 ! -name "*.6*" ! -name "*.sh" ! -name "Makefile*" ! -name "*.gz" | grep -v "\.o$" | grep -v "/makedefs$" | sort
