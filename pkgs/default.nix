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

    zennotes = pkgs.appimageTools.wrapType2 rec {
        pname = "ZenNotes";
        version = "2.1.0";
        src = pkgs.fetchurl {
            url = "https://github.com/ZenNotes/zennotes/releases/download/v${version}/ZenNotes-${version}-linux-x86_64.AppImage";
            hash= "sha256-jGMSov8SI4d3PoADudhtG40n1rcSkt1K1JZEjvW9Tw0=";
        };

        appimageContents = pkgs.appimageTools.extractType2 {
            inherit pname version src;
        };
        extraInstallCommands = ''
          # Install the desktop file so the app appears in your application launcher
          ls -la ${appimageContents}
          install -m 444 -D ${appimageContents}/ZenNotes.desktop -t $out/share/applications
          
          # Copy icons if they are bundled in standard directories
          if [ -d "${appimageContents}/usr/share/icons" ]; then
            cp -r ${appimageContents}/usr/share/icons $out/share/
          elif [ -f "${appimageContents}/ZenNotes.png" ]; then
            install -m 444 -D ${appimageContents}/ZenNotes.png $out/share/icons/hicolor/512x512/apps/ZenNotes.png
          fi

          # Fix the Exec line in the desktop file to point to our wrapped binary
          substituteInPlace $out/share/applications/ZenNotes.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}' \
            --replace 'Exec=ZenNotes' 'Exec=${pname}'
        '';

        meta = {
          description = "Keyboard-first local Markdown notes with Vim motions, diagrams, and MCP integration";
          homepage = "https://github.com/ZenNotes/zennotes";
          platforms = [ "x86_64-linux" ];
          mainProgram = "ZenNotes";
        };
    };
}
