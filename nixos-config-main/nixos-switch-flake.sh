#!/bin/bash
echo "Switching nixos to .\#nixos flake"

# Run nixos-rebuild switch in the background with --flake option and capture filtered output
output=$(nixos-rebuild switch --flake .#nixos 2>&1 | grep -E '\[.+\]|^building ') &

# Capture the background process ID
background_pid=$!

# Continuously check the background process status (optional)
while kill -0 "$background_pid" 2>/dev/null; do
  # Optional visual cue (can be commented out)
  echo -n "."
  sleep 1
done

# Wait for the background process to finish
wait "$background_pid"

# Check the exit code
if [[ $? -eq 0 ]]; then
  echo "NixOS rebuild successful."
else
  # Print captured output focusing on errors
  echo "Rebuild failed. See errors below:"
  grep -iE '^error:' /dev/stderr
fi

# Remove temporary captured output (optional)
# rm /dev/stderr

