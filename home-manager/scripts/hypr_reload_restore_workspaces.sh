#!/usr/bin/env bash
set -euo pipefail

# hyprctl reload re-processes monitor rules from scratch on every call,
# which can knock the active workspace on each monitor back to whatever
# the config considers default. Snapshot each monitor's active workspace
# first, reload, then restore them.

mapfile -t workspace_states < <(hyprctl monitors -j | jq -r '.[] | "\(.name) \(.activeWorkspace.id)"')

hyprctl reload

sleep 0.2

for state in "${workspace_states[@]}"; do
  monitor="${state%% *}"
  ws="${state##* }"
  hyprctl dispatch focusmonitor "$monitor"
  hyprctl dispatch workspace "$ws"
done
