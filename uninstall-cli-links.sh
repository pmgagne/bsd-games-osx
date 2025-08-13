#!/bin/bash
# BSD Games CLI Uninstall Script
# Removes wrapper scripts for BSD Games from /usr/local/bin

set -e

BUNDLE_PATH="/Applications/BSDGames.app/Contents/MacOS"
TARGET_DIR="/usr/local/bin"
MAN_TARGET="/usr/local/share/man"

echo "🗑️  BSD Games CLI Wrapper Uninstaller"
echo "====================================="
echo ""

# Check write permissions
if [ ! -w "$TARGET_DIR" ] || [ ! -w "$MAN_TARGET" ]; then
    echo "⚠️  Warning: No write permission to $TARGET_DIR or $MAN_TARGET"
    echo "   This script needs to remove wrapper scripts and man pages"
    echo "   You may need to run with sudo:"
    echo "   sudo $0"
    exit 1
fi

echo "🔍 Scanning for BSD Games wrappers in $TARGET_DIR..."
echo ""

REMOVED_COUNT=0
NOTFOUND_COUNT=0

# List of known BSD Games
GAMES="tetris adventure fortune backgammon robots snake gomoku arithmetic caesar number random wump quiz cribbage battlestar factor primes morse pig rain monop phantasia atc trek sail grdc banner bcd ppt bs fish mille pom worm worms boggle canfield cfscores mkdict mkindex strfile teachgammon unstr"

for game in $GAMES; do
    wrapper_path="$TARGET_DIR/$game"
    
    if [ -f "$wrapper_path" ]; then
        # Check if it's one of our wrapper scripts
        if grep -q "BSD Games CLI wrapper" "$wrapper_path" 2>/dev/null; then
            echo "   🗑️  Removing $game"
            rm "$wrapper_path"
            REMOVED_COUNT=$((REMOVED_COUNT + 1))
        else
            echo "   ⚠️  $game (not a BSD Games wrapper, skipping)"
            NOTFOUND_COUNT=$((NOTFOUND_COUNT + 1))
        fi
    else
        echo "   ➖ $game (not found)"
        NOTFOUND_COUNT=$((NOTFOUND_COUNT + 1))
    fi
done

echo ""
echo "📖 Removing man pages..."
MAN_REMOVED=0
MAN_NOTFOUND=0

# Remove man pages
for game in $GAMES; do
    man_path="$MAN_TARGET/man6/$game.6"
    
    if [ -f "$man_path" ]; then
        echo "   🗑️  Removing $game.6"
        rm "$man_path"
        MAN_REMOVED=$((MAN_REMOVED + 1))
    else
        echo "   ➖ $game.6 (not found)"
        MAN_NOTFOUND=$((MAN_NOTFOUND + 1))
    fi
done

echo ""
echo "📊 Uninstall Summary:"
echo "   Wrappers removed: $REMOVED_COUNT"
echo "   Wrappers not found/skipped: $NOTFOUND_COUNT"
echo "   Man pages removed: $MAN_REMOVED"
echo "   Man pages not found: $MAN_NOTFOUND"
echo ""

if [ $REMOVED_COUNT -gt 0 ] || [ $MAN_REMOVED -gt 0 ]; then
    echo "✅ BSD Games CLI wrappers and man pages removed successfully!"
    echo ""
    echo "ℹ️  The games are still available in the bundle:"
    echo "   /Applications/BSDGames.app/Contents/MacOS/bsd-games-launcher"
    echo ""
    echo "🔗 To reinstall CLI wrappers and man pages, run:"
    echo "   ./install-cli-links.sh"
else
    echo "ℹ️  No BSD Games CLI wrappers or man pages were found to remove"
fi

echo ""
