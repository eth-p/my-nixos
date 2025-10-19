# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# RetroDECK configuration.
#
# It still needs to be installed through Flatpak manually.
# 
# Homepage: https://retrodeck.net/
# ==============================================================================
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.programs.retrodeck;
in
{
  options.my-nixos.programs.retrodeck = {
    enable = lib.mkEnableOption "configure RetroDECK";
    desktopEntries = {
      dolphin =
        lib.mkEnableOption "create an application menu entry for Dolphin";
    };
  };

  config =
    let
      arch = pkgs.stdenv.targetPlatform.linuxArch;
      flatpak = "net.retrodeck.retrodeck";
    in
    lib.mkIf cfg.enable (mkMerge [

      (mkIf cfg.desktopEntries.dolphin {
        environment.systemPackages = [
          (pkgs.makeDesktopItem {
            name = "dolphin-emu";
            desktopName = "Dolphin Emu";
            genericName = "GameCube Emulator";
            exec =
              "flatpak run --branch=stable --arch=${arch} ${flatpak} --open Dolphin";
            icon = "dolphin-emu";
            terminal = false;
            type = "Application";
            categories = [ "Game" ];
          })
        ];
      })

    ]);
}

