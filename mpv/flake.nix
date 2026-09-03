{
  description = "hill mpv flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    anime4k = {
      url = "github:bloc97/Anime4K/v4.0.1";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    anime4k,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        # Anime4K ships its shaders under glsl/ in themed subdirectories, but
        # mpv.conf and input.conf refer to them by bare filename under
        # ~~/shaders. mpv expands ~~ to the config directory, so flattening
        # them alongside the config files is what makes those paths resolve.
        configDir = pkgs.runCommand "mpv-config" {} ''
          mkdir -p "$out/shaders"
          cp ${./mpv.conf} "$out/mpv.conf"
          cp ${./input.conf} "$out/input.conf"
          find ${anime4k}/glsl -name '*.glsl' -exec cp {} "$out/shaders/" \;
        '';
      in {
        packages = rec {
          mpv = pkgs.writeShellScriptBin "mpv" ''
            exec ${pkgs.mpv}/bin/mpv --config-dir=${configDir} "$@"
          '';
          default = mpv;
        };
      }
    );
}
