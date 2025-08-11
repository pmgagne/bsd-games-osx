#!/bin/bash

# Enhanced OpenBSD Games build script with additional compatibility fixes
# Uses configuration flags and enhanced compatibility stubs

BUILD_FLAGS='CFLAGS="-Os -pipe -Werror-implicit-function-declaration -include ../../pledge_stub.h" HOSTCC="cc -include ../../pledge_stub.h"'
BUILD_FLAGS_FACTOR='CFLAGS="-Os -pipe -Werror-implicit-function-declaration -include ../../pledge_stub.h -I../primes" HOSTCC="cc -include ../../pledge_stub.h"'

echo "Building OpenBSD games with enhanced compatibility..."
echo "=============================================="

cd /Users/philippe/Documents/bsd-games/openbsd-games/games

# Previously successful games
SIMPLE_GAMES="adventure arithmetic banner battlestar bcd caesar fish mille monop morse number pig pom ppt primes quiz trek wargames wump"

# Games that need special handling
SPECIAL_GAMES="factor gomoku grdc"

# Games that still need work
COMPLEX_GAMES="fortune hangman phantasia rain random robots sail snake tetris worm worms"

SUCCESS_COUNT=0
FAIL_COUNT=0
SUCCESSFUL_GAMES=""
FAILED_GAMES=""

echo "Building simple games..."
for game in $SIMPLE_GAMES; do
    echo -n "Building $game... "
    cd "$game"
    
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
echo "Building special games with custom flags..."

# Factor needs primes include
echo -n "Building factor (needs primes)... "
cd factor
if eval bsdmake $BUILD_FLAGS_FACTOR > /dev/null 2>&1; then
    echo "✅ SUCCESS"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    SUCCESSFUL_GAMES="$SUCCESSFUL_GAMES factor"
else
    echo "❌ FAILED"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAILED_GAMES="$FAILED_GAMES factor"
fi
cd ..

# Gomoku needs reallocarray stub
echo -n "Building gomoku (needs reallocarray)... "
cd gomoku
if eval bsdmake $BUILD_FLAGS > /dev/null 2>&1; then
    echo "✅ SUCCESS"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    SUCCESSFUL_GAMES="$SUCCESSFUL_GAMES gomoku"
else
    echo "❌ FAILED"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAILED_GAMES="$FAILED_GAMES gomoku"
fi
cd ..

# Grdc needs ppoll stub
echo -n "Building grdc (needs ppoll)... "
cd grdc
if eval bsdmake $BUILD_FLAGS > /dev/null 2>&1; then
    echo "✅ SUCCESS"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    SUCCESSFUL_GAMES="$SUCCESSFUL_GAMES grdc"
else
    echo "❌ FAILED"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAILED_GAMES="$FAILED_GAMES grdc"
fi
cd ..

echo ""
echo "Attempting complex games..."
for game in $COMPLEX_GAMES; do
    echo -n "Building $game... "
    cd "$game"
    
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
echo "=============================================="
echo "Enhanced Build Summary:"
echo "Successful: $SUCCESS_COUNT"
echo "Failed: $FAIL_COUNT"
echo ""
echo "✅ Successfully built: $SUCCESSFUL_GAMES"
echo ""
echo "❌ Still failed: $FAILED_GAMES"
echo ""
echo "Compatibility features added:"
echo "- pledge() and unveil() stubs"
echo "- srandom_deterministic() stub"
echo "- BSD type definitions (u_short, u_int, etc.)"
echo "- LOGIN_NAME_MAX constant"
echo "- reallocarray() implementation"
echo "- ppoll() to poll() conversion"
