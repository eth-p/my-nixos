# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Bottles configuration.
#
# Wiki:     https://wiki.nixos.org/wiki/Bottles
# Homepage: https://usebottles.com/
# ==============================================================================
{ config, lib, pkgs, my-nixos, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.programs.bottles;
in {
  options.my-nixos.programs.bottles = {
    enable = lib.mkEnableOption "install Bottles";
  };

  config = lib.mkIf cfg.enable (mkMerge [

    {
      environment.systemPackages = with pkgs;
        [ (bottles.override { removeWarningPopup = true; }) ];
    }

  ]);
}
