{ pkgs, config, ... }: {
    programs.gpg = {
        enable = true;
        publicKeys = [
            {
                source = pkgs.fetchurl {
                    url = "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x667941cd3e726ed14339e7cfbb637478e3794564";
                    sha256 = "sha256-VLYgJOEOvd/tTevdwISA7paqf8LHllkGFox9j/nAgjA=";
                };
                trust = 5;
            }
        ];
    };
    programs.rofi.pass = {
        enable = true;
        package = pkgs.rofi-pass-wayland;
        stores = [
            "${config.home.homeDirectory}/Projects/pass"
        ];
    };
    services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-rofi;
    };
    home.packages = [ pkgs.pinentry-rofi (pkgs.pass.withExtensions (exts: [ pkgs.passExtensions.pass-otp ])) ];

}
