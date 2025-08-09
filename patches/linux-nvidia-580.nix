# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# The nvidia-575 driver builds are broken and need a patch.
# https://github.com/NixOS/nixpkgs/issues/412299#issuecomment-2955980698
# ==============================================================================
{ config, pkgs, ... }:
let
in config.boot.kernelPackages.nvidiaPackages.mkDriver {
  version = "580.65.06";
  sha256_64bit = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
  sha256_aarch64 = "sha256-4CrNwNINSlQapQJr/dsbm0/GvGSuOwT/nLnIknAM+cQ=";
  openSha256 = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
  settingsSha256 = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
  persistencedSha256 = "sha256-ETRfj2/kPbKYX1NzE0dGr/ulMuzbICIpceXdCRDkAxA=";
  usePersistenced = true;
  patches = [];
}
