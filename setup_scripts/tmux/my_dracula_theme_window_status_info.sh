show_zoom_icon=$(get_tmux_option "@dracula-show-zoom-icon" 🔍)
# Handle zoom icon
if [ $show_zoom_icon != false ]; then
  zoom_icon=" $show_zoom_icon"
fi

if $show_powerline; then
else
  tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W#{?window_zoomed_flag,${zoom_icon},} "
  # tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W " # original code
fi

tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${gray}] #I #W#{?window_zoomed_flag,${zoom_icon},} "
# tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${gray}] #I #W " # original code
