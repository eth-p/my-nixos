# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Syncthing configuration.
#
# Wiki:     https://wiki.nixos.org/wiki/Syncthing
# Homepage: https://syncthing.net/
# ==============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.services.syncthing;
in
{
  options.my-nixos.services.syncthing = {
    enable = lib.mkEnableOption "enable Syncthing";
  };

  config = lib.mkIf cfg.enable (mkMerge [

    {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
      };
    }

  ]);
}
