#!/bin/bash
# Remove CLI access to BSD Games

CLI_PATH="/usr/local/bin"
BUNDLE_PATH="/Applications/BSDGames.app/Contents/MacOS"

echo "Removing CLI access for BSD Games..."

# Remove symlinks
for game in "$BUNDLE_PATH"/*; do
    if [ -x "$game" ] && [ "$(basename "$game")" != "bsd-games-launcher" ]; then
        game_name="$(basename "$game")"
        if [ -L "$CLI_PATH/$game_name" ]; then
            rm "$CLI_PATH/$game_name"
            echo "   ✅ Removed $game_name"
        fi
    fi
done

echo "🗑️  CLI access removed"
