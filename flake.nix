# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
{
  description = ''
    Flake containing NixOS modules used to configure my machines.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gamedownsights = {
      url = "github:eth-p/gamedownsights";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    rec {

      # lib provides reusable library functions.
      lib = (import ./lib/nix) (
        {
          lib = nixpkgs.lib;
          my-nixos = self;
        }
        // inputs
      );

      # overlays provides nixpkgs overlays.
      overlays = {
        default = prev: final: (overlays.externals prev final) // (overlays.packages prev final);

        packages = (import ./packages/overlay.nix);
        externals = (
          prev: final:
          let
            system = prev.stdenv.hostPlatform.system;
          in
          rec {
            kde-kwin-effects-better-blur-dx-wayland =
              inputs.kwin-effects-better-blur-dx.packages.${system}.default;
            kde-kwin-effects-better-blur-dx-x11 = inputs.kwin-effects-better-blur-dx.packages.${system}.x11;
            kde-kwin-effects-forceblur-wayland = kde-kwin-effects-better-blur-dx-wayland;
            kde-kwin-effects-forceblur-x11 = kde-kwin-effects-better-blur-dx-x11;
          }
        );
      };

      # nixosModules provides NixOS modules.
      nixosModules = {
        my-nixos = {
          imports = (import ./modules);
        };
      };
    };
}
