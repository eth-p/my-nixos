# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Graphics hardware configuration.
# ==============================================================================
{ config, lib, my-nixos, ... }:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-nixos.lib) gpus;
  cfg = config.my-nixos.hardware.graphics;
in {
  options.my-nixos.hardware.graphics = {
    enable = lib.mkEnableOption "enable graphics stack";
    card = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum (builtins.attrNames gpus.cards));
      default = null;
      description = "the main graphics card installed in the system";
    };
  };

  config = let primaryGPU = gpus.cardByName cfg.card;
  in mkIf cfg.enable (mkMerge [

    # Enable graphics support.
    {
      hardware.graphics.enable = true;
    }

    # Enable NVIDIA drivers.
    (mkIf (gpus.isNvidia primaryGPU) {
      my-nixos.drivers.nvidia = {
        enable = true;
        useOpenKernelDrivers = primaryGPU.drivers.nvidia-open;
      };
    })

  ]);
}
