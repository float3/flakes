{
  description = "hill waybar flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          waybar = pkgs.writeShellScriptBin "waybar" ''
            exec ${pkgs.waybar}/bin/waybar \
              --config ${./config} \
              --style ${./style.css} "$@"
          '';
          default = waybar;
        };
      }
    );
}
