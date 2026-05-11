{ pkgs, ... }: {
    programs.niri = {
        enable = true;
        useNautilus = true;
    };
    services.displayManager.sddm = {
        enable = true; 
        wayland = {
            enable = true;
        };
        theme = "/run/current-system/sw/share/sddm/themes/simple-sddm-2";
        extraPackages = with pkgs; [ 
            simple-sddm-2
            kdePackages.qtmultimedia
            kdePackages.qtsvg
            # Some themes also need these:
            kdePackages.qt5compat
            kdePackages.qtvirtualkeyboard
        ];
    };
    programs.xwayland.enable = true;
    programs.dconf.enable = true;

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [ 
        simple-sddm-2
        alacritty fuzzel 
        xdg-desktop-portal-gnome 
        xdg-desktop-portal-gtk 
        networkmanagerapplet
        qt6Packages.qtstyleplugin-kvantum
        gnome-keyring
        nautilus
        blueman
        pavucontrol
    ];
}
