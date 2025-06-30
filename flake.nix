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
                autoUpdate = true;
                upgrade = true;
                cleanup = "uninstall";
              };
              taps = [
                "hashicorp/tap"
                # "homebrew/services"
              ];
              brews = [
                # "python@3.12"
                "node@22"
                "corepack"
                # "yarn"
                "oven-sh/bun/bun"

                "gcc"
                "cmake"
                "bison"

                "git-flow"
                "git-lfs"

                # "deno"
                # "oven-sh/bun/bun"
                "golang"
                "rust"
                "rustup"
                # "dotnet"
                # "coursier"
                # "cmake"
                "protobuf"
                # "pkgconf"

                # "planetscale/tap/pscale"
                "hashicorp/tap/terraform"
                "tflint"
                "trivy"

                "postgresql@16"
                "mysql@8.0"

                "cloud-sql-proxy"
                "awscli"
                # "aws-cdk"

                "ripgrep"
                "fd"
                "watch"
                # "tldr"

                # "poppler"

                "kubernetes-cli"
                "kubectx"
                "stern"
                "helm"
                "kubeseal"

                # "gnupg"
                # "pinentry-mac"
                # "ykman"
                # "yubikey-personalization"
                "openssh"
                "libfido2"

                "tbls"

                "cloudflared"

                # "iperf"
                # "iperf3"

                # "ollama"
                # "huggingface-cli"
              ];
              casks = [
                # "cloudflare-warp"
                "gcloud-cli"
                # "keycastr"
                # "libreoffice"
                "cursor"
                "datagrip"
                # "dbeaver-community"
                "hot"
                "zoom"
                # "fanny"
                # "istat-menus"
                "aws-vpn-client"
                "openvpn-connect"
                # "microsoft-edge"
                "yubico-authenticator"
                # "yubico-yubikey-manager"
                # "eqmac"
                "docker-desktop"
                "scroll-reverser"
              ];
            };

            system = {
              stateVersion = 5;
              defaults = {
                NSGlobalDomain = {
                  "com.apple.trackpad.scaling" = 0.6875;
                  "ApplePressAndHoldEnabled" = false;
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
                    "/Applications/Safari.app"
                    "/Applications/Google Chrome.app"
                    "/Applications/Cursor.app"
                    "/Applications/DataGrip.app"
                    "/System/Applications/Mail.app"
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
              };
              keyboard = {
                enableKeyMapping = true;
                remapCapsLockToControl = true;
              };
            };

            power = {
              sleep = {
                display = 15;
              };
            };

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
              home.file."/Users/${user}/Library/Application\ Support/Cursor/User/settings.json" = {
                source = ./cursor_settings.json;
                force = true;
              };
            }
          ];
        };
      };
    };
}
