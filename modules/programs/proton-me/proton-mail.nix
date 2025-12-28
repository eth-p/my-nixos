# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# ProtonMail wrapper.
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
  cfg = config.my-nixos.programs.proton-me.proton-mail;
in
{
  options.my-nixos.programs.proton-me.proton-mail = {
    enable = lib.mkEnableOption "install a ProtonMail wrapper";

    package = lib.mkOption {
      type = lib.types.package;
      description = "the wrapper app package";
      default = mkChromiumApp pkgs {
        appName = "proton-mail";
        configDirName = "proton-me";
        url = "https://mail.proton.me/u/0";
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
