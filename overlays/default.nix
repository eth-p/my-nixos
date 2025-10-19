# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# This references all the overlays under this directory.
# ==============================================================================
{ my-nixos, ... } @ inputs: (final: prev: {

  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder-ui.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder-notification.nix { };
  kde-theme-vinyl = prev.callPackage ./kde-theme-vinyl.nix { };
  kde-kwin-effects-forceblur-wayland = my-nixos.inputs.kwin-effects-forceblur.packages.${prev.system}.default;
  kde-kwin-effects-forceblur-x11 = my-nixos.inputs.kwin-effects-forceblur.packages.${prev.system}.x11;

})
