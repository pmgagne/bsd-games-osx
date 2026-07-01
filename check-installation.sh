#!/bin/bash
echo "📊 BSD Games Installation Status"
echo "================================"
echo ""

# Check bundle installation
echo "🎯 Bundle Installation:"
if [ -d "/Applications/BSDGames.app" ]; then
    echo "   ✅ BSDGames.app installed in /Applications/"
    
    # Count games in bundle
    BUNDLE_GAMES=$(ls -1 /Applications/BSDGames.app/Contents/MacOS/ | grep -v bsd-games-launcher | wc -l | tr -d ' ')
    echo "   📦 Games in bundle: $BUNDLE_GAMES"
    
    # Check launcher
    if [ -x "/Applications/BSDGames.app/Contents/MacOS/bsd-games-launcher" ]; then
        echo "   ✅ GUI launcher available"
    else
        echo "   ❌ GUI launcher missing"
    fi
    
    # Check resources
    if [ -d "/Applications/BSDGames.app/Contents/Resources/games" ]; then
        echo "   ✅ Game resources available"
    else
        echo "   ❌ Game resources missing"
    fi
    
    # Check man pages in bundle
    if [ -d "/Applications/BSDGames.app/Contents/Man/man6" ]; then
        BUNDLE_MANS=$(ls -1 /Applications/BSDGames.app/Contents/Man/man6/ | wc -l | tr -d ' ')
        echo "   📖 Man pages in bundle: $BUNDLE_MANS"
    else
        echo "   ❌ Man pages missing from bundle"
    fi
else
    echo "   ❌ BSDGames.app not found in /Applications/"
fi

echo ""
echo "🔗 CLI Integration:"

# Single source of truth for the game-name list used by both checks below.
GAMES_LIST="tetris adventure fortune backgammon robots snake gomoku arithmetic caesar number random wump quiz cribbage battlestar factor primes morse pig rain monop phantasia atc trek sail grdc banner bcd ppt bs fish mille pom worm worms boggle canfield"

# Check CLI wrappers
CLI_GAMES=0
for game in $GAMES_LIST; do
    if [ -f "/usr/local/bin/$game" ] && grep -q "BSD Games CLI wrapper" "/usr/local/bin/$game" 2>/dev/null; then
        CLI_GAMES=$((CLI_GAMES + 1))
    fi
done

if [ $CLI_GAMES -gt 0 ]; then
    echo "   ✅ CLI wrappers installed: $CLI_GAMES games"
    echo "   🎮 Usage: tetris, fortune, adventure, etc."
else
    echo "   ❌ No CLI wrappers found"
    echo "   💡 Run: sudo ./install-cli-links.sh"
fi

# Check man pages
CLI_MANS=0
if [ -d "/usr/local/share/man/man6" ]; then
    for game in $GAMES_LIST; do
        if [ -f "/usr/local/share/man/man6/$game.6" ]; then
            CLI_MANS=$((CLI_MANS + 1))
        fi
    done
fi

if [ $CLI_MANS -gt 0 ]; then
    echo "   ✅ Man pages installed: $CLI_MANS pages"
    echo "   📖 Usage: man tetris, man fortune, etc."
else
    echo "   ❌ No man pages found in system"
    echo "   💡 Run: sudo ./install-cli-links.sh"
fi

echo ""
echo "🧪 Quick Tests:"

# Test bundle GUI launcher
echo "   Testing bundle launcher..."
if [ -x "/Applications/BSDGames.app/Contents/MacOS/bsd-games-launcher" ]; then
    TEST_OUTPUT=$(TERM=xterm /Applications/BSDGames.app/Contents/MacOS/bsd-games-launcher fortune 2>&1)
    TEST_EXIT=$?
    if [ $TEST_EXIT -eq 0 ]; then
        echo "   ✅ Bundle launcher works"
        if [ -z "$TEST_OUTPUT" ]; then
            echo "   ℹ️  (exited successfully but produced no output)"
        fi
    else
        echo "   ❌ Bundle launcher failed (exit code $TEST_EXIT)"
    fi
else
    echo "   ❌ Bundle launcher not executable"
fi

# Test CLI integration
if [ $CLI_GAMES -gt 0 ]; then
    echo "   Testing CLI integration..."
    if command -v fortune >/dev/null 2>&1; then
        CLI_TEST=$(fortune 2>&1)
        CLI_TEST_EXIT=$?
        if [ $CLI_TEST_EXIT -eq 0 ]; then
            echo "   ✅ CLI integration works"
            if [ -z "$CLI_TEST" ]; then
                echo "   ℹ️  (exited successfully but produced no output)"
            fi
        else
            echo "   ❌ CLI integration failed (exit code $CLI_TEST_EXIT)"
        fi
    else
        echo "   ❌ CLI commands not in PATH"
    fi
fi

# Test man pages
if [ $CLI_MANS -gt 0 ]; then
    echo "   Testing man pages..."
    if man fortune >/dev/null 2>&1; then
        echo "   ✅ Man pages work"
    else
        echo "   ❌ Man pages not accessible"
    fi
fi

echo ""
echo "📋 Summary:"
echo "==========="

# Overall status
if [ -d "/Applications/BSDGames.app" ] && [ $CLI_GAMES -gt 0 ] && [ $CLI_MANS -gt 0 ]; then
    echo "🎉 BSD Games is fully installed and integrated!"
    echo ""
    echo "🎮 Available interfaces:"
    echo "   • GUI: Double-click BSDGames.app in Applications"
    echo "   • CLI: Type game names directly (tetris, fortune, etc.)"
    echo "   • Help: man <game-name> for documentation"
    echo ""
    echo "📚 Popular games to try:"
    echo "   tetris        - Classic block puzzle"
    echo "   adventure     - Text adventure in Colossal Cave"
    echo "   fortune       - Random quotes and sayings"
    echo "   backgammon    - Classic board game"
    echo "   robots        - Avoid the robots"
    echo "   phantasia     - Fantasy role-playing game"
elif [ -d "/Applications/BSDGames.app" ]; then
    echo "⚠️  BSD Games bundle installed but CLI integration missing"
    echo "   Run: sudo ./install-cli-links.sh"
else
    echo "❌ BSD Games not installed"
    echo "   Run: make bundle-games && cp -R BSDGames.app /Applications/"
fi

echo ""
