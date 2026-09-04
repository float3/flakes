{
  description = "hill polybar flake";

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

        polybarWithConfig = pkgs.writeShellScriptBin "polybar" ''
          export XDG_DATA_DIRS="${pkgs.monaspace}/share:${pkgs.noto-fonts-cjk-sans}/share:''${XDG_DATA_DIRS:-}"
          exec ${pkgs.polybar}/bin/polybar --config=${./config.ini} "$@"
        '';

        # The dotfiles version of this initialised `counte` but expanded
        # `$counter`, so the first bar always wrote to /tmp/polybar.log rather
        # than /tmp/polybar0.log. It also assumed polybar and xrandr were on
        # PATH; both are referenced by store path here.
        launch = pkgs.writeShellScriptBin "polybar-launch" ''
          ${pkgs.polybar}/bin/polybar-msg cmd quit || true

          counter=0
          if ${pkgs.xrandr}/bin/xrandr --query >/dev/null 2>&1; then
            for m in $(${pkgs.xrandr}/bin/xrandr --query | grep " connected" | cut -d" " -f1); do
              MONITOR="$m" ${polybarWithConfig}/bin/polybar bar1 \
                2>&1 | tee -a "/tmp/polybar$counter.log" & disown
              counter=$((counter + 1))
            done
          else
            ${polybarWithConfig}/bin/polybar bar1 2>&1 | tee -a /tmp/polybar0.log & disown
          fi

          echo "Bars launched..."
        '';
      in {
        packages = rec {
          polybar = pkgs.symlinkJoin {
            name = "polybar-configured";
            paths = [polybarWithConfig launch];
          };
          default = polybar;
        };
      }
    );
}
