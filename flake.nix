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
    };
    gamedownsights = {
      url = "github:eth-p/gamedownsights";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-forceblur = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs: rec
    {

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
        externals = (prev: final: {
          kde-kwin-effects-forceblur-wayland = inputs.kwin-effects-forceblur.packages.${prev.system}.default;
          kde-kwin-effects-forceblur-x11 = inputs.kwin-effects-forceblur.packages.${prev.system}.x11;
        });
      };

      # nixosModules provides NixOS modules.
      nixosModules = {
        my-nixos = {
          imports = (import ./modules);
        };
      };
    };
}
