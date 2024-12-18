{
  description = "ryicoh's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
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
                "postgresql@16"
                "mysql@8.0"
                "cloud-sql-proxy"
                "terraform"
                "golang"
                "ripgrep"
                "fd"
                "deno"
              ];
              casks = [
                "google-cloud-sdk"
                "hot"
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
              };
              keyboard = {
                enableKeyMapping = true;
                remapCapsLockToControl = true;
              };
            };

            security = {
              pam = {
                enableSudoTouchIdAuth = true;
              };
            };
          }
        ];
      };
    };
}
