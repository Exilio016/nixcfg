{ pkgs, config, ...} : {
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          ll = "ls -l";
          update = "home-manager switch --flake ${config.home.homeDirectory}/nixos#brunofl@nixos";
          updateSystem = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos#";
          updateVersion = "nix flake update";
          gs = "git status";
          gap = "git add -p";
          ga = "git add";
          gc = "git commit";
          gcp = "git cherry-pick";
        };

        initContent = # bash
          ''
            if [ -z "$TMUX" ]; then
                tmux attach || tmux
            fi 

            [ -f "${config.home.homeDirectory}/.config/wpg/sequences" ] &&
                cat "${config.home.homeDirectory}/.config/wpg/sequences"
            [ -f "${config.home.homeDirectory}/.config/wpg/sequences" ] &&
                source ${config.home.homeDirectory}/.cache/wal/colors-tty.sh

            source "$(fzf-share)/key-bindings.zsh"
            source "$(fzf-share)/completion.zsh"
            # This command let's me execute arbitrary binaries downloaded through channels such as mason.
            export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
            export TERM="screen-256color"
            ssh-add ~/.ssh/id_ykmain 2> /dev/null
          '';

        oh-my-zsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [
            "docker"
            "git"
            "timer"
          ];
        };
        history.size = 10000;
    };
    programs.tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
        plugins = [
          { plugin = pkgs.tmuxPlugins.vim-tmux-navigator; }
          { plugin = pkgs.tmuxPlugins.yank; }
          { plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
                pluginName = "pywal-theme";
                version = "0.1.0";
                rtpFilePath = "pywal.tmux";
                src = ./tmux-pywal-theme;
            };
          }
        ];
        extraConfig = # bash
          ''
            unbind r 
            bind r source-file "~/.config/tmux/tmux.conf"
            set -g prefix C-s
            set -g mouse on
            set -gq allow-passthrough on

            set-option -g status-position top
            set-option -sg escape-time 10
            set-option -g default-terminal "screen-256color"
            set-option -sa terminal-features ',screen-256color:RGB'
            set-window-option -g mode-keys vi

            bind-key h select-pane -L
            bind-key j select-pane -D
            bind-key k select-pane -U
            bind-key l select-pane -R

            bind-key v split-window -h -c '#{pane_current_path}'
            bind-key b split-window -v -c '#{pane_current_path}'
            bind-key t split-window -v -l 20% -c '#{pane_current_path}'
            bind-key c new-window -c '#{pane_current_path}'
            bind-key k kill-pane
          '';
    };
    programs.alacritty = {
        enable = true;
        settings = {
            window = {
                opacity = 0.8;
                blur = true;
                padding = {
                    x = 5;
                    y = 5;
                };
            };
            colors.transparent_background_colors = true;

        };
    };
    home.packages = with pkgs; [ 
        fzf
        ripgrep
        yazi
        nil
        inotify-tools
        tree-sitter
        vscode-langservers-extracted
        nodejs
    ];
}
