#!/data/data/com.termux/files/usr/bin/env bash
# torch-blinker.sh
#
# Minimal torch blinker for Termux (Android).
# - Press 'n' to toggle pause/resume.
# - Press 'q' or Ctrl-C to turn the torch off and exit.
# - Default toggle interval: 0.12 seconds (configurable).
#
# Requirements:
#   - Termux
#   - Termux:API application installed
#   - termux-api package installed (provides `termux-torch`)

SLEEP=0.12      # Toggle interval in seconds (floating point supported).
STATE=0         # Current torch state: 0 = off, 1 = on.
PAUSED=0        # Pause flag: 0 = running, 1 = paused.

# -----------------------------------------------------------------------------
# Cleanup routine
# Ensures the torch is turned off and terminal state is restored before exit.
# -----------------------------------------------------------------------------
cleanup() {
  termux-torch off >/dev/null 2>&1
  stty sane
  echo
  echo "Torch disabled. Exiting."
  exit 0
}

# Handle SIGINT (Ctrl-C) and SIGTERM for graceful shutdown.
trap 'cleanup' INT TERM

# -----------------------------------------------------------------------------
# Dependency check
# -----------------------------------------------------------------------------
if ! command -v termux-torch >/dev/null 2>&1; then
  echo "Error: 'termux-torch' not found."
  echo "Ensure Termux:API is installed and the termux-api package is available."
  exit 1
fi

echo "Started — press 'n' to pause/resume, 'q' to quit. Ctrl-C also exits."

# -----------------------------------------------------------------------------
# Main event loop
# Uses non-blocking single-character input with timeout.
# If no key is pressed within $SLEEP, torch state toggles automatically.
# -----------------------------------------------------------------------------
while true; do
  if read -rsn1 -t "$SLEEP" key 2>/dev/null; then
    case "$key" in
      n)
        PAUSED=$((1 - PAUSED))
        if [ "$PAUSED" -eq 1 ]; then
          termux-torch off >/dev/null 2>&1
          STATE=0
          echo -e "\n[PAUSED]"
        else
          echo -e "\n[RESUMED]"
        fi
        ;;
      q)
        echo -e "\n[QUIT]"
        cleanup
        ;;
      *)
        # Ignore all other input.
        ;;
    esac
  else
    # Timeout reached: perform toggle if not paused.
    if [ "$PAUSED" -eq 0 ]; then
      if [ "$STATE" -eq 0 ]; then
        termux-torch on >/dev/null 2>&1
        STATE=1
      else
        termux-torch off >/dev/null 2>&1
        STATE=0
      fi
    fi
  fi
done
