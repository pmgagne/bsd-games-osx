#!/bin/bash

# Advanced OpenBSD Games build script
# Handles subdirectory path issues and complex dependencies

echo "Advanced OpenBSD games build with path fixes..."
echo "==============================================="

cd /Users/philippe/Documents/bsd-games/openbsd-games/games

SUCCESS_COUNT=0
FAIL_COUNT=0
SUCCESSFUL_GAMES=""
FAILED_GAMES=""

# Simple games (no subdirectories)
SIMPLE_GAMES="adventure arithmetic banner battlestar bcd bs caesar cribbage factor fish gomoku grdc mille monop morse number phantasia pig pom ppt primes quiz rain random robots sail snake tetris trek wargames worm worms wump"

# Games with subdirectories (need path adjustment)
SUBDIR_GAMES="atc boggle canfield fortune hangman hunt"

# Complex multi-part games
COMPLEX_GAMES="backgammon hack"

echo "Building simple games..."
for game in $SIMPLE_GAMES; do
    echo -n "Building $game... "
    cd "$game" 2>/dev/null || { echo "❌ NOT FOUND"; continue; }
    
    # Special case for factor
    if [ "$game" = "factor" ]; then
        BUILD_FLAGS='CFLAGS="-Os -pipe -Werror-implicit-function-declaration -include ../../pledge_stub.h -I../primes" HOSTCC="cc -include ../../pledge_stub.h"'
    else
        BUILD_FLAGS='CFLAGS="-Os -pipe -Werror-implicit-function-declaration -include ../../pledge_stub.h" HOSTCC="cc -include ../../pledge_stub.h"'
    fi
    
    if eval bsdmake $BUILD_FLAGS > /dev/null 2>&1; then
        echo "✅ SUCCESS"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        SUCCESSFUL_GAMES="$SUCCESSFUL_GAMES $game"
    else
        echo "❌ FAILED"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_GAMES="$FAILED_GAMES $game"
    fi
    
    cd ..
done

echo ""
echo "Building games with subdirectories..."
for game in $SUBDIR_GAMES; do
    echo -n "Building $game (subdir)... "
    cd "$game" 2>/dev/null || { echo "❌ NOT FOUND"; continue; }
    
    # Use deeper path for subdirectory games
    BUILD_FLAGS='CFLAGS="-Os -pipe -Werror-implicit-function-declaration -include ../../../pledge_stub.h" HOSTCC="cc -include ../../../pledge_stub.h"'
    
    if eval bsdmake $BUILD_FLAGS > /dev/null 2>&1; then
        echo "✅ SUCCESS"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        SUCCESSFUL_GAMES="$SUCCESSFUL_GAMES $game"
    else
        echo "❌ FAILED"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_GAMES="$FAILED_GAMES $game"
    fi
    
    cd ..
done

echo ""
echo "Attempting complex games..."
for game in $COMPLEX_GAMES; do
    echo -n "Building $game (complex)... "
    cd "$game" 2>/dev/null || { echo "❌ NOT FOUND"; continue; }
    
    # Try both path variants
    BUILD_FLAGS1='CFLAGS="-Os -pipe -Werror-implicit-function-declaration -include ../../pledge_stub.h" HOSTCC="cc -include ../../pledge_stub.h"'
    BUILD_FLAGS2='CFLAGS="-Os -pipe -Werror-implicit-function-declaration -include ../../../pledge_stub.h" HOSTCC="cc -include ../../../pledge_stub.h"'
    
    if eval bsdmake $BUILD_FLAGS1 > /dev/null 2>&1 || eval bsdmake $BUILD_FLAGS2 > /dev/null 2>&1; then
        echo "✅ SUCCESS"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        SUCCESSFUL_GAMES="$SUCCESSFUL_GAMES $game"
    else
        echo "❌ FAILED"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_GAMES="$FAILED_GAMES $game"
    fi
    
    cd ..
done

echo ""
echo "==============================================="
echo "ADVANCED BUILD SUMMARY:"
echo "==============================================="
echo "Total games attempted: $((SUCCESS_COUNT + FAIL_COUNT))"
echo "✅ Successfully built: $SUCCESS_COUNT"
echo "❌ Failed to build: $FAIL_COUNT"
echo "Success rate: $(( SUCCESS_COUNT * 100 / (SUCCESS_COUNT + FAIL_COUNT) ))%"
echo ""
echo "✅ WORKING GAMES:"
echo "$SUCCESSFUL_GAMES" | tr ' ' '\n' | sort | while read game; do
    [ -n "$game" ] && echo "   • $game"
done
echo ""
echo "❌ STILL NEED WORK:"
echo "$FAILED_GAMES" | tr ' ' '\n' | sort | while read game; do
    [ -n "$game" ] && echo "   • $game"
done
echo ""
echo "🎮 Ready to play vintage OpenBSD games on macOS! 🎮"
