#!/bin/bash

export GTK_THEME=Adwaita-dark  # Or Arc-Dark, etc.
# Close previous instance
pkill -f "yad --calendar" 2>/dev/null

# Show popup calendar near mouse
yad --calendar \
    --title="Calendar" \
    --undecorated \
    --skip-taskbar \
    --on-top \
    --mouse \
    --borders=10 \
    --width=250 \
    --height=200 \
    --gtkrc="$HOME/.config/polybar/scripts/yad-dark-theme.gtkrc" &

