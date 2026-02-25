# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# The nvidia-590 driver.
# ==============================================================================
{
  config,
  pkgs,
  my-nixos,
  ...
}:
let
  linux_619_fix = pkgs.fetchpatch2 {
    url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/6e2a0214de28cf0af1b72a2076bbfc77d12d96e8/6.19/misc/nvidia/0003-Fix-compile-for-6.19.patch";
    hash = "sha256-Dczrsvbtich6Q+ldLS++bCZBxfPm5KHMO476rpgjE1c=";
  };
in
config.boot.kernelPackages.nvidiaPackages.mkDriver {
  version = "590.48.01";
  sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
  sha256_aarch64 = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";
  openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
  settingsSha256 = "sha256-NWsqUciPa4f1ZX6f0By3yScz3pqKJV1ei9GvOF8qIEE=";
  persistencedSha256 = "sha256-wsNeuw7IaY6Qc/i/AzT/4N82lPjkwfrhxidKWUtcwW8=";
  usePersistenced = true;
  patchesOpen = [ linux_619_fix ];
}
