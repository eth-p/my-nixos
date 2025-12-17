# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Nix package manager configuration.
# ==============================================================================
{
  config,
  lib,
  pkgs,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-nixos.services.nix;
in
{
  options.my-nixos.services.nix = {
    flakes = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable support for flakes";
    };

    command-not-found = lib.mkEnableOption "enable command-not-found" // {
      default = true;
    };

    trusted-users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "trusted users";
      default = [ ];
    };

    cache.devenv.enable = lib.mkEnableOption "enable devenv binary cache";
    cache.vicinae.enable = lib.mkEnableOption "enable vicinae binary cache";
  };

  config = mkMerge [

    # Enable Nix flakes and the `nix` command.
    (mkIf cfg.flakes {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      environment.systemPackages = with pkgs; [
        git # Used to pull flakes
      ];
    })

    # Show potential packages for unknown commands.
    (mkIf cfg.command-not-found {
      programs.command-not-found.enable = true;
    })

    # Enable devenv binary cache.
    (mkIf cfg.cache.devenv.enable {
      nix.settings = {
        extra-substituters = [ "https://devenv.cachix.org" ];
        extra-trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
      };
    })

    (mkIf cfg.cache.vicinae.enable {
      nix.settings = {
        extra-substituters = [ "https://vicinae.cachix.org" ];
        extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
      };
    })

    # Set trusted users.
    {
      nix.settings.trusted-users = cfg.trusted-users;
    }
  ];
}
