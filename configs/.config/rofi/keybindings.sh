#!/usr/bin/env bash

# Current Theme
dir="$XDG_CONFIG_HOME/rofi/keybindings"
theme='main'

HyprCONF="$XDG_CONFIG_HOME/hypr/configs/keybindings.conf"
UserCONF="$XDG_CONFIG_HOME/hypr/userprefs.conf"

awk '
BEGIN {
  first_heading = 1
  in_userpref = 0
  userpref_heading_printed = 0
}

# Ignore empty,single-# comments, whitespace-only lines
/^[[:space:]]*$/ { next }
/^[[:space:]]*#(?!#)/ { next }


function print_heading(title) {
  width = 72
  pad = int((width - length(title)) / 2)
  if (pad < 0) pad = 0

  if (!first_heading)
    printf "\n"

  printf "%*s%s\n", pad, "", title
  first_heading = 0
}

# Headings from keybindings.conf only
/^[[:space:]]*## / && FILENAME !~ /userprefs\.conf$/ {
  title = toupper(substr($0, 4))
  print_heading(title)
  next
}

/^bind/ {
  line = $0
  desc = ""

  # If this is the first bind in userprefs.conf, print heading
  if (FILENAME ~ /userprefs\.conf$/ && !userpref_heading_printed) {
    print_heading("USER PREFERENCES")
    userpref_heading_printed = 1
  }

  # extract description
  if (line ~ / #[^#]/) {
    split(line, p, "#")
    desc = p[2]
    sub(/^[[:space:]]+/, "", desc)
    line = p[1]
  }

  # split on =
  split(line, eq, "=")
  rhs = eq[2]

  # split RHS on commas
  split(rhs, f, ",")

  mods = f[1]
  key  = f[2]

  gsub(/^[[:space:]]+|[[:space:]]+$/, "", mods)
  gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)

  if (key == "")
    next

  # XF86 key icons / labels
  if (key ~ /^XF86/) {
    if      (key == "XF86AudioMute")          key = "󰝟  Mute"
    else if (key == "XF86AudioLowerVolume")   key = "󰕾  Volume Down"
    else if (key == "XF86AudioRaiseVolume")   key = "󰕿  Volume Up"
    else if (key == "XF86AudioMicMute")       key = "  Mic Mute"

    else if (key == "XF86AudioPlay")          key = "󰖁  Play / Pause"
    else if (key == "XF86AudioNext")          key = "󰒭  Next"
    else if (key == "XF86AudioPrev")          key = "󰒮  Previous"

    else if (key == "XF86MonBrightnessUp")    key = "󰃠  Brightness Up"
    else if (key == "XF86MonBrightnessDown")  key = "󰃡  Brightness Down"
    else {
      gsub(/^XF86Mon/, "", key)
      gsub(/^XF86Audio/, "", key)
      gsub(/([a-z])([A-Z])/, "\\1 \\2", key)
    }
  }

  if (key ~ /^mouse/) {
    if (key == "mouse:272") key = "Left Click"
    else if (key == "mouse:273") key = "Right Click"
    else if (key == "mouse:274") key = "Middle Click"
    else if (key == "mouse:275") key = "Mouse Back"
    else if (key == "mouse:276") key = "Mouse Forward"
    else if (key == "mouse_up") key = "Mouse Scroll Up"
    else if (key == "mouse_down") key = "Mouse Scroll Down"
  }

  # expand variables
  gsub(/\$mainMod/, "SUPER", mods)

  # modifier icons
  gsub(/SUPER/, "󰣇", mods)
  gsub(/CTRL/,  "⌃",  mods)
  gsub(/ALT/,   "⎇",  mods)
  gsub(/SHIFT/, "⇧",  mods)

  # spacing
  gsub(/[[:space:]]+/, " + ", mods)

  if (mods != "")
    combo = mods " + " key
  else
    combo = key

  if (desc != "")
    printf "%-10s → %s\n", combo, desc
  else
    printf "%-10s\n", combo
}
' "$HyprCONF" "$UserCONF" \
| rofi -dmenu -i -p "󰌌 " -theme "${dir}/${theme}.rasi"
