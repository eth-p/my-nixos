# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# RustDesk install and configuration.
# https://rustdesk.com/
# ==============================================================================
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.programs.rustdesk;
in {
  options.my-nixos.programs.rustdesk = {
    enable = lib.mkEnableOption "install RustDesk";
    unattended = lib.mkEnableOption "install RustDesk for unattended usage";
  };

  config = lib.mkIf cfg.enable (mkMerge [

    { environment.systemPackages = with pkgs; [ rustdesk ]; }

    (lib.mkIf cfg.unattended {
      # https://www.reddit.com/r/rustdesk/comments/1jhn2pa/comment/mjbjrcv/
      systemd.services."rustdesk" = {
        enable = true;
        path = with pkgs; [ rustdesk procps ];
        description = "RustDesk";
        requires = [ "network.target" ];
        after = [ "systemd-user-sessions.service" ];
        script = ''
          export PATH=/run/wrappers/bin:$PATH
          ${pkgs.rustdesk}/bin/rustdesk --service
        '';
        serviceConfig = {
          ExecStop = "${pkgs.procps}/pkill -f 'rustdesk --'";
          PIDFile = "/run/rustdesk.pid";
          KillMode = "mixed";
          TimeoutStopSec = "30";
          User = "root";
          LimitNOFILE = "100000";
        };
        wantedBy = [ "multi-user.target" ];
      };
    })

  ]);
}

