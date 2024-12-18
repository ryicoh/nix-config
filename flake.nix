{
  description = "ryicoh's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin } @ inputs: let
    system = "aarch64-darwin";
    user = "ryicoh";
    pkgs = import nixpkgs {
      inherit system;
    }; in {

    packages.${system}.default = pkgs.buildEnv {
      name = "default";
      paths = with nixpkgs.legacyPackages.${system}; [
        nodejs_22

        postgresql_16_jit
        mysql80

        google-cloud-sdk
        google-cloud-sql-proxy
      ];
    };

    darwinConfigurations.default = nix-darwin.lib.darwinSystem {
      system = system;
      modules = [{
        nix = {
          optimise.automatic = true;
          settings = {
            experimental-features = "nix-command flakes";
            max-jobs = 8;
          };
        };

        system = {
          stateVersion = 5;
          defaults = {
            finder = {
              AppleShowAllFiles = true;
              AppleShowAllExtensions = true;
            };
            dock = {
              autohide = true;
              orientation = "right";
            };
          };
        };

        # services = {
        #   mysql80 = {
        #     enable = true;
        #     package = nixpkgs.legacyPackages.${system}.mysql80;
        #   };
        # };
      }];
    };
  };
}
