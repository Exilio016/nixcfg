{ pkgs, ... }: {
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
            config.bind('<z><l>', 'spawn --userscript qute-pass -U secret -u "login: (.+)"')
            config.bind('<z><u><l>', 'spawn --userscript qute-pass --username-only -U secret -u "login: (.+)"')
            config.bind('<z><p><l>', 'spawn --userscript qute-pass --password-only')
            config.bind('<z><o><l>', 'spawn --userscript qute-pass --otp-only')

            config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:135.0) Gecko/20100101 Firefox/135', 'https://accounts.google.com/*')
            
            c.content.javascript.clipboard = "access-paste"
        '';

    };
    xdg.configFile."qutebrowser/pywalQute" = {
        enable = true;
        source = pkgs.applyPatches {
            name = "darkmode-fix";
            src = builtins.fetchGit { 
                url = "https://github.com/makman12/pywalQute.git";
                ref = "main";
                rev = "89f378474f23d4e15dfc8facc3f115686227f8a1";
            };
            patches = [
                (pkgs.writeText "darkmode.patch" ''
                    diff --git a/draw.py b/draw.py
                    index 94cbe26..670f688 100644
                    --- a/draw.py
                    +++ b/draw.py
                    @@ -15,7 +15,7 @@ palette = {
                         'selection': colorjson["separator"],
                         'foreground': colorjson["cursor"],
                         'foreground-alt': colorjson["comment"],
                    -    'foreground-attention': "#ffffff",
                    +    'foreground-attention': "#000000",
                         'comment': colorjson["comment"],
                         'cyan': colorjson["parens"],
                         'green': colorjson["function"],
                '')
            ];
        };
    };
    
    home.file.".local/share/qutebrowser/userscripts/pass" = {
        enable = true;
        source = ./qute-pass;
    };
}
