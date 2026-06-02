# This file defines overlays
# These are arbitrary named and just some conventions I use, you can name then whenever and/or make as many as you want
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    adw-gtk3 = prev.adw-gtk3.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
            patch -p1 $out/share/themes/adw-gtk3-dark/gtk-3.0/gtk.css < ${./patches/gtk3-css.patch}
            patch -p1 $out/share/themes/adw-gtk3-dark/gtk-3.0/gtk-dark.css < ${./patches/gtk3-dark-css.patch}
            patch -p1 $out/share/themes/adw-gtk3-dark/gtk-4.0/libadwaita.css < ${./patches/libadwaita-css.patch}
            patch -p1 $out/share/themes/adw-gtk3-dark/gtk-4.0/libadwaita-tweaks.css < ${./patches/libadwaita-tweaks.patch}
        '';
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstablePkgs'
  unstable-packages = final: _prev: {
    unstablePkgs = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

}
