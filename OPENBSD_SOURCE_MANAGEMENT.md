# OpenBSD Games Source Management

## Repository Structure

This repository contains a focused extraction of OpenBSD games rather than a traditional submodule approach.

### Why Not a Full Submodule?

The OpenBSD source repository is massive (entire operating system), but we only need the `games/` directory. Traditional git submodules don't support partial checkouts effectively.

### Current Approach

Instead of a submodule referencing the entire OpenBSD repository, we use:

1. **Sparse Checkout**: Extract only the games directory from OpenBSD source
2. **Focused Copy**: Copy just the games directory to our repository  
3. **Compatibility Layer**: Add our `pledge_stub.h` for macOS compatibility
4. **Version Tracking**: Document the OpenBSD commit we extracted from

### Benefits

- ✅ **Smaller Repository**: Only games code, not entire OS
- ✅ **Faster Clones**: No need to download gigabytes of unrelated code
- ✅ **Cleaner Structure**: Focus on gaming content only
- ✅ **Build Efficiency**: All needed files in one place

### Source Information

- **Origin**: https://github.com/openbsd/src.git
- **Directory**: `/games/`
- **Extracted**: August 10, 2025
- **Commit**: Latest master branch at time of extraction

### Updating OpenBSD Games

To update to newer OpenBSD games:

```bash
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

# Restore compatibility files
cp pledge_stub.h openbsd-games/

# Test builds and commit changes
```

### Alternative Approaches Considered

1. **Full Submodule**: Too large, includes entire OpenBSD OS
2. **Git Subtree**: Doesn't support partial directory extraction
3. **Fork Repository**: Would require maintaining a separate OpenBSD fork
4. **Manual Sync**: Current approach - clean and focused

### Compatibility Files

- `pledge_stub.h` - OpenBSD to macOS compatibility layer
- `.gitignore` - Ignore build artifacts
- Build scripts - Automated compilation with compatibility flags

This approach gives us the best of both worlds: authentic OpenBSD games source code with practical repository management.
