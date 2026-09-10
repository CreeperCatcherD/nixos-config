#!/usr/bin/env bash
# Compare each connected monitor's current resolution against its
# configured resolution ($HYPR_CONFIGURED_MONITORS_JSON: a JSON array of
# {output,mode,position,scale}, one per entry in myOptions.screens), or -
# for outputs with no explicit config, e.g. an ad-hoc external monitor -
# against the best mode it currently advertises. Anything that doesn't
# match gets a disable/re-enable cycle to force Hyprland to redo a full
# modeset: the software-side fix for a monitor that comes back at a low
# fallback resolution after DPMS/sleep instead of renegotiating its real
# EDID (normally only fixed by physically unplugging and replugging it).

set -euo pipefail

configured="${HYPR_CONFIGURED_MONITORS_JSON:-[]}"

refresh_output() {
  local name="$1" mode="$2" pos="$3" scale="$4"
  echo "hypr-fix-low-res: refreshing $name -> $mode" >&2
  if ! hyprctl eval "hl.monitor({output='$name', disabled=true})" >/dev/null; then
    echo "hypr-fix-low-res: failed to disable $name, leaving it alone" >&2
    return 0
  fi
  # Give the link time to retrain before asking for a specific mode - right
  # after disable, a still-negotiating output can reject an explicit mode
  # (it's not yet in its advertised list), and under `set -e` that failure
  # would abort the script with the monitor stuck disabled.
  sleep 1.5
  if ! hyprctl eval "hl.monitor({output='$name', mode='$mode', position='$pos', scale=$scale, disabled=false})" >/dev/null; then
    echo "hypr-fix-low-res: mode '$mode' rejected for $name, retrying with preferred" >&2
    hyprctl eval "hl.monitor({output='$name', mode='preferred', position='$pos', scale=$scale, disabled=false})" >/dev/null \
      || echo "hypr-fix-low-res: failed to re-enable $name" >&2
  fi
}

hyprctl monitors -j | jq -c '.[] | select(.disabled == false)' | while read -r mon; do
  name=$(jq -r '.name' <<<"$mon")
  width=$(jq -r '.width' <<<"$mon")
  height=$(jq -r '.height' <<<"$mon")

  target=$(jq -c --arg n "$name" '[.[] | select(.output == $n)][0] // empty' <<<"$configured")

  if [ -n "$target" ]; then
    mode=$(jq -r '.mode' <<<"$target")
    pos=$(jq -r '.position' <<<"$target")
    scale=$(jq -r '.scale' <<<"$target")
    target_res="${mode%%@*}"
    if [ "${width}x${height}" != "$target_res" ]; then
      refresh_output "$name" "$mode" "$pos" "$scale"
    fi
  else
    best=$(jq -r '
      (.availableModes // [])
      | map(split("@")[0] | split("x") | map(tonumber))
      | if length == 0 then empty else (max_by(.[0] * .[1]) | "\(.[0])x\(.[1])") end
    ' <<<"$mon")
    if [ -n "$best" ] && [ "${width}x${height}" != "$best" ]; then
      pos=$(jq -r '"\(.x)x\(.y)"' <<<"$mon")
      scale=$(jq -r '.scale' <<<"$mon")
      refresh_output "$name" "preferred" "$pos" "$scale"
    fi
  fi
done
