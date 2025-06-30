{
  description = "ryicoh's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }@inputs:
    let
      system = "aarch64-darwin";
      user = "ryicoh";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        system = system;
        modules = [
          {
            nix = {
              optimise.automatic = true;
              settings = {
                experimental-features = "nix-command flakes";
                max-jobs = 8;
              };
            };

            homebrew = {
              enable = true;
              onActivation = {
                autoUpdate = false;
                upgrade = false;
                cleanup = "none";
              };
              taps = [
                "hashicorp/tap"
                # "homebrew/services"
                # "d12frosted/emacs-plus"
              ];
              brews = [
                "ast-grep"
                "awscli"
                "cloudflared"
                "fd"
                "ffmpeg"
                "gh"
                "git"
                "git-absorb"
                "hashicorp/tap/terraform"
                "herdr"
                "hunk"
                "libfido2"
                "mise"
                "mysql@8.0"
                "node@26"
                "node@24"
                "openjdk"
                {
                  name = "openssh";
                  link = false;
                }
                "peco"
                "postgresql@18"
                "ripgrep"
                "tbls"
                "tmux"
                "trivy"
                "uv"
                "vim"
                "vite-plus"
                "watch"
                "worktrunk"
                "lazygit"
                "lambdalisue/cclens/cclens"

                # "corepack"
                # "git-lfs"
                # "git-revise"
                # "git-trim"
                # "nvim"
                # "agent-browser"
                # "hunk"
                # "tuicr"
                # "oven-sh/bun/bun@1.3.13"
                # "aws-cdk"
                # "bison"
                # "cloud-sql-proxy"
                # "cmake"
                # "coursier"
                # "deno"
                # "dotnet"
                # "fzf"
                # "gcc"
                # "git-flow"
                # "gnupg"
                # "golang"
                # "helm"
                # "huggingface-cli"
                # "iperf"
                # "iperf3"
                # "kubectx"
                # "kubernetes-cli"
                # "kubeseal"
                # "ollama"
                # "oven-sh/bun/bun"
                # "pinentry-mac"
                # "pkgconf"
                # "planetscale/tap/pscale"
                # "poppler"
                # "protobuf"
                # "python@3.12"
                # "rust"
                # "rustup"
                # "stern"
                # "tflint"
                # "tldr"
                # "yarn"
                # "ykman"
                # "yubikey-personalization"
                # "yubikey-personalization"
              ];
              casks = [
                "aws-vpn-client"
                "claude-code@latest"
                "codex"
                "cursor"
                "gcloud-cli"
                "google-chrome"
                "hot"
                "iterm2"
                "libreoffice"
                "notunes"
                "rectangle"
                "scroll-reverser"
                "slack"
                "tailscale-app"
                "typeless"

                # "chatgpt"
                # "claude"
                # "cloudflare-warp"
                # "cmux"
                # "codex-app"
                # "d12frosted/emacs-plus/emacs-plus-app"
                # "datagrip"
                # "dbeaver-community"
                # "docker-desktop"
                # "emacs-plus"
                # "eqmac"
                # "fanny"
                # "ghostty"
                # "herdr-app"
                # "intellij-idea"
                # "istat-menus"
                # "keycastr"
                # "macvim-app"
                # "microsoft-edge"
                # "openvpn-connect"
                # "stablyai/orca/orca"
                # "stablyai/orca/orca"
                # "warp"
                # "yubico-authenticator"
                # "yubico-yubikey-manager"
                # "zed"
                # "zoom"
              ];
            };

            system = {
              activationScripts.postActivation.text = ''
                postgresqlDataDir=/opt/homebrew/var/postgresql@18
                if [ -f "$postgresqlDataDir/postgresql.conf" ]; then
                  mkdir -p "$postgresqlDataDir/conf.d"
                  ln -sfn ${./postgresql-local.conf} "$postgresqlDataDir/conf.d/postgresql-local.conf"
                  postgresqlInclude="include_if_exists = 'conf.d/postgresql-local.conf'"
                  if ! grep -Fqx "$postgresqlInclude" "$postgresqlDataDir/postgresql.conf"; then
                    if [ ! -e "$postgresqlDataDir/postgresql.conf.before-nix-config" ]; then
                      cp -p "$postgresqlDataDir/postgresql.conf" "$postgresqlDataDir/postgresql.conf.before-nix-config"
                    fi
                    printf '\n%s\n' "$postgresqlInclude" >> "$postgresqlDataDir/postgresql.conf"
                  fi
                fi
              '';
              stateVersion = 5;
              defaults = {
                NSGlobalDomain = {
                  "com.apple.trackpad.scaling" = 0.6875;
                  "ApplePressAndHoldEnabled" = false;
                  InitialKeyRepeat = 10;
                  KeyRepeat = 1;
                };
                finder = {
                  AppleShowAllFiles = true;
                  AppleShowAllExtensions = true;
                };
                dock = {
                  autohide = true;
                  orientation = "right";
                  tilesize = 25;
                  magnification = true;
                  largesize = 30;
                  show-recents = true;
                  persistent-apps = [
                    "/Applications/Google Chrome.app"

                    # "/Applications/Safari.app"
                    # "/System/Applications/Mail.app"
                    # "/Applications/Cursor.app"
                    # "/Applications/DataGrip.app"
                  ];
                  persistent-others = [
                    "/Users/${user}/Documents"
                    "/Users/${user}/Downloads"
                  ];
                };
                trackpad = {
                  Clicking = true;
                };
                controlcenter = {
                  BatteryShowPercentage = true;
                  Bluetooth = true;
                  Sound = true;
                };
                alf = {
                  globalstate = 2;
                };
                CustomUserPreferences = {
                  "com.googlecode.iterm2" = builtins.fromJSON (builtins.readFile ./iterm2_preferences.json);
                  "NSGlobalDomain" = {
                    "CGDisableCursorLocationMagnification" = false;
                  };
                };
                WindowManager = {
                  EnableStandardClickToShowDesktop = false;
                };
              };
              keyboard = {
                enableKeyMapping = true;
                remapCapsLockToControl = true;
              };
            };

            power = {
              sleep = {
                computer = "never";
                display = 20;
              };
            };

            services.openssh.enable = true;

            security = {
              pam = {
                services.sudo_local.touchIdAuth = true;
              };
            };
          }
        ];
      };

      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            {
              home.stateVersion = "25.05";
              home.username = user;
              home.homeDirectory = "/Users/${user}";
              home.file."/Users/${user}/.zshenv" = {
                source = ./zshenv;
                force = true;
              };
              home.file."/Users/${user}/.zprofile" = {
                source = ./zprofile;
                force = true;
              };
              home.file."/Users/${user}/.zshrc" = {
                source = ./zshrc;
                force = true;
              };
              home.file."/Users/${user}/.gnupg/gpg-agent.conf" = {
                source = ./gpg-agent.conf;
                force = true;
              };
              home.file."/Users/${user}/.config/git/config" = {
                source = ./gitconfig;
                force = true;
              };
              home.file."/Users/${user}/.config/git/ignore" = {
                source = ./gitignore;
                force = true;
              };
              home.file."/Users/${user}/.ssh/config" = {
                source = ./ssh_config;
                force = true;
              };
              home.file."/Users/${user}/Library/Application Support/Cursor/User/settings.json" = {
                source = ./cursor_settings.json;
                force = true;
              };
              home.file."/Users/${user}/Library/Application Support/Cursor/User/keybindings.json" = {
                source = ./cursor_keybindings.json;
                force = true;
              };
              home.file."/Users/${user}/.config/worktrunk/config.toml" = {
                source = ./worktrunk_config.toml;
                force = true;
              };
              home.file."/Users/${user}/.config/herdr/config.toml" = {
                source = ./herdr_config.toml;
                force = true;
              };
              home.file."/Users/${user}/.tmux.conf" = {
                source = ./tmux.conf;
                force = true;
              };
              home.file."/Users/${user}/.vimrc" = {
                source = ./vimrc;
                force = true;
              };
              home.file."/Users/${user}/.local/bin/git-rebase-editor.sh" = {
                source = ./git-rebase-editor.sh;
                executable = true;
                force = true;
              };
            }
          ];
        };
      };
    };
}
