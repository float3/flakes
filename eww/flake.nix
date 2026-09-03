{
  description = "hill eww flake";

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

        # eww.yuck polls "scripts/getvol" relative to the config directory.
        # The dotfiles copy declared #!/bin/sh but used bash's `&>`, and relied
        # on pamixer/amixer being on PATH; both are pinned here.
        getvol = pkgs.writeShellScript "getvol" ''
          if [ "$(${pkgs.pamixer}/bin/pamixer --get-mute)" = "true" ]; then
            echo 0
          else
            ${pkgs.pamixer}/bin/pamixer --get-volume
          fi
        '';

        configDir = pkgs.runCommand "eww-config" {} ''
          mkdir -p "$out/scripts"
          cp ${./eww.yuck} "$out/eww.yuck"
          cp ${./eww.scss} "$out/eww.scss"
          cp ${getvol} "$out/scripts/getvol"
          chmod +x "$out/scripts/getvol"
        '';
      in {
        packages = rec {
          eww = pkgs.writeShellScriptBin "eww" ''
            export PATH="${pkgs.playerctl}/bin:${pkgs.coreutils}/bin:$PATH"
            exec ${pkgs.eww}/bin/eww --config ${configDir} "$@"
          '';
          default = eww;
        };
      }
    );
}
