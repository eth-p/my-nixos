# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Boot configuration.
#
# Contains options for enabling Secure Boot and LUKS TPM 2.0 unlock.
# ==============================================================================
{
  config,
  lib,
  pkgs,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-nixos.boot;
in
{
  options.my-nixos.boot = {
    secure-boot.enable = lib.mkEnableOption "Secure Boot using lanzaboote";
    tpm-unlock.enable = lib.mkEnableOption "use TPM to unlock LUKS-encrypted volumes";

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "show a verbose boot screen";
    };
  };

  config = mkMerge [

    # Use the systemd-boot EFI boot loader.
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    }

    # Use lanzaboote for self-signed Secure Boot.
    # https://github.com/nix-community/lanzaboote
    (mkIf cfg.secure-boot.enable {
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      environment.systemPackages = with pkgs; [ sbctl ];
    })

    # Enable features required for unlocking volumes via TPM 2.0.
    # Before enabling this, you must manually enroll the keys:
    #   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/the-disk
    (mkIf cfg.secure-boot.enable {
      boot.initrd.systemd.enable = true;
      environment.systemPackages = with pkgs; [ tpm2-tss ];
    })

    # If verbose booting is disabled, hide the syslog using Plymouth.
    (mkIf (!cfg.verbose) {
      boot.plymouth = {
        enable = true;
        theme = "bgrt";
      };

      boot.kernelParams = [
        # Fix for broken Plymouth on NixOS with CachyOS kernel.
        # https://github.com/chaotic-cx/nyx/issues/946
        "plymouth.ignore-serial-consoles"

        # Hide verbose boot messages.
        "quiet"
        "splash"
        "rd.systemd.show_status=auto"
      ];
    })

  ];
}
