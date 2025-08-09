# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# A Nix library listing desktop environments.
# ==============================================================================
{ ... }: rec {
  environments = {

    # KDE Plasma 6
    plasma = {
      flavor = "plasma";
      server = "wayland";
    };

  };

  # environmentByName :: string -> (attrset | null)
  environmentByName = name: if name == null then null else environments."${name}";

  # isPlasma :: attrset -> bool
  isPlasma = environment: environment.flavor == "plasma";

  # usesWayland :: attrset -> bool
  usesWayland = environment: environment.server == "wayland";
}
