# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# This references all nix files this directory.
# ==============================================================================
{ ... } @ inputs: {
  desktops = (import ./desktops.nix) inputs;
  gpus = (import ./gpus.nix) inputs;
  nixos = (import ./nixos.nix) inputs;
}
