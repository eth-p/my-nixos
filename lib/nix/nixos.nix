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
        inputs.chaotic.nixosModules.nyx-cache
        inputs.chaotic.nixosModules.nyx-overlay
        inputs.chaotic.nixosModules.nyx-registry

        my-nixos.nixosModules.my-nixos

        {
          networking.hostName = hostname;
          system.stateVersion = stateVersion;
        }

        (inputs: {
          nixpkgs.overlays = [ my-nixos.overlays.default ];
        })
      ] ++ modules;

      specialArgs = { my-nixos = my-nixos // { inherit inputs; }; };
    };

}
