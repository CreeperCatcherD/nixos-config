#!/bin/bash
echo "Switching NixOS to .#nixos flake"

# Run nixos-rebuild switch in the background with --flake option
# Redirect standard error (stderr) directly to the terminal
nixos-rebuild switch --flake .#nixos 2>&1 &

# Capture the background process ID
background_pid=$!

# Wait for the background process to finish
wait "$background_pid"

# Check the exit code
if [[ $? -eq 0 ]]; then
  echo "NixOS rebuild successful."
else
  echo "Rebuild failed. See detailed errors in the terminal output."
fi

# Remove temporary captured output (optional)
# rm /dev/stderr
