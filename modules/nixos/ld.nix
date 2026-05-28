{ pkgs, ... }: {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      glibc
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      libglvnd
    ];
}
