# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# Proton.me software.
# ==============================================================================
{
  ...
}:
{
  imports = [
    ./proton-calendar.nix
    ./proton-mail.nix
  ];
}
