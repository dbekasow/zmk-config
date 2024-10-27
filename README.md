# Aurora Sweep

ZMK config for my Aurora Sweep keyboard using Nix to manage firmware builds.

## Keymap
![Keymap](/docs/keymap.svg)

## Requirements

- Nix with flakes enabled
- For development: [direnv](https://direnv.net/) (optional)

## Usage

### Build Firmware

```bash
# Build both halves
nix build .#firmware
```

### Flash Keyboard

```bash
# Enter bootloader mode first!
nix run .#flash -- --part left
nix run .#flash -- --part right
```

### Generate Keymap

```bash
nix build .#draw-keymap
```

## License

MIT License - See LICENSE file for details
