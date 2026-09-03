{
  description = "hill git config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    vim-flake.url = "github:float3/flakes?dir=vim";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    vim-flake,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        vim = vim-flake.defaultPackage.${system};
        gitignore = pkgs.writeText "gitignore" ''
          # Direnv
          .envrc
          .direnv

          # Terraform
          **/.terraform/*
          *.tfstate
          *.tfstate.*
          crash.log
          crash.*.log
          *.tfvars
          *.tfvars.json
          override.tf
          override.tf.json
          *_override.tf
          *_override.tf.json
          .terraformrc
          terraform.rc
        '';
        gitconfig = pkgs.writeText "gitconfig" ''
          [alias]
            br = "branch"
            ci = "commit"
            cl = "clone"
            co = "checkout"
            cp = "cherry-pick"
            last = "log -1 HEAD"
            lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
            st = "status"
            unstage = "reset HEAD --"

          [color]
            ui = "auto"

          [commit]
            gpgsign = true

          [core]
            autocrlf = "input"
            editor = "${vim}/bin/vim"
            excludesFile = "${gitignore}"
            longpaths = true
            pager = "${pkgs.delta}/bin/delta"
            whitespace = "cr-at-eol"

          [delta]
            line-numbers = true
            navigate = true
            side-by-side = true

          [diff]
            colorMoved = "default"
            renames = "copies"

          [gpg]
            format = "openpgp"

          [init]
            defaultBranch = "master"

          [interactive]
            diffFilter = "${pkgs.delta}/bin/delta --color-only"

          [merge]
            conflictstyle = "diff3"

          [pull]
            rebase = false

          [push]
            autoSetupRemote = true
            default = "current"

          [rerere]
            enabled = true

          [submodule]
            recurse = true

          [user]
            email = "hill@hilll.dev"
            name = "hill"
            signingkey = "0FB811AAB9F43C98"

          # Last, so a machine-local file can override anything above.
          [include]
            path = ~/.gitconfig
            path = ~/.config/git/config
        '';
      in {
        packages = rec {
          git = pkgs.writeShellScriptBin "git" ''
            export GIT_CONFIG_GLOBAL=${gitconfig}
            ${pkgs.git}/bin/git "$@"
          '';
          default = git;
        };
      }
    );
}
