{
  description = "meta-flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    fish-flake = {
      url = "./fish";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    vim-flake = {
      url = "./vim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.fish-flake.follows = "fish-flake";
    };
    git-flake = {
      url = "./git";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.vim-flake.follows = "vim-flake";
    };
    vscode-flake = {
      url = "./vscode";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.fish-flake.follows = "fish-flake";
    };
    tmux-flake = {
      url = "./tmux";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.fish-flake.follows = "fish-flake";
    };
    vimb-flake = {
      url = "./vimb";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    gnome-flake = {
      url = "./gnome";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.fish-flake.follows = "fish-flake";
      inputs.tmux-flake.follows = "tmux-flake";
      inputs.vim-flake.follows = "vim-flake";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs-unstable,
    flake-utils,
    fish-flake,
    git-flake,
    vim-flake,
    tmux-flake,
    vscode-flake,
    vimb-flake,
    gnome-flake,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs-unstable.legacyPackages.${system};
    in {
      packages = {
        fish = fish-flake.packages.${system}.fish;
        # nushell = nushell-flake.packages.${system}.nushell;
        git = git-flake.packages.${system}.git;
        tmux = tmux-flake.packages.${system}.tmux;
        vim = vim-flake.defaultPackage.${system};
        vscode = vscode-flake.packages.${system}.default;
        vscode-userdir = vscode-flake.packages.${system}.user-dir;
        vscode-bin = vscode-flake.packages.${system}.code-bin;
        vimb = vimb-flake.packages.${system}.vimb;
        vimb-gl = vimb-flake.packages.${system}.vimb-gl;
        # op = op-flake.packages.${system}.op;
        # op-desktop-setup = op-flake.packages.${system}.op-desktop-setup;
        # nixos-vm = lima-flake.packages.${system}.lima-vm;
        # chromium-widevine = chromium-widevine-flake.packages.aarch64-linux.chromium-widevine;
        # gnome = gnome-flake.packages.${system}.gnome-desktop-setup;
        # gnome-dconf = gnome-flake.packages.${system}.dconf;
        # helix = helix-flake.packages.${system}.helix;
      };
      formatter = pkgs.alejandra;
    });
}
