{
  description = "meta-flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    fish-flake = {
      url = "path:./fish";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vim-flake = {
      url = "path:./vim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fish-flake.follows = "fish-flake";
    };
    git-flake = {
      url = "path:./git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.vim-flake.follows = "vim-flake";
    };
    alacritty-flake = {
      url = "path:./alacritty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mpv-flake = {
      url = "path:./mpv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rofi-flake = {
      url = "path:./rofi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar-flake = {
      url = "path:./waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eww-flake = {
      url = "path:./eww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    polybar-flake = {
      url = "path:./polybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    topgrade-flake = {
      url = "path:./topgrade";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-flake = {
      url = "path:./tmux";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fish-flake.follows = "fish-flake";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    fish-flake,
    git-flake,
    vim-flake,
    tmux-flake,
    alacritty-flake,
    mpv-flake,
    rofi-flake,
    waybar-flake,
    eww-flake,
    polybar-flake,
    topgrade-flake,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = {
        fish = fish-flake.packages.${system}.fish;
        # nushell = nushell-flake.packages.${system}.nushell;
        git = git-flake.packages.${system}.git;
        tmux = tmux-flake.packages.${system}.tmux;
        vim = vim-flake.defaultPackage.${system};
        alacritty = alacritty-flake.packages.${system}.alacritty;
        mpv = mpv-flake.packages.${system}.mpv;
        rofi = rofi-flake.packages.${system}.rofi;
        waybar = waybar-flake.packages.${system}.waybar;
        eww = eww-flake.packages.${system}.eww;
        polybar = polybar-flake.packages.${system}.polybar;
        topgrade = topgrade-flake.packages.${system}.topgrade;
        # op = op-flake.packages.${system}.op;
        # op-desktop-setup = op-flake.packages.${system}.op-desktop-setup;
        # nixos-vm = lima-flake.packages.${system}.lima-vm;
        # chromium-widevine = chromium-widevine-flake.packages.aarch64-linux.chromium-widevine;
        # helix = helix-flake.packages.${system}.helix;
      };
      formatter = pkgs.alejandra;
    });
}
