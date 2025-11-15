# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Flatpak configuration.
# ==============================================================================
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.services.flatpak;
in
{
  options.my-nixos.services.flatpak = {
    enable = lib.mkEnableOption "enable Flatpak";
  };

  config = lib.mkIf cfg.enable (mkMerge [

    {
      services.flatpak.enable = true;
    }

  ]);
}
