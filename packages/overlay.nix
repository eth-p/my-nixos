# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# This provides an overlay for all packages under this directory.
# ==============================================================================
final: prev: {

  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/package.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder-ui/package.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder-notification/package.nix { };
  vinyl-theme = prev.callPackage ./vinyl-theme/package.nix { };

}
