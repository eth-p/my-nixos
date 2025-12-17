# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# AppImage support.
# ==============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
  cfg = config.my-nixos.linux.appimage;
in
{
  options.my-nixos.linux.appimage = {
    enable = lib.mkEnableOption "add AppImage support" // {
      default = true;
    };
  };

  config = (
    mkIf cfg.enable (mkMerge [

      {
        programs.appimage = {
          enable = true;
          binfmt = true;
        };
      }

    ])
  );
}
