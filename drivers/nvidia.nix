# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Drivers for NVIDIA GPUs.
# ==============================================================================
{ config, lib, pkgs, ... }@inputs:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.drivers.nvidia;
in
{

  options.my-nixos.drivers.nvidia = {
    enable = lib.mkEnableOption "install NVIDIA drivers";
    package = lib.mkOption {
      default = (import ../patches/linux-nvidia-580.nix inputs);
      description = "the NVIDIA kernel packages";
    };

    useOpenKernelDrivers = lib.mkEnableOption "use open-source kernel drivers";
  };

  config = mkIf cfg.enable (mkMerge [

    # Enable NVIDIA GPU drivers.
    {
      nixpkgs.config.allowUnfree = true;
      hardware.nvidia = {
        open = cfg.useOpenKernelDrivers;

        modesetting.enable = true;
        nvidiaSettings = true;

        package = cfg.package;
      };

      # Workaround:
      # https://forums.developer.nvidia.com/t/580-65-06-gtk-4-apps-hang-when-attempting-to-exit-close/341308/3
      environment.sessionVariables = {
        GSK_RENDERER = "ngl";
      };
    }

    (mkIf config.services.xserver.enable {
      services.xserver.videoDrivers = [ "nvidia" ];
    })

    # Allow Plymouth to take over ASAP.
    (mkIf (!config.my-nixos.boot.verbose) {
      boot.initrd.availableKernelModules =
        [ "nvidia" "nvidia_drm" "nvidia_uvm" "nvidia_modeset" ];
    })

  ]);
}
