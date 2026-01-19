#!/usr/bin/env bash

# Current Theme
dir="$XDG_CONFIG_HOME/rofi/clipboard"
theme='1'

# CMD
cliphist list | rofi -dmenu -replace -p "󰅇" -theme ${dir}/${theme}.rasi | cliphist decode | wl-copy