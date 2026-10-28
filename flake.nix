{
  description = "Music Visualizer (but as a flake to experiment with nix dynamic loaders)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, self, ... }: {
    packages = builtins.mapAttrs (system: pkgs: {
      default = pkgs.callPackage ./package.nix { };
    }) nixpkgs.legacyPackages;
    devShells = builtins.mapAttrs (system: pkgs: {
      default = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.default ];
        shellHook = ''
          export NIX_CFLAGS_COMPILE="$(pkg-config --libs \
          glx) $NIX_CFLAGS_COMPILE"
        '';
        packages = with pkgs; [
          zenity
        ];
      };
    }) nixpkgs.legacyPackages;

  };
}
