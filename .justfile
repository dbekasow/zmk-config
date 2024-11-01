# List available recipes
default:
    @just --list

# Build firmware for both halves
build:
    nix build .#firmware

# Flash (requires bootloader mode)
flash half:
    nix run .#flash -- {{half}}

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
