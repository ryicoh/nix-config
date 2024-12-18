{
  description = "ryicoh's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.buildEnv {
      name = "default";
      paths = with nixpkgs.legacyPackages.aarch64-darwin; [
        nodejs_22

        postgresql_16_jit
        mysql80

        google-cloud-sdk
        google-cloud-sql-proxy
      ];
    };
  };
}
