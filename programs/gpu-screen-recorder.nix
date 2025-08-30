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
  ...
}:
let
  inherit (lib) mkMerge mkIf;
  cfg = config.my-nixos.programs.gpu-screen-recorder;
in
{
  options.my-nixos.programs.gpu-screen-recorder = {
    enable = lib.mkEnableOption "install gpu-screen-recorder";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The package for gpu-screen-recorder.";
      default = pkgs.gpu-screen-recorder;
    };

    ui.enable = lib.mkEnableOption "install a UI for gpu-screen-recorder" // {
      default = true;
    };

    ui.package = lib.mkOption {
      type = lib.types.package;
      description = "The UI package for gpu-screen-recorder.";
      default = pkgs.gpu-screen-recorder-ui;
    };
  };

  config = lib.mkIf cfg.enable (mkMerge [

    {
      security.wrappers = {
        "gsr-kms-server" = {
          owner = "root";
          group = "root";
          capabilities = "cap_sys_admin+ep";
          source = lib.getExe' cfg.package "gsr-kms-server";
        };
      };

      environment.systemPackages = with pkgs; [
        gpu-screen-recorder
      ];
    }

    (mkIf cfg.ui.enable {
      security.wrappers = {
        "gsr-global-hotkeys" = {
          owner = "root";
          group = "root";
          capabilities = "cap_setuid+ep";
          source = lib.getExe' cfg.ui.package "gsr-global-hotkeys";
        };
      };

      environment.systemPackages = with pkgs; [
        gpu-screen-recorder-ui
        gpu-screen-recorder-notification
      ];

    })

  ]);
}
