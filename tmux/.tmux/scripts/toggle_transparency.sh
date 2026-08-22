#!/usr/bin/env bash
# Global Tmux status bar transparency manager

ACTION="${1:-toggle}"
CURRENT_STATE=$(tmux show-option -gqv "@transparency")

if [ -z "$CURRENT_STATE" ]; then
  CURRENT_STATE="on"
fi

if [ "$ACTION" = "toggle" ]; then
  if [ "$CURRENT_STATE" = "on" ]; then
    NEW_STATE="off"
  else
    NEW_STATE="on"
  fi
  tmux set-option -g @transparency "$NEW_STATE"
  SHOW_MSG=1
else
  NEW_STATE="$CURRENT_STATE"
  SHOW_MSG=0
fi

if [ "$NEW_STATE" = "on" ]; then
  tmux set-option -g status-style "bg=default"
  tmux set-window-option -g window-status-style "bg=default"
  if [ "$SHOW_MSG" -eq 1 ]; then
    tmux display-message "Tmux bar transparency: ENABLED"
  fi
else
  if [ -f "$HOME/.tmux/tinty-colors.conf" ]; then
    tmux source-file "$HOME/.tmux/tinty-colors.conf"
  fi
  if [ "$SHOW_MSG" -eq 1 ]; then
    tmux display-message "Tmux bar transparency: DISABLED"
  fi
fi
