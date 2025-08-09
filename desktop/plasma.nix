# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# KDE Plasma desktop environment configuration.
# ==============================================================================
{ config, lib, pkgs, ... }@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-nixos.desktop.plasma;
in {
  options.my-nixos.desktop.plasma = {
    enable = lib.mkEnableOption "install KDE Plasma desktop environment";

    kvantum = { enable = lib.mkEnableOption "install kvantum theme engine"; };

    krunner = {
      vscode.enable =
        lib.mkEnableOption "install the VSCode plugin for krunner";
    };

    themes = { vinyl = lib.mkEnableOption "install the Vinyl theme"; };
  };

  config = mkIf cfg.enable (mkMerge [

    {
      # Install KDE Plasma.
      services.displayManager.defaultSession = "plasma";
      services.desktopManager.plasma6.enable = true;

      # Install extra packages.
      environment.systemPackages = with pkgs; [
        kdePackages.discover
        kdePackages.filelight
        kdePackages.sddm-kcm
        pinentry-qt

        vulkan-hdr-layer-kwin6
      ];

      programs.partition-manager.enable = true;
    }

    (mkIf cfg.krunner.vscode.enable {
      environment.systemPackages = with pkgs; [ vscode-runner ];
    })

    (mkIf cfg.kvantum.enable {
      qt = {
        enable = true;
        platformTheme = "qt5ct";
      };
    })

    (mkIf cfg.themes.vinyl {
      environment.systemPackages =
        [ (import ../patches/kde-theme-vinyl.nix inputs) ];
    })

  ]);
}
