# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# FWUPD configuration.
# ==============================================================================
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.services.fwupd;
in {
  options.my-nixos.services.fwupd = {
    enable = lib.mkEnableOption "enable fwupd";
  };

  config = lib.mkIf cfg.enable (mkMerge [

    {
      services.fwupd.enable = true;
      environment.systemPackages = with pkgs; [
        fwupd
      ];
    }

  ]);
}
