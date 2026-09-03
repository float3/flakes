# flakes

Nix flakes for a Nord-themed development environment. Each directory is a
standalone flake that can be used on its own, and the root flake re-exports
them as a single package set.

## Packages

```sh
nix build github:float3/flakes#fish
nix run   github:float3/flakes#vim
```

| Output | Directory | What it is |
| --- | --- | --- |
| `fish` | [fish](./fish) | Fish shell with the Nord theme, direnv, and helper functions |
| `git` | [git](./git) | Git configured to use the `vim` output as its editor |
| `tmux` | [tmux](./tmux) | tmux with the Nord theme |
| `vim` | [vim](./vim) | Neovim with the plugin set in [vim/settings](./vim/settings) |
| `vscode` | [vscode](./vscode) | VS Code with a pinned extension set |
| `alacritty` | [alacritty](./alacritty) | Alacritty at 75% opacity with the Monaspace font bundled |
| `mpv` | [mpv](./mpv) | mpv with the Anime4K shader set and the Ctrl+1..6 mode bindings |
| `rofi` | [rofi](./rofi) | rofi using the `fancy` theme from its own package |
| `waybar` | [waybar](./waybar) | waybar with the sway module layout and stylesheet |
| `eww` | [eww](./eww) | eww bar with its widgets, stylesheet and volume script |
| `polybar` | [polybar](./polybar) | polybar plus a `polybar-launch` multi-monitor launcher |
| `topgrade` | [topgrade](./topgrade) | topgrade with the upgrade step configuration |

## Using these from a NixOS or Home Manager config

Add the flake as an input and pull packages out of it by system:

```nix
{
  inputs.float3-flakes = {
    url = "github:float3/flakes";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

```nix
home.packages = [
  inputs.float3-flakes.packages.${pkgs.system}.fish
  inputs.float3-flakes.packages.${pkgs.system}.vim
];
```

## Development

```sh
nix flake check
nix run nixpkgs#alejandra -- .
```

CI builds every exported package on `x86_64-linux` for each pull request.

These packages carry their configuration in the Nix store, so the matching
files under `float3/.config` are redundant once you use them. The mpv flake in
particular is what supplies the Anime4K shaders that used to be vendored into
that repository.

## Licence

MIT. This repository started from [heywoodlh/flakes](https://github.com/heywoodlh/flakes);
that copyright notice is retained in [LICENSE](./LICENSE) alongside our own.
