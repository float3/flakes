{
  description = "hill vscode config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    fish-flake = {
      url = "github:float3/flakes?dir=fish";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    fish-flake,
    nix-vscode-extensions,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      allExtensions = nix-vscode-extensions.extensions.${system};
      myVSCode = pkgs.vscode-with-extensions.override {
        vscodeExtensions = with allExtensions.vscode-marketplace; [
          arcticicestudio.nord-visual-studio-code
          coder.coder-remote
          eamodio.gitlens
          github.codespaces
          github.copilot
          jnoortheen.nix-ide
          mkhl.direnv
          ms-azuretools.vscode-docker
          ms-kubernetes-tools.vscode-kubernetes-tools
          ms-python.python
          pkgs.vscode-extensions.ms-vscode-remote.remote-containers
          pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
          shardulm94.trailing-spaces
          tailscale.vscode-tailscale
          timonwong.shellcheck
          vscodevim.vim
        ];
      };

      myFish = fish-flake.packages.${system}.fish;
      fishProfile = {
        "fish" = {
          "path" = "${myFish}/bin/fish";
        };
      };
      vscode-keybindings = pkgs.writeText "keybindings.json" (builtins.toJSON [
        {
          key = "ctrl+t";
          command = "workbench.action.terminal.toggleTerminal";
        }
        {
          key = "ctrl+w h";
          command = "workbench.action.focusLeftGroup";
        }
        {
          key = "ctrl+w l";
          command = "workbench.action.focusRightGroup";
        }
        {
          key = "ctrl+w j";
          command = "workbench.action.focusBelowGroup";
        }
        {
          key = "ctrl+w k";
          command = "workbench.action.focusAboveGroup";
        }
        {
          key = "ctrl+w s";
          command = "workbench.action.splitEditorDown";
        }
        {
          key = "ctrl+w v";
          command = "workbench.action.splitEditorRight";
        }
        {
          key = "g a";
          command = "git.stage";
          when = "vim.mode == 'Normal' && !terminalFocus";
        }
        {
          key = "ctrl+w w";
          command = "workbench.action.focusNextPart";
        }
        {
          key = "ctrl+n";
          command = "workbench.action.toggleSidebarVisibility";
        }
        {
          key = "ctrl+a shift+\\";
          command = "workbench.action.terminal.split";
          when = "terminalFocus";
        }
      ]);

      vscode-settings = pkgs.writeText "settings.json" (builtins.toJSON {
        # Privacy/telemetry settings
        "clangd.checkUpdates" = false;
        "code-runner.enableAppInsights" = false;
        "docker-explorer.enableTelemetry" = false;
        "extensions.ignoreRecommendations" = true;
        "gitlens.showWelcomeOnInstall" = false;
        "gitlens.showWhatsNewAfterUpgrades" = false;
        "java.help.firstView" = "none";
        "java.help.showReleaseNotes" = false;
        "julia.enableTelemetry" = false;
        "kite.showWelcomeNotificationOnStartup" = false;
        "liveServer.settings.donotShowInfoMsg" = true;
        "Lua.telemetry.enable" = false;
        "material-icon-theme.showWelcomeMessage" = false;
        "pros.showWelcomeOnStartup" = false;
        "pros.useGoogleAnalytics" = false;
        "redhat.telemetry.enabled" = false;
        "remote.SSH.useLocalServer" = false;
        "rpcServer.showStartupMessage" = false;
        "shellcheck.disableVersionCheck" = true;
        "sonarlint.disableTelemetry" = true;
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;
        "telemetry.telemetryLevel" = "off";
        "terraform.telemetry.enabled" = false;
        "update.showReleaseNotes" = false;
        "vsicons.dontShowNewVersionMessage" = true;
        "workbench.welcomePage.walkthroughs.openOnInstall" = false;
        # Explorer
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        # Appearance settings
        "editor.fontFamily" = "'MonaSpace Neon','JetBrainsMono Nerd Font Mono', 'monospace', 'Droid Sans Mono', 'monospace', 'Droid Sans Fallback'";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 16;
        "editor.formatOnSave" = true;
        "editor.inlineSuggest.enabled" = true;
        "editor.lineNumbers" = "relative";
        "editor.minimap.enabled" = true;
        "editor.minimap.renderCharacters" = true;
        # "workbench.activityBar.location" = "bottom";
        "workbench.colorTheme" = "Default High Contrast";
        "workbench.remoteIndicator.showExtensionRecommendations" = false;
        "workbench.reduceMotion" = true;
        "workbench.startupEditor" = "readme";
        "workbench.statusBar.visible" = true;
        "workbench.tips.enabled" = true;
        "workbench.tree.indent" = 4;
        # Terminal settings
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.defaultProfile.osx" = "fish";
        "terminal.integrated.fontSize" = 16;
        "terminal.integrated.macOptionIsMeta" = true;
        "terminal.integrated.profiles.linux" = fishProfile;
        "terminal.integrated.profiles.osx" = fishProfile;
        "terminal.integrated.shellIntegration.enabled" = true;
        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.defaultBranch" = "master";
        "git.enableSmartCommit" = true;
        "git.openRepositoryInParentFolders" = "always";
        # Vim settings
        "vim.camelCaseMotion.enable" = true;
        "vim.enableNeovim" = true;
        "vim.highlightedyank.enable" = true;
        "vim.replaceWithRegister" = true;
        "vim.shell" = "${pkgs.bash}/bin/bash";
        "vim.sneak" = true;
        "vim.targets.enable" = true;
        "vim.useSystemClipboard" = true;
        "vim.neovimConfigPath" = "~/.config/nvim/init.vim";
        # Nix settings
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        # Misc settings
        "cmake.configureOnOpen" = true;
        "debug.console.wordWrap" = true;
        "diffEditor.codeLens" = true;
        "diffEditor.ignoreTrimWhitespace" = false;
        "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";
        "security.workspace.trust.enabled" = true; # Required for direnv
        "trailing-spaces.deleteModifiedLinesOnly" = true;
        "trailing-spaces.highlightCurrentLine" = false;
        "trailing-spaces.includeEmptyLines" = true;
        "trailing-spaces.trimOnSave" = true;
        "update.mode" = "none";
        # Extension settings
        "extensions.autoUpdate" = false;
        "github.copilot.editor.enableAutoCompletions" = true;
        "markdown.extension.toc.slugifyMode" = "zola";
        # Languages
        "javascript;updateImportsOnFileMove;enabled" = "always";
        "typescript;updateImportsOnFileMove;enabled" = "always";
        "isort;args" = ["--profile" "black"];
        "[javascript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "[markdown]" = {
          "editor.wordWrap" = "off";
        };
        "[python]" = {
          "editor.formatOnType" = true;
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.formatOnSave" = true;
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = "explicit";
          };
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        # "settingsSync.ignoredExtensions" = [
        #   "visualstudiotoolsforunity.vstuc"
        #   "github.copilot-chat"
        #   "github.copilot"
        # ];
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "markdown" = true;
          "scminput" = false;
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[css]" = {
          "editor.defaultFormatter" = "vscode.css-language-features";
        };
        "[scss]" = {
          "editor.defaultFormatter" = "vscode.css-language-features";
        };
        "[nix]" = {
        };
        "[csharp]" = {
          "editor.defaultFormatter" = "ms-dotnettools.csharp";
        };
      });

      userDir = pkgs.stdenv.mkDerivation {
        name = "userDir";
        builder = pkgs.bash;
        args = ["-c" "${pkgs.coreutils}/bin/mkdir -p $out; ${pkgs.coreutils}/bin/cp ${vscode-settings} $out/settings.json; ${pkgs.coreutils}/bin/cp ${vscode-keybindings} $out/keybindings.json"];
      };
      hill-vscode = pkgs.writeShellScriptBin "code" ''
        dataDir="$HOME/Documents/hill-code"
        mkdir -p "$dataDir/User"
        rm "$dataDir/User/settings.json" &>/dev/null || true
        rm "$dataDir/User/keybindings.json" &>/dev/null || true
        ln -s ${userDir}/settings.json "$dataDir/User/settings.json"
        ln -s ${userDir}/keybindings.json "$dataDir/User/keybindings.json"
        ${myVSCode}/bin/code --user-data-dir "$dataDir" $@
      '';
    in {
      packages = {
        user-dir = userDir;
        code-bin = myVSCode;
        default = hill-vscode;
      };
    });
}
