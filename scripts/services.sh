#!/bin/sh

print_block() {
  echo
  echo "== $1 =="
}

# user services to enable
USER_SERVICES="
pipewire
wireplumber
"

# system services to enable
SYSTEM_SERVICES="
bluetooth
NetworkManager
power-profiles-daemon
sddm
"

print_block "ENABLING USER SERVICES"

for svc in $USER_SERVICES; do
  if systemctl --user is-enabled "$svc" >/dev/null 2>&1; then
    echo "== OK == user service already enabled: $svc"
  else
    systemctl --user enable --now "$svc" \
      && echo "== OK == enabled user service: $svc" \
      || echo "== FAIL == $svc"
  fi
done

print_block "ENABLING SYSTEM SERVICES"

for svc in $SYSTEM_SERVICES; do
  if systemctl is-enabled "$svc" >/dev/null 2>&1; then
    echo "== OK == system service already enabled: $svc"
  else
    sudo systemctl enable --now "$svc" \
      && echo "== OK == enabled system service: $svc" \
      || echo "== FAIL == $svc"
  fi
done