# Backlight often has a nonzero hardware floor - brightnessctl reaching 0%
# still leaves the panel visibly lit. Once the backlight is at 0%, fall
# through to dimming via hyprsunset's gamma (CTM) control instead, and
# reverse that before touching the backlight again on the way back up.

GAMMA_MIN=20
GAMMA_STEP=20
GAMMA_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-gamma"
SOCK="${XDG_RUNTIME_DIR:-/tmp}/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/.hyprsunset.sock"

gamma=$(cat "$GAMMA_FILE" 2>/dev/null || echo 100)

set_gamma() {
  echo "gamma $1" | socat - "UNIX-CONNECT:$SOCK" >/dev/null 2>&1 || true
  echo "$1" > "$GAMMA_FILE"
}

case "${1:-}" in
  down)
    pct=$(brightnessctl get)
    if [ "$pct" -gt 0 ]; then
      brightnessctl set 5%-
    elif [ "$gamma" -gt "$GAMMA_MIN" ]; then
      next=$(( gamma - GAMMA_STEP > GAMMA_MIN ? gamma - GAMMA_STEP : GAMMA_MIN ))
      set_gamma "$next"
    fi
    ;;
  up)
    if [ "$gamma" -lt 100 ]; then
      next=$(( gamma + GAMMA_STEP < 100 ? gamma + GAMMA_STEP : 100 ))
      set_gamma "$next"
    else
      brightnessctl set 5%+
    fi
    ;;
esac
