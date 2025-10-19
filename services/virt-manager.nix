# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# virt-manager configuration.
# Wiki: https://nixos.wiki/wiki/Virt-manager
# ==============================================================================
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.services.virt-manager;
in {
  options.my-nixos.services.virt-manager = {
    enable = lib.mkEnableOption "enable virt-manager";
  };

  config = lib.mkIf cfg.enable (mkMerge [

    {
      programs.virt-manager.enable = true;

      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
    }

  ]);
}
