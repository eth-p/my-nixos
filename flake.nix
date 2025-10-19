# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
{
  description = ''
    Flake containing NixOS modules used to configure my machines.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gamedownsights = {
      url = "github:eth-p/gamedownsights";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, ... }@inputs: {

    # lib provides reusable library functions.
    lib = (import ./lib/nix) ({
      lib = nixpkgs.lib;
      my-nixos = self;
    } // inputs);

    # nixosModules provides NixOS modules.
    nixosModules = {
      my-nixos = {
        imports = [
          ./desktop
          ./drivers
          ./hardware
          ./programs
          ./services
          ./boot
          ./linux
          ./network
        ];
      };
    };
  };
}
