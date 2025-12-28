# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Proton Calendar wrapper.
# ==============================================================================
{
  config,
  lib,
  pkgs,
  my-nixos,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-nixos.lib.webwrap) mkChromiumApp;
  cfg = config.my-nixos.programs.proton-me.proton-calendar;
in
{
  options.my-nixos.programs.proton-me.proton-calendar = {
    enable = lib.mkEnableOption "install a ProtonMail Calendar wrapper";

    package = lib.mkOption {
      type = lib.types.package;
      description = "the wrapper app package";
      default = mkChromiumApp pkgs {
        appName = "proton-calendar";
        configDirName = "proton-me";
        url = "https://calendar.proton.me/u/0/";

        icon = "org.kde.plasma.calendar.wl";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Install the Chromium wrapper.
    {
      environment.systemPackages = [
        cfg.package
      ];
    }

  ]);
}
