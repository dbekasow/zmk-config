{
  perSystem = { pkgs, ... }: {
    packages = {
      keymap-drawer = pkgs.python3Packages.callPackage ./keymap-drawer.nix { };
    };
  };
}
