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

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

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
                "homebrew/services"
              ];
              brews = [
                "node@22"
                "corepack"
                "deno"
                "golang"
                "rust"
                "dotnet"

                "planetscale/tap/pscale"
                "hashicorp/tap/terraform"
                "tflint"
                "trivy"

                "postgresql@16"
                "mysql@8.0"

                "cloud-sql-proxy"
                "awscli"

                "ripgrep"
                "fd"
                "watch"

                "poppler"

                "kubernetes-cli"
                "kubectx"
                "stern"

                # "ollama"
                "huggingface-cli"
                "poppler"
              ];
              casks = [
                "google-cloud-sdk"
                "hot"
                "keycastr"
                "libreoffice"
                "cursor"
                "datagrip"
                "dbeaver-community"
                "vlc"

              ];
            };

            system = {
              stateVersion = 5;
              defaults = {
                NSGlobalDomain = {
                  "com.apple.trackpad.scaling" = 0.6875;
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
              home.file."/Users/${user}/.config/git/ignore" = {
                source = ./gitignore;
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
