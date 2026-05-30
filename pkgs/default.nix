pkgs: {
    simple-sddm-2 = pkgs.stdenv.mkDerivation {
        pname = "simple-sddm-2";
        version = "latest";
        src = pkgs.fetchFromGitHub {
          owner = "JaKooLit";
          repo = "simple-sddm-2";
          rev = "fa1ffbda06bc363a5a4103a155a4b65d4f910514"; # Or a specific commit hash
          sha256 = "sha256-1rVEVfzGz0Q7MSIX4lu/cowoJYlTx3RWPleyeoo/YbM="; # Update this
        };
        installPhase = ''
          mkdir -p $out/share/sddm/themes/simple-sddm-2
          cp -aR * $out/share/sddm/themes/simple-sddm-2
        '';
    };

    savepoint = pkgs.rustPlatform.buildRustPackage rec {
        pname = "savepoint";
        version = "0.3.12";
        src = pkgs.fetchFromGitHub {
            owner = "NamtaoProductions";
            repo = "savepoint";
            rev = "v0.3.12";
            sha256 = "sha256-Mx7zrwK9rwVumFDU7EWhjGai2IEgr++xhaNqv1hFBS4=";
        };
        cargoLock.lockFile = "${src}/Cargo.lock";
        doCheck = false;
    };

    gradience = pkgs.python3Packages.buildPythonApplication {
        pname = "gradience";
        version = "0.8.0-beta1";
      
        src = pkgs.fetchFromGitHub {
          owner = "GradienceTeam";
          repo = "Gradience";
          rev = "90b774174da0e3c6b5314e38226bea653a5bf57a";
          sha256 = "sha256-C0GV6vOEZ0wTaKO7BgGuFvHsHeaVwH0W1U8yKUMrO9c=";
          fetchSubmodules = true;
        };
      
        format = "other";
        dontWrapGApps = true;
      
        nativeBuildInputs = with pkgs; [
          git
          appstream-glib
          blueprint-compiler
          desktop-file-utils
          gettext
          glib
          gobject-introspection
          meson
          ninja
          pkg-config
          wrapGAppsHook4
          sassc
        ];
      
        buildInputs = with pkgs; [
          glib-networking
          libadwaita
          libportal
          libportal-gtk4
          librsvg
          libsoup_3
        ];
      
        propagatedBuildInputs = with pkgs.python3Packages; [
          anyascii
          jinja2
          lxml
          material-color-utilities
          pygobject3
          svglib
          yapsy
          libsass
          packaging
        ];
      
        preFixup = ''
          makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
        '';
    };
}
