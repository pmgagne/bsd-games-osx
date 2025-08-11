#!/bin/bash
# OpenBSD Games Launcher - Successfully compiled games on macOS using config flags only

echo "======================================================="
echo "   OpenBSD Vintage Games Collection - macOS Edition"
echo "======================================================="
echo ""
echo "Successfully compiled using configuration flags only!"
echo "No source code modifications required."
echo ""

GAMES_DIR="/Users/philippe/Documents/bsd-games/openbsd-games/games"

# Successfully compiled games
echo "Available games:"
echo ""

games_available=()

if [ -x "$GAMES_DIR/adventure/adventure" ]; then
    echo " 1. Adventure - Classic Colossal Cave adventure"
    games_available[1]="$GAMES_DIR/adventure/adventure"
fi

if [ -x "$GAMES_DIR/arithmetic/arithmetic" ]; then
    echo " 2. Arithmetic - Math practice problems"
    games_available[2]="$GAMES_DIR/arithmetic/arithmetic"
fi

if [ -x "$GAMES_DIR/banner/banner" ]; then
    echo " 3. Banner - Create large text banners"
    games_available[3]="$GAMES_DIR/banner/banner"
fi

if [ -x "$GAMES_DIR/battlestar/battlestar" ]; then
    echo " 4. Battlestar - Text adventure in space"
    games_available[4]="$GAMES_DIR/battlestar/battlestar"
fi

if [ -x "$GAMES_DIR/bcd/bcd" ]; then
    echo " 5. BCD - Text to punch card converter"
    games_available[5]="$GAMES_DIR/bcd/bcd"
fi

if [ -x "$GAMES_DIR/caesar/caesar" ]; then
    echo " 6. Caesar - Caesar cipher encoder/decoder"
    games_available[6]="$GAMES_DIR/caesar/caesar"
fi

if [ -x "$GAMES_DIR/fish/fish" ]; then
    echo " 7. Fish - Go Fish card game"
    games_available[7]="$GAMES_DIR/fish/fish"
fi

if [ -x "$GAMES_DIR/mille/mille" ]; then
    echo " 8. Mille - Mille Bornes card game"
    games_available[8]="$GAMES_DIR/mille/mille"
fi

if [ -x "$GAMES_DIR/monop/monop" ]; then
    echo " 9. Monop - Monopoly board game"
    games_available[9]="$GAMES_DIR/monop/monop"
fi

if [ -x "$GAMES_DIR/morse/morse" ]; then
    echo "10. Morse - Text to Morse code converter"
    games_available[10]="$GAMES_DIR/morse/morse"
fi

if [ -x "$GAMES_DIR/number/number" ]; then
    echo "11. Number - Number to words converter"
    games_available[11]="$GAMES_DIR/number/number"
fi

if [ -x "$GAMES_DIR/pig/pig" ]; then
    echo "12. Pig - Pig Latin converter"
    games_available[12]="$GAMES_DIR/pig/pig"
fi

if [ -x "$GAMES_DIR/pom/pom" ]; then
    echo "13. Pom - Phase of moon calculator"
    games_available[13]="$GAMES_DIR/pom/pom"
fi

if [ -x "$GAMES_DIR/ppt/ppt" ]; then
    echo "14. PPT - Punched paper tape converter"
    games_available[14]="$GAMES_DIR/ppt/ppt"
fi

if [ -x "$GAMES_DIR/primes/primes" ]; then
    echo "15. Primes - Prime number generator"
    games_available[15]="$GAMES_DIR/primes/primes"
fi

if [ -x "$GAMES_DIR/quiz/quiz" ]; then
    echo "16. Quiz - Educational quiz game"
    games_available[16]="$GAMES_DIR/quiz/quiz"
fi

if [ -x "$GAMES_DIR/trek/trek" ]; then
    echo "17. Trek - Star Trek game"
    games_available[17]="$GAMES_DIR/trek/trek"
fi

if [ -x "$GAMES_DIR/wargames/wargames" ]; then
    echo "18. Wargames - Nuclear war simulation"
    games_available[18]="$GAMES_DIR/wargames/wargames"
fi

if [ -x "$GAMES_DIR/wump/wump" ]; then
    echo "19. Wump - Hunt the Wumpus game"
    games_available[19]="$GAMES_DIR/wump/wump"
fi

echo ""
echo "Enter the number of the game you want to play (or 'q' to quit):"
echo ""

# Demo functions
demo_banner() {
    echo "Banner Demo - Enter text to make a large banner:"
    read -r input
    if [ -z "$input" ]; then
        input="OpenBSD"
    fi
    "$GAMES_DIR/banner/banner" "$input"
}

