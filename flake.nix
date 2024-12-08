{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    zmk-nix.url = "github:lilyinstarlight/zmk-nix";
    zmk-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./pkgs ];
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = { config, lib, pkgs, self', inputs', ... }: {
        packages = {
          firmware = inputs'.zmk-nix.legacyPackages.buildSplitKeyboard {
            name = "firmware";

            src = lib.sourceFilesBySuffices ./. [ ".conf" ".dtsi" ".h" ".keymap" ".yml" ];

            board = "nice_nano_v2";
            shield = "splitkb_aurora_sweep_%PART%";

            zephyrDepsHash = "sha256-emzZ7n/yLnr75/gpkcw++98Daj1DA/ayJt+OFrNOiQE=";

            meta = with lib; {
              description = "Firmware for my sweep keyboard";
              platforms = platforms.all;
              license = licenses.mit;
            };
          };
          flash = inputs'.zmk-nix.packages.flash.override { inherit (config.packages) firmware; };
          inherit (inputs'.zmk-nix.packages) update;

          draw-keymap = pkgs.callPackage ./lib/draw-keymap.nix {
            inherit (self'.packages) keymap-drawer;
            src = ./.;
            keymap = "splitkb_aurora_sweep.keymap";
          };
        };

        devShells.default = inputs'.zmk-nix.devShells.default;
      };
    };
}
