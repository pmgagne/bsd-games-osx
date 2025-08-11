#!/bin/bash

# OpenBSD Games build script with compatibility flags
# Uses configuration flags instead of modifying source code

BUILD_FLAGS='CFLAGS="-Os -pipe -Werror-implicit-function-declaration -include ../../pledge_stub.h" HOSTCC="cc -include ../../pledge_stub.h"'

echo "Building OpenBSD games with compatibility flags..."
echo "=========================================="

cd /Users/philippe/Documents/bsd-games/openbsd-games/games

# List of games to try building
GAMES="banner battlestar caesar factor fish fortune gomoku grdc hangman mille monop morse number phantasia pig pom ppt primes quiz rain random robots sail snake tetris trek wargames worm worms wump"

SUCCESS_COUNT=0
FAIL_COUNT=0
SUCCESSFUL_GAMES=""
FAILED_GAMES=""

for game in $GAMES; do
    echo ""
    echo "Building $game..."
    cd "$game"
    
    if eval bsdmake $BUILD_FLAGS > /dev/null 2>&1; then
        echo "✅ $game - SUCCESS"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        SUCCESSFUL_GAMES="$SUCCESSFUL_GAMES $game"
    else
        echo "❌ $game - FAILED"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_GAMES="$FAILED_GAMES $game"
    fi
    
    cd ..
done

echo ""
echo "=========================================="
echo "Build Summary:"
echo "Successful: $SUCCESS_COUNT"
echo "Failed: $FAIL_COUNT"
echo ""
echo "✅ Successfully built: $SUCCESSFUL_GAMES"
echo ""
echo "❌ Failed to build: $FAILED_GAMES"
