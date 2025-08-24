# my-nixos | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-nixos
#
# A third-party KDE Plasma theme that does more than just colors.
# https://github.com/ekaaty/vinyl-theme
# ==============================================================================
{ config, pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "kde-vinyl-theme";
  version = "main";
  src = pkgs.fetchgit {
    url = "https://github.com/ekaaty/vinyl-theme.git";
    rev = "v6.4.4";
    hash = "sha256-2CoO9xJwRvuoUZFr2qgtllbf9PsTV1xZxHMxh9CMtpo=";
  };

  outputs = [ "dev" "out" ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = with pkgs; [
    git
    ninja
    cmake
    ecm
    kdePackages.extra-cmake-modules
    kdePackages.frameworkintegration
    kdePackages.kcmutils
    kdePackages.kcolorscheme
    kdePackages.kconfig
    kdePackages.kconfigwidgets
    kdePackages.kcoreaddons
    kdePackages.kguiaddons
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kirigami
    kdePackages.kpackage
    kdePackages.kservice
    kdePackages.kwindowsystem
    kdePackages.kwayland
    kdePackages.kdecoration
    kdePackages.libplasma
    python3
    xorg.libX11
    xorg.xcursorgen
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    gettext
    extra-cmake-modules
    inkscape
    unzip

    qt6.wrapQtAppsHook
  ];

  configurePhase = ''
    cp -R $src .
    chmod -R 770 .
    cmake -S . -B build
  '';

  buildPhase = ''
    patchShebangs --build .
    cmake --build build -j$(nproc) --verbose
  '';

  installPhase = ''
    mkdir $out $dev

    cmake --install build --prefix $out
    mkdir -p $out/lib64/qt-6
    mv $out/lib64/plugins $out/lib64/qt-6/plugins

    mkdir -p $dev/lib64
    mv $out/lib64/cmake $dev/lib64/
  '';
}
