
load() {
    . ${HOME}/.cache/wal/colors.sh
    tmux set-option -gq status-bg "$background"
    tmux set-option -gq status-fg "$foreground"
    tmux set-option -gq status-left "#[bg=${color1} fg=${background}] #S #[bg=${color2} fg=${color1}]"
    tmux set-option -gq window-status-format "#[bg=${color2} fg=${background}] #I: #W "
    tmux set-option -gq window-status-current-format "#[bg=${color2} fg=${background}]  #I: #W "
    tmux set-option -gq window-status-separator "#[fg=${background} bg=${color2}]"
    tmux set-option -gq status-right "#[bg=${background} fg=${color4}]#[bg=${color4} fg=${background}]  #(id -u -n) #[bg=${color4} fg=${color3}]#[bg=${color3} fg=${background}]   #h "
}

load
