{
  description = "hill alacritty flake";

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
          # The config asks for MonaspaceNeon, so the wrapper puts the font on
          # XDG_DATA_DIRS rather than relying on it being installed system-wide.
          alacritty = pkgs.writeShellScriptBin "alacritty" ''
            export XDG_DATA_DIRS="${pkgs.monaspace}/share:''${XDG_DATA_DIRS:-}"
            exec ${pkgs.alacritty}/bin/alacritty --config-file ${./alacritty.toml} "$@"
          '';
          default = alacritty;
        };
      }
    );
}
