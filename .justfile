# List available recipes
default:
    @just --list

# Build firmware for both halves
build:
    nix build .#firmware

# Flash left half (requires bootloader mode)
flash-left:
    nix run .#flash -- --part left

# Flash right half (requires bootloader mode)
flash-right:
    nix run .#flash -- --part right

# Update West dependencies
update:
    nix run .#update

#  keymap visualization
keymap: 
    nix build .#draw-keymap

# Clean build artifacts
clean:
    rm -rf result

# Run direnv allow
allow:
    direnv allow

# Update nix flake inputs
upgrade:
    nix flake update

# Format nix files
fmt:
    nixpkgs-fmt .

# Check nix files formatting
fmt-check:
    nixpkgs-fmt --check .