demo_caesar() {
    echo "Caesar Cipher Demo - Enter text and shift amount:"
    echo "Text:"
    read -r text
    echo "Shift (1-25, 13 for ROT13):"
    read -r shift
    if [ -z "$text" ]; then
        text="HELLO WORLD"
    fi
    if [ -z "$shift" ]; then
        shift=13
    fi
    echo "$text" | "$GAMES_DIR/caesar/caesar" "$shift"
}

demo_morse() {
    echo "Morse Code Demo - Enter text to convert:"
    read -r input
    if [ -z "$input" ]; then
        input="SOS OPENBSD"
    fi
    echo "$input" | "$GAMES_DIR/morse/morse"
}

demo_bcd() {
    echo "Punch Card Demo - Enter text to convert:"
    read -r input
    if [ -z "$input" ]; then
        input="OpenBSD Games"
    fi
    "$GAMES_DIR/bcd/bcd" "$input"
}

demo_number() {
    echo "Number to Words Demo - Enter a number:"
    read -r input
    if [ -z "$input" ]; then
        input="2024"
    fi
    "$GAMES_DIR/number/number" "$input"
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
                "${games_available[2]}"
            else
                echo "Arithmetic not available."
            fi
            ;;
        3)
            if [ -n "${games_available[3]}" ]; then
                demo_banner
            else
                echo "Banner not available."
            fi
            ;;
        4)
            if [ -n "${games_available[4]}" ]; then
                echo "Starting Battlestar..."
                "${games_available[4]}"
            else
                echo "Battlestar not available."
            fi
            ;;
        5)
            if [ -n "${games_available[5]}" ]; then
                demo_bcd
            else
                echo "BCD not available."
            fi
            ;;
        6)
            if [ -n "${games_available[6]}" ]; then
                demo_caesar
            else
                echo "Caesar not available."
            fi
            ;;
        7)
            if [ -n "${games_available[7]}" ]; then
                echo "Starting Fish..."
                "${games_available[7]}"
            else
                echo "Fish not available."
            fi
            ;;
        8)
            if [ -n "${games_available[8]}" ]; then
                echo "Starting Mille..."
                "${games_available[8]}"
            else
                echo "Mille not available."
            fi
            ;;
        9)
            if [ -n "${games_available[9]}" ]; then
                echo "Starting Monop..."
                "${games_available[9]}"
            else
                echo "Monop not available."
            fi
            ;;
        10)
            if [ -n "${games_available[10]}" ]; then
                demo_morse
            else
                echo "Morse not available."
            fi
            ;;
        11)
            if [ -n "${games_available[11]}" ]; then
                demo_number
            else
                echo "Number not available."
            fi
            ;;
        12)
            if [ -n "${games_available[12]}" ]; then
                echo "Starting Pig Latin..."
                echo "Enter text (or press Enter for demo):"
                read -r input
                if [ -z "$input" ]; then
                    input="Hello OpenBSD Games"
                fi
                echo "$input" | "${games_available[12]}"
            else
                echo "Pig not available."
            fi
            ;;
        13)
            if [ -n "${games_available[13]}" ]; then
                echo "Phase of Moon:"
                "${games_available[13]}"
            else
                echo "Pom not available."
            fi
            ;;
        14)
            if [ -n "${games_available[14]}" ]; then
                echo "Starting PPT..."
                echo "Enter text for paper tape:"
                read -r input
                if [ -z "$input" ]; then
                    input="OpenBSD"
                fi
                echo "$input" | "${games_available[14]}"
            else
                echo "PPT not available."
            fi
            ;;
        15)
            if [ -n "${games_available[15]}" ]; then
                echo "Prime numbers from 1 to 100:"
                "${games_available[15]}" 1 100
            else
                echo "Primes not available."
            fi
            ;;
        16)
            if [ -n "${games_available[16]}" ]; then
                echo "Starting Quiz..."
                "${games_available[16]}"
            else
                echo "Quiz not available."
            fi
            ;;
        17)
            if [ -n "${games_available[17]}" ]; then
                echo "Starting Star Trek..."
                "${games_available[17]}"
            else
                echo "Trek not available."
            fi
            ;;
        18)
            if [ -n "${games_available[18]}" ]; then
                echo "Starting Wargames..."
                "${games_available[18]}"
            else
                echo "Wargames not available."
            fi
            ;;
        19)
            if [ -n "${games_available[19]}" ]; then
                echo "Starting Hunt the Wumpus..."
                "${games_available[19]}"
            else
                echo "Wump not available."
            fi
            ;;
        q|Q|quit|exit)
            echo "Thanks for playing OpenBSD games!"
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
