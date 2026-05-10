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
        theme = "maldives";
    };
    programs.xwayland.enable = true;
    programs.dconf.enable = true;

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [ 
        sddm-sugar-dark 
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
