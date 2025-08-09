# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Linux configuration.
# ==============================================================================
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkMerge;
  cfg = config.my-nixos.linux;
in {
  options.my-nixos.linux = {
    kernel = lib.mkOption {
      type = lib.types.enum [ "latest" "cachyos-zen4" ];
      default = "latest";
      description = "the Linux kernel packages";
    };
  };

  config = mkMerge [

    # Use a specific kernel package.
    (let
      kernels = {
        "latest" = pkgs.linuxPackages_latest;
        "cachyos-zen4" =
          pkgs.linuxPackages_cachyos.cachyOverride { mArch = "ZEN4"; };
      };
    in {
      boot.kernelPackages = kernels."${cfg.kernel}";
    })

    # Install useful tools.
    {
      environment.systemPackages = with pkgs; [
        usbutils
        pciutils
      ];
    }

  ];
}
