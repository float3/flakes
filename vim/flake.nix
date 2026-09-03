{
  description = "hill vim config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fish-flake.url = "github:float3/flakes?dir=fish";
  };
  outputs = {
    self,
    flake-utils,
    fish-flake,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          # copilot.vim is unfree
          config.allowUnfree = true;
        };
        myFish = fish-flake.packages.${system}.fish;
        mods = pkgs.callPackage ./settings {inherit myFish;};
      in {
        defaultPackage = pkgs.callPackage ./default.nix {
          inherit mods;
        };
      }
    );
}
