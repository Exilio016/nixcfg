{config, ...}: {
    systemd.user.tmpfiles.rules = [
        "L ${config.home.homeDirectory}/.config/nvim - - - -  ${config.home.homeDirectory}/nixos/nvim"
    ];
}
