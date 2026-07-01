#!/bin/bash
# BSD Games CLI Installation Script
# Creates wrapper scripts for bundle games in /usr/local/bin

set -e

BUNDLE_PATH="/Applications/BSDGames.app/Contents/MacOS"
MAN_SOURCE="/Applications/BSDGames.app/Contents/Man"
TARGET_DIR="/usr/local/bin"
MAN_TARGET="/usr/local/share/man"

echo "🔗 BSD Games CLI Wrapper Installer"
echo "=================================="
echo ""

# Check if bundle exists
if [ ! -d "$BUNDLE_PATH" ]; then
    echo "❌ Error: BSDGames.app not found in /Applications/"
    echo "   Please install BSDGames.app to /Applications/ first"
    echo ""
    echo "   You can install it by running:"
    echo "   make bundle-games && cp -R BSDGames.app /Applications/"
    exit 1
fi

# Check if target directory exists, create if it doesn't
if [ ! -d "$TARGET_DIR" ]; then
    echo "📁 Creating $TARGET_DIR directory..."
    mkdir -p "$TARGET_DIR"
fi

# Check if man directory exists, create if it doesn't
if [ ! -d "$MAN_TARGET" ]; then
    echo "📁 Creating $MAN_TARGET directory..."
    mkdir -p "$MAN_TARGET"
fi

# Check write permissions
if [ ! -w "$TARGET_DIR" ] || [ ! -w "$MAN_TARGET" ]; then
    echo "⚠️  Warning: No write permission to $TARGET_DIR or $MAN_TARGET"
    echo "   This script needs to create wrapper scripts and install man pages"
    echo "   You may need to run with sudo:"
    echo "   sudo $0"
    exit 1
fi

echo "📦 Bundle found: $BUNDLE_PATH"
echo "🎯 Target directory: $TARGET_DIR"
echo ""

# Writes a wrapper script for $1 (game name) at $2 (target path) and marks it
# executable. Used both for fresh installs and for replacing a broken symlink.
write_wrapper() {
    local game_name="$1"
    local target_link="$2"
    cat > "$target_link" << EOF
#!/bin/bash
# BSD Games CLI wrapper for $game_name
cd "$BUNDLE_PATH" || { echo "BSDGames.app not found at $BUNDLE_PATH - was it moved or removed?" >&2; exit 1; }
exec "./$game_name" "\$@"
EOF
    chmod +x "$target_link"
}

# Count games
GAME_COUNT=0
LINK_COUNT=0
SKIP_COUNT=0
COLLISION_COUNT=0

echo "🔍 Scanning for games..."
for game_path in "$BUNDLE_PATH"/*; do
    if [ -x "$game_path" ] && [ -f "$game_path" ]; then
        game_name=$(basename "$game_path")
        
        # Skip the launcher script itself
        if [ "$game_name" = "bsd-games-launcher" ]; then
            continue
        fi
        
        GAME_COUNT=$((GAME_COUNT + 1))
        target_link="$TARGET_DIR/$game_name"
        
        # Check if wrapper script already exists
        if [ -L "$target_link" ] && [ ! -e "$target_link" ]; then
            # Broken/dangling symlink left behind by another tool - remove it so
            # we can install our wrapper in its place.
            echo "   🔧 $game_name (removing broken symlink, installing wrapper)"
            rm "$target_link"
            write_wrapper "$game_name" "$target_link"
            LINK_COUNT=$((LINK_COUNT + 1))
        elif [ -f "$target_link" ]; then
            # Check if it's our wrapper script
            if grep -q "BSD Games CLI wrapper" "$target_link" 2>/dev/null; then
                echo "   ✅ $game_name (wrapper already exists)"
                SKIP_COUNT=$((SKIP_COUNT + 1))
            else
                echo "   ⚠️  $game_name (name taken by an unrelated file, NOT installed)"
                COLLISION_COUNT=$((COLLISION_COUNT + 1))
            fi
        else
            echo "   🔗 $game_name (creating wrapper script)"
            write_wrapper "$game_name" "$target_link"
            LINK_COUNT=$((LINK_COUNT + 1))
        fi
    fi
done

echo ""
echo "📖 Installing man pages..."
MAN_INSTALLED=0
MAN_SKIPPED=0

# Install man pages
if [ -d "$MAN_SOURCE/man6" ]; then
    # Create man6 directory if it doesn't exist
    mkdir -p "$MAN_TARGET/man6"
    
    for man_file in "$MAN_SOURCE/man6"/*.6; do
        if [ -f "$man_file" ]; then
            man_name=$(basename "$man_file")
            target_man="$MAN_TARGET/man6/$man_name"
            
            if [ -f "$target_man" ]; then
                # Check if it's the same file
                if cmp -s "$man_file" "$target_man" 2>/dev/null; then
                    echo "   ✅ $man_name (already installed)"
                    MAN_SKIPPED=$((MAN_SKIPPED + 1))
                else
                    echo "   🔄 $man_name (updating)"
                    cp "$man_file" "$target_man"
                    MAN_INSTALLED=$((MAN_INSTALLED + 1))
                fi
            else
                echo "   📖 $man_name (installing)"
                cp "$man_file" "$target_man"
                MAN_INSTALLED=$((MAN_INSTALLED + 1))
            fi
        fi
    done
else
    echo "   ⚠️  No man pages found in bundle"
fi

echo ""
echo "📊 Installation Summary:"
echo "   Games found: $GAME_COUNT"
echo "   Wrappers created/updated: $LINK_COUNT"
echo "   Already exists/skipped: $SKIP_COUNT"
echo "   Name collisions (NOT installed): $COLLISION_COUNT"
echo "   Man pages installed: $MAN_INSTALLED"
echo "   Man pages skipped: $MAN_SKIPPED"
echo ""

if [ $COLLISION_COUNT -gt 0 ]; then
    echo "⚠️  $COLLISION_COUNT game name(s) could not be installed because an unrelated"
    echo "   command already exists with that name in $TARGET_DIR (see ⚠️ lines above)."
    echo ""
fi

if [ $LINK_COUNT -gt 0 ] || [ $MAN_INSTALLED -gt 0 ]; then
    echo "✅ CLI wrappers and man pages installed successfully!"
    echo ""
    echo "🎮 You can now run games directly from the command line:"
    echo "   tetris"
    echo "   adventure"
    echo "   fortune"
    echo "   backgammon"
    echo "   robots"
    echo "   etc..."
    echo ""
    echo "� You can now read man pages for the games:"
    echo "   man tetris"
    echo "   man adventure"
    echo "   man fortune"
    echo "   etc..."
    echo ""
    echo "�💡 To see all available games: ls $TARGET_DIR | grep -E '(tetris|adventure|fortune|backgammon|robots|snake|gomoku|arithmetic|caesar|number|random|wump|quiz|cribbage|battlestar|factor|primes|morse|pig|rain|monop|phantasia|atc|trek|sail|grdc|banner|bcd|ppt|bs|fish|mille|pom|worm|worms|boggle|canfield)'"
else
    echo "ℹ️  No new wrappers or man pages were installed (all already exist or skipped)"
fi

echo ""
echo "📝 Note: Wrappers execute games from the bundle in /Applications/BSDGames.app"
echo "   Man pages are installed to $MAN_TARGET/man6"
echo "   If you move or remove the bundle, the wrappers will fail"
echo ""
echo "🗑️  To uninstall CLI wrappers and man pages, run:"
echo "   ./uninstall-cli-links.sh"
