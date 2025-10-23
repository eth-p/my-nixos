# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# A Nix library listing graphics cards.
# ==============================================================================
{ ... }: rec {
  cards = {

    # NVIDIA RTX 4090
    # Architecture: Ada Lovelace
    nvidia-rtx4090 = {
      drivers = {
        nvidia = true;
        nvidia-open = true;
      };
    };

  };

  # cardByName :: string -> (attrset | null)
  cardByName = name: if name == null then null else cards."${name}";

  # isNvidia :: attrset -> bool
  isNvidia = gpu: if gpu.drivers ? "nvidia" then gpu.drivers.nvidia else false;

  # isAMD :: attrset -> bool
  isAMD = gpu: false; # stub until I have an AMD card
}
