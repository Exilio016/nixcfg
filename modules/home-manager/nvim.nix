{config, pkgs, ...}: {
    systemd.user.tmpfiles.rules = [
        "L ${config.home.homeDirectory}/.config/nvim - - - -  ${config.home.homeDirectory}/nixos/nvim"
    ];
    programs.neovim = {
        enable = true;
        plugins = [
          (pkgs.vimPlugins.nvim-treesitter.withAllGrammars)
        ];
    };
}
