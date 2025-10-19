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

    trusted-users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "users allowed to communicate with libvirtd";
      default = [];
    };
  };

  config = lib.mkIf cfg.enable (mkMerge [

    # Enable virt-manager and libvirtd.
    {
      programs.virt-manager.enable = true;

      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
    }

    # Add trusted users to the libvirtd group.
    {
      users.groups.libvirtd.members = cfg.trusted-users;
    }
  ]);
}
