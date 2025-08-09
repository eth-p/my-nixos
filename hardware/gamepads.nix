# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Gamepad hardware configuration.
# ==============================================================================
{ config, lib, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.hardware.gamepads;
in {
  options.my-nixos.hardware.gamepads = {
    enable = lib.mkEnableOption "enable gamepad support";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Xbox One Wireless Adapter
      my-nixos.drivers.xone.enable = mkDefault true;
    }
  ]);
}
