{ ... }: {
    nixpkgs.overlays = [
        (final: prev: { qutebrowser = prev.qutebrowser.override { 
            enableWideVine = true; 
            enableVulkan = true;
        }; })
    ];
    programs.qutebrowser = {
        enable = true;
        settings = {
            colors.webpage.darkmode.enabled = true;
            auto_save.session = true;
            downloads.remove_finished = 30000; #miliseconds
        };
        extraConfig = #python
        ''
            import pywalQute.draw

            config.load_autoconfig()
            
            pywalQute.draw.color(c, {
                'spacing': {
                    'vertical': 6,
                    'horizontal': 8
                }
            })
        '';

    };
    xdg.configFile."qutebrowser/pywalQute" = {
        enable = true;
        source = builtins.fetchGit {
            url = "https://github.com/makman12/pywalQute.git";
            ref = "main";
            rev = "89f378474f23d4e15dfc8facc3f115686227f8a1";
        };
    };
}
