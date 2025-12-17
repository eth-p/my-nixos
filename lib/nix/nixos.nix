# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Helpers for creating a NixOS system flake using my-nixos.
# ==============================================================================
{ my-nixos, nixpkgs, ... }@inputs: {

  # mkNixSystem provides a way to create a NixOS system
  # without having to set up all the manual boilerplate.
  mkNixSystem = { hostname, stateVersion, modules }:
    nixpkgs.lib.nixosSystem {
      modules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        my-nixos.nixosModules.my-nixos

        {
          networking.hostName = hostname;
          system.stateVersion = stateVersion;
        }

        (inputs: {
          nixpkgs.overlays = [
            my-nixos.overlays.default
            my-nixos.inputs.nix-cachyos-kernel.overlay
          ];
        })
      ] ++ modules;

      specialArgs = { my-nixos = my-nixos // { inherit inputs; }; };
    };

}
