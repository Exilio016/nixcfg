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
}
