# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Bluetooth hardware configuration.
# https://nixos.wiki/wiki/Bluetooth
# ==============================================================================
{ config, lib, my-nixos, ... }:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-nixos.hardware.bluetooth;
in
{
  options.my-nixos.hardware.bluetooth = {
    enable = lib.mkEnableOption "enable Bluetooth stack";
  };

  config = mkIf cfg.enable (mkMerge [

    # Enable Bluetooth support.
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    }

  ]);
}
