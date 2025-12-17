# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Steam configuration.
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
  cfg = config.my-nixos.programs.steam;
in
{
  options.my-nixos.programs.steam = {
    enable = lib.mkEnableOption "install Steam";
    enableProtonManager = lib.mkEnableOption "install a Proton management tool" // {
      default = true;
    };
    enableGameMode = lib.mkEnableOption "install GameMode" // {
      default = true;
    };
    enableMangoHud = lib.mkEnableOption "install MangoHud" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (mkMerge [

    (
      let
        extraPkgsOptions = [
          {
            # Fix incorrect cursors when using KDE Plasma.
            enable = config.my-nixos.desktop.plasma.enable;
            packages = pkgs': with pkgs'; [ kdePackages.breeze ];
          }
          {
            # Fix libgamemode.so not existing inside Steam FHS.
            enable = cfg.enableGameMode;
            packages = pkgs': with pkgs'; [ gamemode ];
          }
        ];
        extraPkgs =
          pkgs':
          builtins.foldl' (acc: elem: acc ++ elem) [ ] (
            builtins.map (ep: ep.packages pkgs') (builtins.filter (ep: ep.enable) extraPkgsOptions)
          );
      in
      {
        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-original"
            "steam-unwrapped"
            "steam-run"
          ];

        programs.steam = {
          enable = true;

          # Steam Remote Play
          remotePlay.openFirewall = true;

          # Source Dedicated Server
          dedicatedServer.openFirewall = true;

          # Steam Local Network Game Transfers
          localNetworkGameTransfers.openFirewall = true;

          # Add extra packages.
          package = pkgs.steam.override { inherit extraPkgs; };
        };

        # Install gamepad drivers.
        my-nixos.hardware.gamepads.enable = true;

        # Enable HDR via gamescope.
        programs.gamescope.enable = true;
        environment.systemPackages = with pkgs; [
          gamescope-wsi
          my-nixos.inputs.gamedownsights
        ];
      }
    )

    (lib.mkIf cfg.enableProtonManager {
      environment.systemPackages = with pkgs; [ protonplus ];
    })

    (lib.mkIf cfg.enableMangoHud {
      environment.systemPackages = with pkgs; [ mangohud ];
    })

    # Install GameMode.
    #
    # https://github.com/FeralInteractive/gamemode
    # https://nixos.wiki/wiki/Gamemode
    (lib.mkIf cfg.enableGameMode (
      let
        normalUsers = (lib.attrsets.filterAttrs (key: val: val.isNormalUser) config.users.users);
      in
      {
        programs.gamemode.enable = true;
        users.groups.gamemode.members = builtins.attrNames normalUsers;
      }
    ))

  ]);
}
