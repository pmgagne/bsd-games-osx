#!/bin/bash
echo "🧪 BSD Games CLI Wrappers Test"
echo "============================="
echo ""

# Test that commands are available in PATH
echo "📍 Test 1: Commands in PATH..."
COMMANDS_FOUND=0
COMMANDS_TO_TEST="tetris fortune adventure pig random"
COMMANDS_TOTAL=0

for cmd in $COMMANDS_TO_TEST; do
    COMMANDS_TOTAL=$((COMMANDS_TOTAL + 1))
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "   ✅ $cmd (found in PATH)"
        COMMANDS_FOUND=$((COMMANDS_FOUND + 1))
    else
        echo "   ❌ $cmd (not found in PATH)"
    fi
done

echo ""
echo "📖 Test 2: Man pages..."
MAN_TEST_PASSED=0

# Test fortune man page
echo "   Testing man fortune..."
MAN_FORTUNE_OUTPUT=$(man fortune 2>/dev/null | head -1)
if echo "$MAN_FORTUNE_OUTPUT" | grep -q "FORTUNE(6)"; then
    echo "   ✅ man fortune works"
    MAN_TEST_PASSED=$((MAN_TEST_PASSED + 1))
else
    echo "   ❌ man fortune failed"
fi

# Test tetris man page
echo "   Testing man tetris..."
MAN_TETRIS_OUTPUT=$(man tetris 2>/dev/null | head -1)
if echo "$MAN_TETRIS_OUTPUT" | grep -q "TETRIS(6)"; then
    echo "   ✅ man tetris works"
    MAN_TEST_PASSED=$((MAN_TEST_PASSED + 1))
else
    echo "   ❌ man tetris failed"
fi

echo ""
echo "🎲 Test 3: Wrapper functionality..."
TEST_PASSED=0

# Test fortune
echo "   Testing fortune..."
FORTUNE_OUTPUT=$(fortune 2>&1)
if [ $? -eq 0 ] && [ -n "$FORTUNE_OUTPUT" ]; then
    echo "   ✅ fortune works"
    TEST_PASSED=$((TEST_PASSED + 1))
else
    echo "   ❌ fortune failed"
fi

# Test pig
echo "   Testing pig..."
PIG_OUTPUT=$(echo "test" | pig 2>&1)
if [ $? -eq 0 ] && echo "$PIG_OUTPUT" | grep -q "esttay"; then
    echo "   ✅ pig works"
    TEST_PASSED=$((TEST_PASSED + 1))
else
    echo "   ❌ pig failed"
fi

echo ""
echo "📊 Results:"
echo "   Commands in PATH: $COMMANDS_FOUND/$COMMANDS_TOTAL"
echo "   Man pages working: $MAN_TEST_PASSED/2"
echo "   Working games: $TEST_PASSED/2"
echo ""

if [ $COMMANDS_FOUND -eq $COMMANDS_TOTAL ] && [ $MAN_TEST_PASSED -eq 2 ] && [ $TEST_PASSED -eq 2 ]; then
    echo "🎉 All CLI wrapper and man page tests passed!"
    echo ""
    echo "✅ BSD Games are now fully integrated with the system:"
    echo "   🎮 Games: fortune, tetris, adventure, etc."
    echo "   📖 Documentation: man fortune, man tetris, etc."
else
    echo "⚠️  Some tests failed - CLI integration may not be fully functional"
fi

echo ""
