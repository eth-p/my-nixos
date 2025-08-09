# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Desktop environment configuration.
# ==============================================================================
{ config, lib, pkgs, my-nixos, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  inherit (my-nixos.lib) desktops;
  cfg = config.my-nixos.desktop;
in {
  imports = [ ./plasma.nix ];

  options.my-nixos.desktop = {
    enable = lib.mkEnableOption "use a graphical desktop environment";

    environment = lib.mkOption {
      type = lib.types.nullOr
        (lib.types.enum (builtins.attrNames desktops.environments));
      default = null;
      description = "the desktop environment to use";
    };
  };

  config = let
    de = desktops.environmentByName cfg.environment;
    wayland = desktops.usesWayland de;
  in mkIf cfg.enable (mkMerge [

    {
      # Use SDDM as the display manager.
      services.displayManager.sddm.enable = true;
      
      # Enable X11.
      services.xserver.enable = true;
    }

    # Enable Wayland and install wayland-related packages.
    (mkIf wayland {
      services.displayManager.sddm.wayland.enable = true;
      environment.systemPackages = with pkgs; [
        wayland-utils
        wl-clipboard
      ];
    })

    # Install X11-related packages.
    (mkIf (!wayland) {
      environment.systemPackages = with pkgs; [ 
        xclip
      ]; 
    })

    # Use KDE Plasma as the default desktop environment.
    (mkIf (desktops.isPlasma de) {
      my-nixos.desktop.plasma.enable = true;
      services.displayManager.defaultSession = "plasma";
    })

  ]);
}
