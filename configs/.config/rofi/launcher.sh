#!/usr/bin/env bash

# Current Theme
dir="$XDG_CONFIG_HOME/rofi/launcher"
theme='1'


# Rofi CMD
rofi -show drun -theme ${dir}/${theme}.rasi
