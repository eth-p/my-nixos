# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Asus hardware configuration.
# ==============================================================================
{ config, lib, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-nixos.hardware.asus;
in {
  options.my-nixos.hardware.asus = {
    motherboard-x670e-fixes = lib.mkEnableOption "fixes for the X670E motherboard";
  };

  config = mkMerge([

    # Intel network adapter drops off bus.
    # https://www.reddit.com/r/buildapc/comments/xypn1m/comment/ixxz8mu
    (mkIf cfg.motherboard-x670e-fixes {
      boot.kernelParams = [
        "pcie_port_pm=off"
        "pcie_aspm.policy=performance"
      ];
    })

  ]);
}
