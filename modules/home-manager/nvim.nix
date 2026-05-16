{config, pkgs, lib, ...}: 
let
  # Automagically grab every available language grammar from nixpkgs
  allGrammars = lib.filter 
    (drv: lib.isDerivation drv) 
    (builtins.attrValues pkgs.tree-sitter-grammars);

  # Merge them into a single, unified directory tree
  grammarDir = pkgs.symlinkJoin {
    name = "all-tree-sitter-grammars";
    paths = allGrammars;
  };
in {

    systemd.user.tmpfiles.rules = [
        "L ${config.home.homeDirectory}/.config/nvim - - - -  ${config.home.homeDirectory}/nixos/nvim"
    ];

    # Install the CLI tool
    home.packages = [ pkgs.tree-sitter pkgs.gcc ];

    # Point the CLI to the unified grammar store
    xdg.configFile."tree-sitter/config.json".text = builtins.toJSON {
        parser-directories = [
            "${grammarDir}"
        ];
    };
}
