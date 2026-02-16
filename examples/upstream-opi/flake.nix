{
  description = "NixOS configuration for RK3588";

  inputs = {
    nixpkgs.url = "github:NikitosKey/nixpkgs/patch-1";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils, ... }:
    {
      ## System config, use with nixos-rebuild
      nixosConfigurations = {
        orangepi5ultra = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./sdcard.nix
            ./hardware-configuration.nix
            ./configuration.nix
          ];
          specialArgs = {
            inherit nixpkgs;
          };
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
    {
      packages = {
        sdImage = self.nixosConfigurations.orangepi5ultra.config.system.build.sdImage;
      };
    });
}
