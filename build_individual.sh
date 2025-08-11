#!/bin/bash
# Individual game builder for BSD Games on macOS
# This script builds games one by one with detailed error reporting

set -e

GAMES_DIR="games"
BUILD_DIR="build"

mkdir -p "$BUILD_DIR"

# Function to patch and build a single game
build_game() {
    local game_name=$1
    local source_file=$2
    
    echo "Building $game_name..."
    
    local original="$GAMES_DIR/$game_name/$source_file"
    local temp_source="/tmp/${game_name}_patched.c"
    
    if [ ! -f "$original" ]; then
        echo "✗ Source file $source_file not found for $game_name"
        return 1
    fi
    
    # Create patched version
    cp "$original" "$temp_source"
    
    # Apply patches for macOS compatibility
    cat > /tmp/patch_script.sed << 'EOF'
# Remove pledge() calls
/if (pledge.*== -1)/,+1d
/pledge.*NULL/d

# Add compatibility headers and definitions
/^#include.*unistd\.h/a\
#include <sys/types.h>\
#ifndef u_char\
#define u_char unsigned char\
#endif\
#ifndef u_short\
#define u_short unsigned short\
#endif\
#ifndef u_int\
#define u_int unsigned int\
#endif\
#ifndef u_long\
#define u_long unsigned long\
#endif

# Replace arc4random functions
s/arc4random()/((unsigned)rand())/g
s/arc4random_uniform(\([^)]*\))/((unsigned)rand() % (\1))/g

# Remove __dead attribute
s/__dead//g
EOF

    sed -f /tmp/patch_script.sed "$temp_source" > "${temp_source}.tmp" && mv "${temp_source}.tmp" "$temp_source"
    
    # Try to compile with different library combinations
    local compiled=false
    
    # Try with curses and math
    if cc -o "$BUILD_DIR/$game_name" "$temp_source" -lm -lcurses 2>/dev/null; then
        echo "✓ $game_name built successfully (with curses + math)"
        compiled=true
    # Try with just math
    elif cc -o "$BUILD_DIR/$game_name" "$temp_source" -lm 2>/dev/null; then
        echo "✓ $game_name built successfully (with math)"
        compiled=true
    # Try with just curses
    elif cc -o "$BUILD_DIR/$game_name" "$temp_source" -lcurses 2>/dev/null; then
        echo "✓ $game_name built successfully (with curses)"
        compiled=true
    # Try with no extra libraries
    elif cc -o "$BUILD_DIR/$game_name" "$temp_source" 2>/dev/null; then
        echo "✓ $game_name built successfully"
        compiled=true
    else
        echo "✗ Failed to build $game_name"
        echo "   Compilation errors:"
        cc -o "$BUILD_DIR/$game_name" "$temp_source" 2>&1 | head -5 | sed 's/^/     /'
        compiled=false
    fi
    
    # Clean up
    rm -f "$temp_source" /tmp/patch_script.sed
    
    return $([ "$compiled" = true ] && echo 0 || echo 1)
}

echo "Building BSD Games individually..."
echo "========================================"

# List of simple games to try
games_to_build=(
    "banner:banner.c"
    "bcd:bcd.c"
    "caesar:caesar.c"
    "factor:factor.c"
    "grdc:grdc.c"
    "morse:morse.c"
    "number:number.c"
    "pig:pig.c"
    "pom:pom.c"
    "ppt:ppt.c"
    "primes:primes.c"
    "rain:rain.c"
    "random:random.c"
    "worms:worms.c"
    "wump:wump.c"
    "arithmetic:arithmetic.c"
    "snake:snake.c"
    "tetris:tetris.c"
)

successful_builds=()
failed_builds=()

for game_spec in "${games_to_build[@]}"; do
    game_name="${game_spec%:*}"
    source_file="${game_spec#*:}"
    
    if build_game "$game_name" "$source_file"; then
        successful_builds+=("$game_name")
    else
        failed_builds+=("$game_name")
    fi
    echo ""
done

echo "========================================"
echo "Build Summary:"
echo ""
echo "Successfully built games (${#successful_builds[@]}):"
for game in "${successful_builds[@]}"; do
    echo "  ✓ $game"
done

if [ ${#failed_builds[@]} -gt 0 ]; then
    echo ""
    echo "Failed to build (${#failed_builds[@]}):"
    for game in "${failed_builds[@]}"; do
        echo "  ✗ $game"
    done
fi

echo ""
echo "Built executables are in the '$BUILD_DIR' directory:"
ls -la "$BUILD_DIR" 2>/dev/null || echo "  (no files built)"

echo ""
echo "To test a game, run: ./$BUILD_DIR/[game_name]"
echo "For example: ./$BUILD_DIR/banner 'Hello World'"
