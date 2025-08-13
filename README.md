# BSD Games for macOS 🎮


A modern, configuration-only port of classic OpenBSD BSD games to macOS. No source code modifications—just compatibility stubs and authentic BSD make!


## Features

- 37+ classic BSD games, fully working on macOS
- No source code changes: all compatibility via headers and build flags
- Professional macOS .app bundle with icon, man pages, and GUI launcher
- CLI and GUI access: play from Terminal or Finder
- System-wide CLI integration: run games from anywhere (with wrappers in `/usr/local/bin`)
- Man pages for all games: accessible via `man <game>`

---

## Prerequisites

- macOS 10.15 or later (Intel or Apple Silicon)
- [Homebrew](https://brew.sh/) package manager


Install required tools:
```sh
brew install bsdmake
```

---

## Building All Games


Clone the repository and build everything:
```sh
git clone <repository-url>
cd bsd-games
make all
```

---

## Creating the macOS Application Bundle


To build the BSDGames.app bundle (with icon and GUI launcher):
```sh
make bundle
```
Copy the bundle to your Applications folder:
```sh
cp -r BSDGames.app /Applications/
```

---

## Using the Games


### From the GUI
- Double-click `BSDGames.app` in Applications.
- Select a game, then choose **Play** or **Help** (man page) in the dialog.


### From the Command Line (System-wide CLI Integration)

To run games from anywhere and access man pages, install the CLI wrappers and man pages:

```sh
sudo ./install-cli-links.sh
```


This will:
- Install wrapper scripts for all games to `/usr/local/bin` (so you can just type `tetris`, `fortune`, etc.)
- Install man pages for all games to `/usr/local/share/man/man6` (so you can use `man tetris`, `man fortune`, etc.)

**You can also run these scripts from inside the bundle:**
```sh
sudo /Applications/BSDGames.app/Contents/Resources/install-cli-links.sh
sudo /Applications/BSDGames.app/Contents/Resources/uninstall-cli-links.sh
```
These scripts are always included in the bundle for convenience.

**Examples:**
```sh
tetris           # Play tetris from any directory
fortune          # Get a random fortune
man tetris       # Read the tetris man page
```

**To uninstall all CLI wrappers and man pages:**
```sh
sudo ./uninstall-cli-links.sh
```

---

## Updating or Troubleshooting


- To clean all builds:  
  `make clean`
- To rebuild everything:  
  `make all`
- To uninstall CLI wrappers and man pages:  
  `sudo ./uninstall-cli-links.sh`

---

## Project Structure

```
bsd-games/
├── Makefile                # Master build and bundle system
├── openbsd-games/          # Original OpenBSD game sources
├── pledge_stub.h           # macOS compatibility header
├── BSDGames.app/           # macOS application bundle (after make bundle)
├── install-cli-links.sh    # CLI wrapper & man page installer
├── uninstall-cli-links.sh  # CLI wrapper & man page remover
└── icon.png                # Application icon
```

---

## OpenBSD Source Management

This repository contains a focused extraction of OpenBSD games, not a full submodule. Only the `games/` directory is included, keeping the repo small and fast to clone.

### Why Not a Full Submodule?
- The OpenBSD source repo is huge (entire OS), but we only need `games/`.
- Submodules and subtrees do not support partial checkouts well.

### Source Information
- **Origin**: https://github.com/openbsd/src.git
- **Directory**: `/games/`
- **Extracted**: August 10, 2025
- **Commit**: Latest master branch at time of extraction

### Updating OpenBSD Games
To update to newer OpenBSD games:
```sh
# Create temporary sparse checkout
 git clone --no-checkout --depth 1 --filter=blob:none https://github.com/openbsd/src.git temp-openbsd
 cd temp-openbsd
 git sparse-checkout init --cone
 git sparse-checkout set games
 git checkout

# Copy updated games
cd ..
rm -rf openbsd-games
cp -r temp-openbsd/games openbsd-games
rm -rf temp-openbsd
```

---

## Contributing

- Issues and pull requests welcome!
- See comments in `Makefile` and `pledge_stub.h` for porting details.

---

## License

- Games: Original BSD licenses
- Compatibility code: Permissive license

---


---

## Quick Start (Summary)

1. **Build and install the bundle:**
  ```sh
  make bundle
  cp -r BSDGames.app /Applications/
  ```
2. **Install CLI wrappers and man pages:**
  ```sh
  sudo ./install-cli-links.sh
  ```
3. **Play and read docs from anywhere:**
  ```sh
  tetris
  man tetris
  ```

---

*Enjoy vintage BSD gaming on your Mac!*

---
