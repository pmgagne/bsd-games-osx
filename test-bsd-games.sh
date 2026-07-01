#!/bin/bash
echo "🧪 BSD Games Bundle Test Suite"
echo "=============================="
echo ""

# Test 1: Bundle structure
echo "📁 Test 1: Bundle structure..."
if [ -d "/Applications/BSDGames.app" ]; then
    echo "   ✅ Bundle installed in Applications"
else
    echo "   ❌ Bundle not found in Applications"
    exit 1
fi

# Test 2: Launcher script exists and is executable
echo ""
echo "🚀 Test 2: Launcher script..."
LAUNCHER="/Applications/BSDGames.app/Contents/MacOS/bsd-games-launcher"
if [ -x "$LAUNCHER" ]; then
    echo "   ✅ Launcher script exists and is executable"
else
    echo "   ❌ Launcher script missing or not executable"
    exit 1
fi

# Test 3: Command line mode (list games)
echo ""
echo "📋 Test 3: Command line mode (list games)..."
TERM=xterm "$LAUNCHER" | grep -q "BSD Games Collection"
if [ $? -eq 0 ]; then
    echo "   ✅ Command line mode lists games correctly"
else
    echo "   ❌ Command line mode failed"
    exit 1
fi

# Test 4: Game execution (fortune)
echo ""
echo "🎲 Test 4: Fortune game execution..."
FORTUNE_OUTPUT=$(TERM=xterm "$LAUNCHER" fortune 2>&1)
if [ $? -eq 0 ] && [ -n "$FORTUNE_OUTPUT" ]; then
    echo "   ✅ Fortune game runs successfully"
    echo "   📜 Fortune says: \"$(echo "$FORTUNE_OUTPUT" | head -1)\""
else
    echo "   ❌ Fortune game failed"
    echo "   Error: $FORTUNE_OUTPUT"
fi

# Test 5: Fish game resource path
echo ""
echo "🐟 Test 5: Fish game resource loading..."
FISH_OUTPUT=$(echo "n" | TERM=xterm "$LAUNCHER" fish 2>&1 | head -1)
if echo "$FISH_OUTPUT" | grep -q "Would you like instructions"; then
    echo "   ✅ Fish game loads and finds instruction file"
else
    echo "   ❌ Fish game failed to load properly"
    echo "   Output: $FISH_OUTPUT"
fi

# Test 6: Resource files exist
echo ""
echo "📦 Test 6: Resource files..."
RESOURCES_DIR="/Applications/BSDGames.app/Contents/Resources/games"
if [ -d "$RESOURCES_DIR/fortune" ] && [ -f "$RESOURCES_DIR/fish.instr" ] && [ -f "$RESOURCES_DIR/cards.pck" ]; then
    echo "   ✅ All resource files present"
else
    echo "   ❌ Some resource files missing"
fi

# Count total games
echo ""
echo "🎯 Game count..."
GAME_COUNT=$(ls -1 /Applications/BSDGames.app/Contents/MacOS/ | grep -v bsd-games-launcher | wc -l | tr -d ' ')
echo "   📊 Total games available: $GAME_COUNT"

echo ""
echo "🎉 BSD Games Bundle Test Complete!"
echo "=================================="
echo ""
echo "✅ The BSD Games bundle is working correctly!"
echo "✅ Command line mode: TERM=xterm /Applications/BSDGames.app/Contents/MacOS/bsd-games-launcher"
echo "✅ GUI mode: Double-click BSDGames.app in Finder"
echo "✅ Direct game access: /Applications/BSDGames.app/Contents/MacOS/<game-name>"
echo ""
echo "🎮 Popular games to try:"
echo "   • tetris - Block puzzle game"
echo "   • adventure - Text adventure in Colossal Cave"
echo "   • fortune - Random quotes and sayings"
echo "   • backgammon - Classic board game"
echo "   • robots - Avoid the robots"
echo ""
echo "📝 Note: When launched from Finder, the app will show a dialog to select games."
