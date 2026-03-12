# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# The nvidia-590 driver.
# ==============================================================================
{
  config,
  ...
}:
config.boot.kernelPackages.nvidiaPackages.mkDriver {
  version = "595.45.04";
  sha256_64bit = "sha256-zUllSSRsuio7dSkcbBTuxF+dN12d6jEPE0WgGvVOj14=";
  sha256_aarch64 = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";
  openSha256 = "sha256-uqNfImwTKhK8gncUdP1TPp0D6Gog4MSeIJMZQiJWDoE=";
  settingsSha256 = "sha256-Y45pryyM+6ZTJyRaRF3LMKaiIWxB5gF5gGEEcQVr9nA=";
  persistencedSha256 = "sha256-5FoeUaRRMBIPEWGy4Uo0Aho39KXmjzQsuAD9m/XkNpA=";
  usePersistenced = true;
}
