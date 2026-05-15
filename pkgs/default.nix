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
}
