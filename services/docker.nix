# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Docker configuration.
#
# https://nixos.wiki/wiki/Docker
# ==============================================================================
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.services.docker;
in {
  options.my-nixos.services.docker = {
    enable = lib.mkEnableOption "install Docker";
    rootless = lib.mkEnableOption "use Docker rootless" // { default = true; };
  };

  config = lib.mkIf cfg.enable (mkMerge [

    { virtualisation.docker.enable = true; }

    (lib.mkIf cfg.rootless {
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
    })
  ]);
}
