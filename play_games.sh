#!/bin/bash
# BSD Games Launcher Script
# Successfully compiled vintage BSD games on macOS

echo "========================================"
echo "  Vintage BSD Games - macOS Collection"
echo "========================================"
echo ""
echo "Successfully compiled games:"
echo ""

GAMES_DIR="/Users/philippe/Documents/bsd-games/bsd-games-classic"

# Check which games are available and create a menu
games_available=()

if [ -x "$GAMES_DIR/adventure/adventure" ]; then
    echo "1. Adventure - Classic text adventure game"
    games_available[1]="$GAMES_DIR/adventure/adventure"
fi

if [ -x "$GAMES_DIR/arithmetic/arithmetic" ]; then
    echo "2. Arithmetic - Math practice game"
    games_available[2]="$GAMES_DIR/arithmetic/arithmetic"
fi

if [ -x "$GAMES_DIR/battlestar/battlestar" ]; then
    echo "3. Battlestar - Text adventure in space"
    games_available[3]="$GAMES_DIR/battlestar/battlestar"
fi

if [ -x "$GAMES_DIR/bcd/bcd" ]; then
    echo "4. BCD - Text to punch card converter"
    games_available[4]="$GAMES_DIR/bcd/bcd"
fi

if [ -x "$GAMES_DIR/backgammon/backgammon/backgammon" ]; then
    echo "5. Backgammon - Classic board game"
    games_available[5]="$GAMES_DIR/backgammon/backgammon/backgammon"
fi

if [ -x "$GAMES_DIR/backgammon/teachgammon/teachgammon" ]; then
    echo "6. Teachgammon - Learn to play backgammon"
    games_available[6]="$GAMES_DIR/backgammon/teachgammon/teachgammon"
fi

echo ""
echo "Enter the number of the game you want to play (or 'q' to quit):"
echo ""

# Function to demonstrate BCD
demo_bcd() {
    echo "BCD Demo - Converting text to punch card format:"
    echo "Enter text (or press Enter for demo):"
    read -r input
    if [ -z "$input" ]; then
        input="Hello BSD Games!"
    fi
    echo "$input" | "$GAMES_DIR/bcd/bcd"
}

# Main menu loop
while true; do
    read -r choice
    
    case $choice in
        1)
            if [ -n "${games_available[1]}" ]; then
                echo "Starting Adventure..."
                "${games_available[1]}"
            else
                echo "Adventure not available."
            fi
            ;;
        2)
            if [ -n "${games_available[2]}" ]; then
                echo "Starting Arithmetic..."
                echo "Solve math problems! (Type 'quit' to exit)"
                "${games_available[2]}"
            else
                echo "Arithmetic not available."
            fi
            ;;
        3)
            if [ -n "${games_available[3]}" ]; then
                echo "Starting Battlestar..."
                "${games_available[3]}"
            else
                echo "Battlestar not available."
            fi
            ;;
        4)
            if [ -n "${games_available[4]}" ]; then
                demo_bcd
            else
                echo "BCD not available."
            fi
            ;;
        5)
            if [ -n "${games_available[5]}" ]; then
                echo "Starting Backgammon..."
                "${games_available[5]}"
            else
                echo "Backgammon not available."
            fi
            ;;
        6)
            if [ -n "${games_available[6]}" ]; then
                echo "Starting Teachgammon..."
                "${games_available[6]}"
            else
                echo "Teachgammon not available."
            fi
            ;;
        q|Q|quit|exit)
            echo "Thanks for playing!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number from the list above or 'q' to quit."
            ;;
    esac
    
    echo ""
    echo "Press Enter to return to menu..."
    read -r
    echo ""
    echo "Enter the number of the game you want to play (or 'q' to quit):"
done
