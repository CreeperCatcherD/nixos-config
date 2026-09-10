#!/usr/bin/env bash
# Toggle (or force) DPMS.
#
# Hyprland 0.56's Lua config dropped the old "dispatch dpms toggle" CLI
# syntax (dispatch now takes a single Lua expression), so this goes through
# `hyprctl eval` calling the actual hl.dsp.dpms() Lua API instead.

set -euo pipefail

action="${1:-toggle}"
hyprctl eval "hl.dispatch(hl.dsp.dpms('${action}'))" >/dev/null
