#!/usr/bin/env python3
import sys
import time
import select
import tty
import termios
from termux import API

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
# Speed levels, toggle interval in seconds
SPEED_MAP = {
    '1': 0.10,
    '2': 0.07,
    '3': 0.05,
    '4': 0.03,
    '5': 0.01
}
SLEEP = SPEED_MAP['3']  # starting speed
STATE = False      # current torch state: False = off, True = on
PAUSED = False     # pause flag

print("Started — press 'n' to pause/resume, 'q' to quit.")
print("Press '1'-'5' to change speed (1=slow, 5=fast). Ctrl-C to exit.")

# Save the terminal settings so they can be restored on exit
orig_settings = termios.tcgetattr(sys.stdin)

def cleanup():
    """Turn the torch off, restore the terminal and exit."""
    API.torch(False)
    termios.tcsetattr(sys.stdin, termios.TCSANOW, orig_settings)
    print("\nTorch disabled. Exiting.")
    sys.exit(0)

try:
    # cbreak mode delivers single key presses without Enter
    tty.setcbreak(sys.stdin.fileno())

    while True:
        # Wait up to SLEEP seconds for a key, a timeout means it is time to toggle
        rlist, _, _ = select.select([sys.stdin], [], [], SLEEP)

        if rlist:
            key = sys.stdin.read(1)

            if key == 'n':
                PAUSED = not PAUSED
                API.torch(False)
                STATE = False
                print(f"\n[{'PAUSED' if PAUSED else 'RESUMED'}]")

            elif key in SPEED_MAP:
                SLEEP = SPEED_MAP[key]
                print(f"\n[SPEED SET TO {key} ({SLEEP}s)]")

            elif key == 'q':
                print("\n[QUIT]")
                cleanup()
        else:
            if not PAUSED:
                STATE = not STATE
                API.torch(STATE)

except KeyboardInterrupt:
    cleanup()
except Exception as e:
    print(f"\nError: {e}")
    cleanup()
