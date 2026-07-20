{ pkgs, ... }: {
    xdg.configFile."qutebrowser/config.py" = {
        enable = true;
        text = #python
        ''
            import pywalQute.draw
            import re
            import os

            def get_chromium_version():
                for path in ["/usr/lib/libQt6WebEngineCore.so", "/usr/lib/libQt5WebEngineCore.so"]:
                    if os.path.exists(path):
                        with open(path, "rb") as f:
                            # Read the binary and find the embedded Chrome version string
                            match = re.search(b"Chrome/([0-9.]+)", f.read())
                            if match:
                                return match.group(1).decode("utf-8")
                return "149.0.0.0"
            
            chrom_ver = get_chromium_version()

            config.load_autoconfig()
            
            pywalQute.draw.color(c, {
                'spacing': {
                    'vertical': 6,
                    'horizontal': 8
                }
            })
            config.bind('<z><l>', 'spawn --userscript qute-bitwarden')
            config.bind('<z><u><l>', 'spawn --userscript qute-bitwarden --username-only')
            config.bind('<z><p><l>', 'spawn --userscript qute-bitwarden --password-only')
            config.bind('<z><o><l>', 'spawn --userscript qute-bitwarden --otp-only')

            config.set('content.headers.user_agent', f'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/{chrom_ver} Safari/537.36')
            config.set('colors.webpage.darkmode.enabled', True)
            config.set('auto_save.session', True)
            config.set('downloads.remove_finished', 30000)
            config.set('url.searchengines', {"DEFAULT": "https://duckduckgo.com/?q={} !g"})
            
            c.content.javascript.clipboard = "access-paste"
            c.content.autoplay = False
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
    
    programs.brave = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        # Bitwarden Password Manager
        "nngceckbapebfimnlniiiahkandclblb"
      ];
    };
}
