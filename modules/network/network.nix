# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Graphics hardware configuration.
# ==============================================================================
{ config, lib, ... }:
let
  inherit (lib) mkMerge;
  cfg = config.my-nixos.network;
in
{
  options.my-nixos.network = { };

  config = mkMerge [

    # Enable networking.
    {
      # Pick only one of the below networking options.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      networking.networkmanager.enable = true;
    }

  ];
}
