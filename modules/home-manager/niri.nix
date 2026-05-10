{ pkgs, config, ... }: 
{
    services.mako = {
        enable = true;
    };

    services.udiskie = {
        enable = false;
    };
    programs.waybar = {
        enable = true;
        settings.mainBar = {
            layer = "top";
            reload_style_on_change = true;
            modules-left = [ "niri/workspaces"];
            modules-center = [ "niri/window" ];
            modules-right = [ "custom/arrow1" "backlight" "custom/arrow2" "pulseaudio" "custom/arrow3" "battery" "custom/arrow4" "clock" "custom/arrow5" "tray" "custom/arrow6" "custom/power" ];

            "custom/arrow1" = {
                format = "";
                tooltip = false;
            };
            "custom/arrow2" = {
                format = "";
                tooltip = false;
            };
            "custom/arrow3" = {
                format = "";
                tooltip = false;
            };
            "custom/arrow4" = {
                format = "";
                tooltip = false;
            };
            "custom/arrow5" = {
                format = "";
                tooltip = false;
            };
            "custom/arrow6" = {
                format = "";
                tooltip = false;
            };

            backlight = {
                format = "{percent} {icon}";
                format-icons = [ "󱩎 " "󰛨 " ];
            };

            pulseaudio = {
                format = "{volume} {icon}";
                format-icons = [ " " " " ];
                on-click = "pavucontrol";
            };

            battery = {
                format = "{capacity} {icon}";
                format-icons = [ " " " " ];
            };

            tray = {
                spacing = 10;
            };

            "custom/power" = {
                format = " ⏻  ";
                menu = "on-click";
                menu-file = "${config.home.homeDirectory}/.config/waybar/power_menu.xml";
                meny-actions = {
                    shutdown = "shutdown";
                    reboot = "reboot";
                    suspend = "systemctl suspend";
                    hibernate = "systemctl hibernate";
                };
            };

        };
        style = #css
        ''
            @import "${config.home.homeDirectory}/.cache/wal/colors-waybar.css";
            window#waybar {
                background: alpha(@background, 0.6);
                color: @foreground;
                font-size: 16px;
            }
            
            #workspaces {
                background: @background;
                border-radius: 25px;
                padding: 0 10px;
            }
            
            #workspaces button {
                margin: 3px 5px;
                padding: 3px 5px;
                border-radius: 25px;
                color: @foreground;
            }

            #window {
                background: @background;
                border-radius: 25px;
                padding: 0 15px;
            }

            #workspaces button.focused {
                background: @color1;
            }

            #custom-arrow1 {
                font-size: 30px;
                color: @color2;
            }

            #backlight {
                background: @color2;
                padding: 0 5px;
            }
            
            #custom-arrow2 {
                font-size: 30px;
                color: @color3;
                background: @color2;
            }

            #pulseaudio {
                background: @color3;
                padding: 0 5px;
                color: @background;
            }
            
            #custom-arrow3 {
                font-size: 30px;
                color: @color4;
                background: @color3;
            }

            #battery {
                background: @color4;
                color: @background;
                padding: 0 5px;
            }
            
            #custom-arrow4 {
                font-size: 30px;
                color: @color5;
                background: @color4;
            }

            #clock {
                background: @color5;
                color: @background;
                padding: 0 5px;
            }

            #custom-arrow5 {
                font-size: 30px;
                color: @color6;
                background: @color5;
            }

            #tray {
                background: @color6;
                color: @background;
                padding: 0 5px;
            }
            
            #custom-arrow6 {
                font-size: 30px;
                color: @color7;
                background: @color6;
            }

            #custom-power {
                background: @color7;
                color: @background;
            }
            
            #custom-rarrow {
                font-size: 30px;
                color: @background;
                background: alpha(@background, 0.6);
            }
            menu {
                background: @background;
                color: @foreground;
            }
            menuitem:hover {
                background: @color1;
                color: @background;
            }
        '';
    };
    xdg.configFile."waybar/power_menu.xml" = {
        enable = true;
        text = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <interface>
                <object class="GtkMenu" id="menu">
                    <child>
                        <object class="GtkMenuItem" id="suspend">
                            <property name="label">Suspend</property>
                        </object>
                    </child>
                    <child>
                        <object class="GtkMenuItem" id="hibernate">
                            <property name="label">Hibernate</property>
                        </object>
                    </child>
                    <child>
                        <object class="GtkMenuItem" id="shutdown">
                            <property name="label">Shutdown</property>
                        </object>
                    </child>
                    <child>
                        <object class="GtkSeparatorMenuItem" id="delimiter1" />
                    </child>
                    <child>
                        <object class="GtkMenuItem" id="reboot">
                            <property name="label">Reboot</property>
                        </object>
                    </child>
                </object>
            </interface>
        '';
    };
    services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 115; # in seconds
            command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
          }
          {
            timeout = 120;
            command = "${pkgs.swaylock-effects}/bin/swaylock";
          }
          {
            timeout = 240;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
        events = [
        ];
    };
    programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
    };

    xdg.configFile."niri/config.kdl" = {
        enable = true;
        text = #kdl 
        ''
            include "${config.home.homeDirectory}/.cache/wal/colors.kdl";
            spawn-at-startup "nm-applet"
            spawn-at-startup "blueman-tray"
            spawn-at-startup "swaybg" "-i" "${config.home.homeDirectory}/nixos/assets/wallpaper/current"
            spawn-at-startup "wal" "-R"

            prefer-no-csd

            environment {
                QT_QPA_PLATFORM "wayland"
                QT_STYLE_OVERRIDE "kvantum"
                GTK_THEME "FlatColor"
                DISPLAY null
            }

            clipboard {
                disable-primary
            }
            
            input {
                touchpad {
                    tap
                    natural-scroll
                }
            }
            layout {
                gaps 16
                center-focused-column "never"
                preset-column-widths {
                    proportion 0.33333
                    proportion 0.5
                    proportion 0.66667
                }
                default-column-width { proportion 0.5; }
                focus-ring {
                    width 4
                }
            
                border {
                    off
                    width 4
                }
            
                shadow {
                    softness 30
                    spread 5
                    offset x=0 y=5
                    color "#0007"
                }
            }
            spawn-at-startup "waybar"
            screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
            
            window-rule {
                match app-id=r#"^org\.wezfurlong\.wezterm$"#
                default-column-width {}
            }
            
            window-rule {
                match app-id=r#"firefox$"# title="^Picture-in-Picture$"
                open-floating true
            }

            window-rule {
                open-maximized true
            }
            
            binds {
                Mod+Shift+Slash { show-hotkey-overlay; }
                Mod+T hotkey-overlay-title="Open a Terminal: alacritty" { spawn "alacritty"; }
                Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }
            
                Super+Alt+S allow-when-locked=true hotkey-overlay-title=null { spawn-sh "pkill orca || exec orca"; }
                XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
                XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
                XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
                XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
            
                XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
                XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
                XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
                XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }
            
                XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
                XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }
            
                Mod+O repeat=false { toggle-overview; }
                Mod+Q repeat=false { close-window; }
            
                Mod+Left  { focus-column-left; }
                Mod+Down  { focus-window-down; }
                Mod+Up    { focus-window-up; }
                Mod+Right { focus-column-right; }
                Mod+H     { focus-column-left; }
                Mod+J     { focus-window-down; }
                Mod+K     { focus-window-up; }
                Mod+L     { focus-column-right; }
            
                Mod+Ctrl+Left  { move-column-left; }
                Mod+Ctrl+Down  { move-window-down; }
                Mod+Ctrl+Up    { move-window-up; }
                Mod+Ctrl+Right { move-column-right; }
                Mod+Ctrl+H     { move-column-left; }
                Mod+Ctrl+J     { move-window-down; }
                Mod+Ctrl+K     { move-window-up; }
                Mod+Ctrl+L     { move-column-right; }
            
                Mod+Home { focus-column-first; }
                Mod+End  { focus-column-last; }
                Mod+Ctrl+Home { move-column-to-first; }
                Mod+Ctrl+End  { move-column-to-last; }
            
                Mod+Shift+Left  { focus-monitor-left; }
                Mod+Shift+Down  { focus-monitor-down; }
                Mod+Shift+Up    { focus-monitor-up; }
                Mod+Shift+Right { focus-monitor-right; }
                Mod+Shift+H     { focus-monitor-left; }
                Mod+Shift+J     { focus-monitor-down; }
                Mod+Shift+K     { focus-monitor-up; }
                Mod+Shift+L     { focus-monitor-right; }
            
                Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
                Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
                Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
                Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
                Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
                Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
                Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
                Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }
            
                Mod+Page_Down      { focus-workspace-down; }
                Mod+Page_Up        { focus-workspace-up; }
                Mod+U              { focus-workspace-down; }
                Mod+I              { focus-workspace-up; }
                Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
                Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
                Mod+Ctrl+U         { move-column-to-workspace-down; }
                Mod+Ctrl+I         { move-column-to-workspace-up; }
            
                Mod+Shift+Page_Down { move-workspace-down; }
                Mod+Shift+Page_Up   { move-workspace-up; }
                Mod+Shift+U         { move-workspace-down; }
                Mod+Shift+I         { move-workspace-up; }
            
                Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
                Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
                Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
                Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
            
                Mod+WheelScrollRight      { focus-column-right; }
                Mod+WheelScrollLeft       { focus-column-left; }
                Mod+Ctrl+WheelScrollRight { move-column-right; }
                Mod+Ctrl+WheelScrollLeft  { move-column-left; }
            
                Mod+Shift+WheelScrollDown      { focus-column-right; }
                Mod+Shift+WheelScrollUp        { focus-column-left; }
                Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
                Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
            
                Mod+1 { focus-workspace 1; }
                Mod+2 { focus-workspace 2; }
                Mod+3 { focus-workspace 3; }
                Mod+4 { focus-workspace 4; }
                Mod+5 { focus-workspace 5; }
                Mod+6 { focus-workspace 6; }
                Mod+7 { focus-workspace 7; }
                Mod+8 { focus-workspace 8; }
                Mod+9 { focus-workspace 9; }
                Mod+Ctrl+1 { move-column-to-workspace 1; }
                Mod+Ctrl+2 { move-column-to-workspace 2; }
                Mod+Ctrl+3 { move-column-to-workspace 3; }
                Mod+Ctrl+4 { move-column-to-workspace 4; }
                Mod+Ctrl+5 { move-column-to-workspace 5; }
                Mod+Ctrl+6 { move-column-to-workspace 6; }
                Mod+Ctrl+7 { move-column-to-workspace 7; }
                Mod+Ctrl+8 { move-column-to-workspace 8; }
                Mod+Ctrl+9 { move-column-to-workspace 9; }
            
                Mod+BracketLeft  { consume-or-expel-window-left; }
                Mod+BracketRight { consume-or-expel-window-right; }
            
                Mod+Comma  { consume-window-into-column; }
                Mod+Period { expel-window-from-column; }
            
                Mod+R { switch-preset-column-width; }
                Mod+Shift+R { switch-preset-window-height; }
                Mod+Ctrl+R { reset-window-height; }
                Mod+F { maximize-column; }
                Mod+Shift+F { fullscreen-window; }
            
                Mod+Ctrl+F { expand-column-to-available-width; }
            
                Mod+C { center-column; }
            
                Mod+Ctrl+C { center-visible-columns; }
            
                Mod+Minus { set-column-width "-10%"; }
                Mod+Equal { set-column-width "+10%"; }
            
                Mod+Shift+Minus { set-window-height "-10%"; }
                Mod+Shift+Equal { set-window-height "+10%"; }
            
                Mod+V       { toggle-window-floating; }
                Mod+Shift+V { switch-focus-between-floating-and-tiling; }
            
                Mod+W { toggle-column-tabbed-display; }
            
                Print { screenshot; }
                Ctrl+Print { screenshot-screen; }
                Alt+Print { screenshot-window; }
            
                Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
            
                Mod+Shift+E { quit; }
                Ctrl+Alt+Delete { quit; }
            
                Mod+Shift+P { power-off-monitors; }
            }
        '';

    };

    programs.rofi = {
        enable = true;
        theme = "${config.home.homeDirectory}/.cache/wal/rofi.rasi";
    };
    
    home.file.".config/wal/templates" = {
        source = ./pywal-templates;
        recursive = true;
    };
    home.file.".config/wpg/templates" = {
        source = ./wpg-templates;
        recursive = true;
    };
    xdg.dataFile."themes" = {
        source = ./themes;
        recursive = true;
    };

    systemd.user.tmpfiles.rules = [
        "L ${config.home.homeDirectory}/.config/Kvantum/Pywal/Pywal.kvconfig - - - -  ${config.home.homeDirectory}/.cache/wal/Kvantum.kvconfig"
        "L ${config.home.homeDirectory}/.config/Kvantum/Pywal/Pywal.svg - - - -  ${config.home.homeDirectory}/.cache/wal/Kvantum.svg"
        "L ${config.home.homeDirectory}/.config/mako/config - - - -  ${config.home.homeDirectory}/.cache/wal/mako.conf"
        "L ${config.home.homeDirectory}/.config/swaylock/config - - - -  ${config.home.homeDirectory}/.cache/wal/swaylock.conf"
        "L ${config.home.homeDirectory}/.local/share/themes/FlatColor/gtk-2.0/gtkrc - - - -  ${config.home.homeDirectory}/.config/wpg/templates/gtk2"
        "L ${config.home.homeDirectory}/.local/share/themes/FlatColor/gtk-3.0/gtk.css - - - -  ${config.home.homeDirectory}/.config/wpg/templates/gtk3"
        "L ${config.home.homeDirectory}/.local/share/themes/FlatColor/gtk-4.0/gtk.css - - - -  ${config.home.homeDirectory}/.config/wpg/templates/gtk4"
        "L ${config.home.homeDirectory}/.local/share/themes/FlatColor/gtk-3.20/gtk.css - - - -  ${config.home.homeDirectory}/.config/wpg/templates/gtk3.2"
    ];

    xdg.configFile."Kvantum/kvantum.kvconfig" = {
        enable = true;
        text = ''
            theme=Pywal
        '';
    };

    gtk = {
        enable = true;
        theme.name = "FlatColor";
        iconTheme.name = "Adwaita";
        iconTheme.package = pkgs.adwaita-icon-theme;
    };
    
    home.packages = [ 
        pkgs.wdisplays
        pkgs.pywal
        pkgs.swaybg 
        pkgs.wpgtk
        (pkgs.writeShellScriptBin "dmenu" ''
            exec ${pkgs.rofi}/bin/rofi -dmenu "$@"
        '')
        (pkgs.writeShellScriptBin "bg-update" ''
            SWAYBG=$(pgrep swaybg)
            FOLDER="${config.home.homeDirectory}/nixos/assets/wallpaper"
            IMAGE=$(ls $FOLDER | grep -v "^current$" | dmenu -i -p "Select wallpaper:")

            if [ -n "$IMAGE" ]; then 
                if [ -n "$SWAYBG" ]; then
                    kill $SWAYBG
                fi
                nohup swaybg -i "$FOLDER/$IMAGE" > /dev/null 2>&1 &
                wpg -a "$FOLDER/$IMAGE"
                wpg -s "$FOLDER/$IMAGE"

                if [ -f "$FOLDER/current" ]; then
                    rm "$FOLDER/current"
                fi
                ln -s "$FOLDER/$IMAGE" "$FOLDER/current"
                tmux source-file "${config.home.homeDirectory}/.config/tmux/tmux.conf"
                makoctl reload

                BROWSER=$(pgrep -f qutebrowser)
                if [ -n "$BROWSER" ]; then
                    qutebrowser ":config-source"
                fi
            fi
        '')
    ];
}
