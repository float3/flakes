{
  description = "hill topgrade flake";

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
          topgrade = pkgs.writeShellScriptBin "topgrade" ''
            exec ${pkgs.topgrade}/bin/topgrade --config ${./topgrade.toml} "$@"
          '';
          default = topgrade;
        };
      }
    );
}
