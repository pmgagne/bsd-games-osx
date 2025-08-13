#!/bin/bash
# Install CLI access to BSD Games bundle

BUNDLE_PATH="/Applications/BSDGames.app/Contents/MacOS"
CLI_PATH="/usr/local/bin"

if [ ! -d "$BUNDLE_PATH" ]; then
    echo "Error: BSDGames.app not found in /Applications/"
    echo "Please install BSDGames.app to /Applications/ first"
    exit 1
fi

echo "Installing CLI access for BSD Games..."
mkdir -p "$CLI_PATH"

# Create symlinks for all games
for game in "$BUNDLE_PATH"/*; do
    if [ -x "$game" ] && [ "$(basename "$game")" != "bsd-games-launcher" ]; then
        game_name="$(basename "$game")"
        ln -sf "$game" "$CLI_PATH/$game_name"
        echo "   ✅ Linked $game_name"
    fi
done

echo ""
echo "🎉 CLI access installed!"
echo "You can now run games directly from the command line:"
echo "   tetris, adventure, fortune, backgammon, etc."
