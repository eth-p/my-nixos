# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# The nvidia-575 driver builds are broken and need a patch.
# https://github.com/NixOS/nixpkgs/issues/412299#issuecomment-2955980698
# ==============================================================================
{ config, pkgs, ... }:
let
in config.boot.kernelPackages.nvidiaPackages.mkDriver {
  version = "580.82.07";
  sha256_64bit = "sha256-Bh5I4R/lUiMglYEdCxzqm3GLolQNYFB0/yJ/zgYoeYw=";
  sha256_aarch64 = "sha256-or3//aV4TQcPDgcLxFB75H/kB8n+3RzwTO1C2ZbJAJI=";
  openSha256 = "sha256-8/7ZrcwBMgrBtxebYtCcH5A51u3lAxXTCY00LElZz08=";
  settingsSha256 = "sha256-lx1WZHsW7eKFXvi03dAML6BoC5glEn63Tuiz3T867nY=";
  persistencedSha256 = "sha256-1JCk2T3H5NNFQum0gA9cnio31jc0pGvfGIn2KkAz9kA=";
  usePersistenced = true;
  patches = [];
}
