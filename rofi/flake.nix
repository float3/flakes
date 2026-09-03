{
  description = "hill rofi flake";

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

        # The dotfiles version of this pointed at
        # /run/current-system/sw/share/rofi/themes/fancy.rasi, which only
        # resolves on a NixOS host that happens to have rofi installed
        # system-wide. Referencing the package directly works anywhere.
        config = pkgs.writeText "config.rasi" ''
          @theme "${pkgs.rofi}/share/rofi/themes/fancy.rasi"
        '';
      in {
        packages = rec {
          rofi = pkgs.writeShellScriptBin "rofi" ''
            exec ${pkgs.rofi}/bin/rofi -config ${config} "$@"
          '';
          default = rofi;
        };
      }
    );
}
