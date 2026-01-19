#!/bin/sh

BAT=$(ls /sys/class/power_supply 2>/dev/null | grep -E '^BAT' | head -n1)

# no battery found (desktop etc)
[ -z "$BAT" ] && exit 0

CAP=$(cat /sys/class/power_supply/$BAT/capacity)
STAT=$(cat /sys/class/power_supply/$BAT/status)

if [ "$STAT" = "Charging" ]; then
    echo "⚡ ${CAP}%"
else
    echo "🔋 ${CAP}%"
fi
