# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# OBS Studio configuration.
#
# Wiki: https://wiki.nixos.org/wiki/OBS_Studio
# ==============================================================================
{ config, lib, pkgs, my-nixos, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  inherit (lib.strings) escapeShellArg;
  inherit (my-nixos.lib.gpus) cardByName isNvidia isAMD;
  cfg = config.my-nixos.programs.obs-studio;
  graphicsCfg = config.my-nixos.hardware.graphics;
in
{
  options.my-nixos.programs.obs-studio = {
    enable = lib.mkEnableOption "enable OBS studio";

    accel.nvapi = lib.mkOption {
      description = "enable Hardware acceleration using Nvidia cards";
      type = lib.types.enum [ true false "auto" ];
      default = "auto";
    };

    accel.vaapi = lib.mkOption {
      description = "enable Hardware acceleration using AMD cards";
      type = lib.types.enum [ true false "auto" ];
      default = "auto";
    };

    environmentVariables = lib.mkOption {
      description = "additional environment variables";
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
  };

  config =
    let
      hasNvidiaCard = isNvidia (cardByName graphicsCfg.card);
      hasAMDCard = isAMD (cardByName graphicsCfg.card);
      withNVAPI = if cfg.accel.nvapi == "auto" then hasNvidiaCard else cfg.accel.nvapi;
      withVAAPI = if cfg.accel.nvapi == "auto" then hasAMDCard else cfg.accel.vaapi;

      package = pkgs.obs-studio.override {
        # Enable hardware acceleration using NVAPI (Nvidia)
        cudaSupport = withNVAPI;
      };

      wrappedPackage = pkgs.symlinkJoin {
        name = "obs-studio";
        paths = [ package ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/obs \
            ${lib.attrsets.foldlAttrs
              (acc: var: val: "${acc} --set ${escapeShellArg var} ${escapeShellArg val}")
              ""
              cfg.environmentVariables
            }
        '';
      };
    in
    lib.mkIf cfg.enable (mkMerge [

      # Install OBS studio
      {
        programs.obs-studio = {
          enable = true;
          package = wrappedPackage;
        };
      }

      # Enable hardware acceleration using VAAPI (AMD)
      (lib.mkIf withVAAPI {
        programs.obs-studio = {
          plugins = with pkgs.obs-studio-plugins; [
            obs-vaapi
          ];
        };
      })

      # Workaround for crashing when opening projector window.
      (lib.mkIf hasNvidiaCard {
        my-nixos.programs.obs-studio.environmentVariables = {
          __NV_DISABLE_EXPLICIT_SYNC = "1";
        };
      })

    ]);
}
