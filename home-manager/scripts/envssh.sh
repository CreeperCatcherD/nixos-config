#!/usr/bin/env bash
set -euo pipefail

# ssh into HOST with the remote graphical session's environment merged in
# (DISPLAY, WAYLAND_DISPLAY, XDG_RUNTIME_DIR, DBUS_SESSION_BUS_ADDRESS,
# HYPRLAND_INSTANCE_SIGNATURE, XAUTHORITY, ...), instead of the bare env a
# fresh ssh login gets. Without this, things like `hyprctl` fail remotely
# because those vars only ever get set inside the graphical session's own
# process tree, not in a plain ssh shell.
#
# usage: envssh HOST [COMMAND...]
#   envssh laptop                       # login shell with the full env
#   envssh laptop hyprctl monitors      # one-off command with the full env

if [ "$#" -lt 1 ]; then
  echo "usage: envssh HOST [COMMAND...]" >&2
  exit 1
fi

host=$1
shift

cmd=""
if [ "$#" -gt 0 ]; then
  cmd=$(printf '%q ' "$@")
fi

ssh -t "$host" bash -s -- "$cmd" <<'REMOTE'
set -eu

# Primary source: whatever the graphical session imported into
# systemd --user at login (Hyprland/GNOME/KDE all do this; this repo's
# own Hyprland config runs `systemctl --user import-environment` on start).
if command -v systemctl >/dev/null 2>&1; then
  while IFS='=' read -r name value; do
    [ -n "$name" ] || continue
    export "$name=$value"
  done <<< "$(systemctl --user show-environment 2>/dev/null || true)"
fi

# Fallback/supplement: if the display vars still aren't set, pull them
# straight out of a live process in the graphical session.
if [ -z "${WAYLAND_DISPLAY:-}${DISPLAY:-}" ]; then
  for pidenv in /proc/[0-9]*/environ; do
    [ -r "$pidenv" ] || continue
    owner=$(stat -c %U "$pidenv" 2>/dev/null) || continue
    [ "$owner" = "$(id -un)" ] || continue
    vars=$(tr '\0' '\n' < "$pidenv" 2>/dev/null \
      | grep -E '^(WAYLAND_DISPLAY|DISPLAY|XAUTHORITY|DBUS_SESSION_BUS_ADDRESS|XDG_RUNTIME_DIR|HYPRLAND_INSTANCE_SIGNATURE)=') || true
    [ -n "$vars" ] || continue
    while IFS= read -r line; do export "$line"; done <<< "$vars"
    break
  done
fi

if [ -n "$1" ]; then
  eval "exec $1"
else
  exec "${SHELL:-bash}" -l
fi
REMOTE
