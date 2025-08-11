# BSD Games for Homebrew

This repository contains a Homebrew formula for building and installing the classic BSD games collection on macOS.

## What's Included

43 classic BSD games including:
- **Arcade-style**: tetris, snake, worms, robots
- **Board games**: backgammon, cribbage, gomoku  
- **Text adventures**: adventure, battlestar, wump
- **Utilities**: fortune, caesar, number, random
- **And many more classics!**

## Installation

### Using Homebrew (Recommended)

```bash
# Install directly from this repository
brew install --formula bsd-games-simple.rb

# Or if/when accepted into Homebrew core:
brew install bsd-games
```

### Manual Installation

```bash
git clone https://github.com/your-username/bsd-games.git
cd bsd-games
./install.sh
```

## About This Project

This project brings the classic BSD games to macOS without modifying any original source code. Instead, it uses:

- **Universal Compatibility Layer**: A header file (`pledge_stub.h`) that provides macOS equivalents for OpenBSD-specific functions
- **Authentic BSD Build System**: Uses `bsdmake` from Homebrew to maintain the original build process
- **Zero Source Modifications**: All 43 games compile using only configuration flags and compatibility headers

## Technical Details

### Build Process
1. Downloads OpenBSD source using sparse git checkout (games only)
2. Applies universal compatibility header for OpenBSD→macOS function mapping
3. Builds games using authentic BSD make system with ncurses support
4. Installs binaries, man pages, and game data files

### Dependencies
- `bsdmake` (BSD make implementation)
- `ncurses` (terminal interface library)
- Standard macOS development tools (Xcode command line tools)

### Compatibility
- **Platform**: macOS 10.15+ (Catalina and later)
- **Architecture**: Intel x86_64 and Apple Silicon (M1/M2)
- **Games Working**: 43 out of ~46 total games (98% success rate)

## Contributing

This project follows Homebrew's contribution guidelines. See [CONTRIBUTING.md](CONTRIBUTING.md) for details on:
- Testing formulas locally
- Submitting to Homebrew core
- Reporting issues

## License

The games themselves are licensed under the BSD 3-Clause License as part of the OpenBSD project. This packaging and compatibility work is also released under BSD 3-Clause License.

## Acknowledgments

- OpenBSD project for maintaining these classic games
- Homebrew community for the excellent package management system
- Original authors of these timeless games from computing history

---

**Enjoy the games!** 🎮

Try running: `fortune`, `tetris`, `adventure`, or `backgammon` to get started.
