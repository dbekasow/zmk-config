{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    zmk-nix.url = "github:lilyinstarlight/zmk-nix";
    zmk-nix.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks-nix.url = "github:cachix/git-hooks.nix";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks-nix.flakeModule
        ./pkgs
      ];
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = { config, lib, pkgs, self', inputs', ... }:
        let
          inherit (inputs') zmk-nix;
        in
        {
          packages = rec {
            firmware = zmk-nix.legacyPackages.buildSplitKeyboard {
              name = "sweep-firmware";

              src = lib.sourceFilesBySuffices ./. [ ".conf" ".dtsi" ".h" ".keymap" ".yml" ];

              board = "nice_nano_v2";
              shield = "splitkb_aurora_sweep_%PART%";

              zephyrDepsHash = "sha256-Xfu6eWmAOE/ZcY5XszdD0YHaGK1eIoydcd5TTh8spPw=";

              meta = with lib; {
                description = "Firmware for my sweep keyboard";
                platforms = platforms.all;
                license = licenses.mit;
              };
            };
            flash = zmk-nix.packages.flash.override { inherit firmware; };
            inherit (zmk-nix.packages) update;

            draw-keymap = pkgs.callPackage ./lib/draw-keymap.nix {
              inherit (self'.packages) keymap-drawer;
              src = ./.;
              keymap = "splitkb_aurora_sweep.keymap";
            };
          };
          pre-commit = {
            check.enable = true;
            settings.hooks = {
              commitizen.enable = true;
              nixpkgs-fmt.enable = true;
              typos.enable = true;
              yamlfmt.enable = true;
            };
          };
          devShells.default = pkgs.mkShell {
            name = "zmk-config";
            inputsFrom = [
              config.pre-commit.devShell
              zmk-nix.devShells.default
            ];
          };
        };
    };
}
