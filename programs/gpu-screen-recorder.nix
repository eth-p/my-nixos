# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# gpu-screen-recorder configuration.
#
# Wiki:     https://wiki.nixos.org/wiki/Gpu-screen-recorder
# ==============================================================================
{
  config,
  lib,
  pkgs,
  my-nixos,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.programs.gpu-screen-recorder;
in
{
  options.my-nixos.programs.gpu-screen-recorder = {
    enable = lib.mkEnableOption "install gpu-screen-recorder";
  };

  config = lib.mkIf cfg.enable (mkMerge [

    {
      programs.gpu-screen-recorder.enable = true;
      environment.systemPackages = with pkgs; [
        gpu-screen-recorder-gtk
      ];
    }

  ]);
}
