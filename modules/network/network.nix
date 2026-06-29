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
  options.my-nixos.network = {
    dual-lan = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable if the device will connect to the same network over
          multiple interfaces.
        '';
      };
    };
  };

  config = mkMerge [

    # Enable networking.
    {
      # Pick only one of the below networking options.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      networking.networkmanager.enable = true;
    }

    # If dual-LAN is enabled, only reply to ARPs on matching interfaces.
    # This is necessary to prevent IP address conflicts when both interfaces
    # are connected to the same network.
    (lib.mkIf cfg.dual-lan.enable {
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.arp_ignore" = 1;
        "net.ipv4.conf.all.arp_announce" = 2;
      };
    })

  ];
}
