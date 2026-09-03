{
  description = "hill fish flake";

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
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        # starship_config = pkgs.writeText "starship.toml" ''
        #   [character]
        #   success_symbol = '[❯](bold white)'

        #   [container]
        #   disabled = true
        # '';
        fish_config =
          pkgs.writeText
          "profile.fish" ''
            fish_config theme choose Nord
            set fish_greeting "\x1d"

            # Direnv
            eval (${pkgs.direnv}/bin/direnv hook fish)

            # Add ~/bin to $PATH (ALWAYS)
            if not contains $HOME/bin $PATH
                set -gx PATH $HOME/bin $PATH
            end

            # Function to add a directory to $PATH
            # Only if exists
            function add-to-path
                if not contains $argv[1] $PATH
                    set -gx PATH $argv[1] $PATH
                end
            end

            # Add direnv to $PATH
            add-to-path ${pkgs.direnv}/bin

            # Set EDITOR to nvim
            set -gx EDITOR "nvim"
            set -gx GIT_EDITOR "nvim"

            # Hammerspoon
            # add-to-path /Applications/Hammerspoon.app/Contents/Frameworks/hs

            # Custom functions

            # function op-unlock
            #     env | grep -iqE "^OP_SESSION" || eval $(${pkgs._1password}/bin/op signin)
            # end

            function geoiplookup
                ${pkgs.curl}/bin/curl -s ipinfo.io/$argv[1]
            end

            function nix-flake-init
                ${pkgs.nix}/bin/nix flake init -t gitlab:kylesferrazza/nix-flake-templates
            end

            source ${./nix.fish}

            # Always re-source ~/.config/fish/config.fish last
            # Prioritize local config
            mkdir -p ~/.config/fish
            test -e ~/.config/fish/config.fish && source ~/.config/fish/config.fish

            # Use custom config if exists
            test -e ~/.config/fish/custom.fish && source ~/.config/fish/custom.fish || true
          '';
      in {
        packages = rec {
          fish = pkgs.writeShellScriptBin "fish" ''
            ${pkgs.fish}/bin/fish --init-command="source ${fish_config}" $@
          '';
          default = fish;
        };
      }
    );
}
