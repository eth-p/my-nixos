# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Logitech hardware configuration.
# ==============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.hardware.logitech;
in
{
  options.my-nixos.hardware.logitech = {
    enable = lib.mkEnableOption "enable Logitech hardware support";

    keyboard = lib.mkEnableOption "enable Logitech keyboard support" // {
      default = true;
    };

    mouse = lib.mkEnableOption "enable Logitech mouse support" // {
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Use ratbagd + piper to configure Logitech Gaming peripheral macros.
    # Use openrgb to configure LEDs.
    (mkIf (cfg.keyboard || cfg.mouse) {
      services.ratbagd.enable = true;
      services.hardware.openrgb.enable = true;
      environment.systemPackages = with pkgs; [
        piper
      ];
    })

  ]);
}
