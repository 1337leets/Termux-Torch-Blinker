# Termux-Torch-Blinker
A minimal real-time torch blinker utility for Termux (Android) using the termux-torch function from the Termux API.

Designed as a lightweight CLI tool demonstrating:
* Non-blocking single-character input
* Real-time state toggling
* Signal handling (trap)
* Graceful shutdown and hardware cleanup

# Features
- Adjustable toggle interval
- Pause / resume control (n)
- Immediate shutdown (q or Ctrl+C)
- Safe torch cleanup on exit
- Zero external dependencies beyond Termux API

# Requirements
- Termux
- Termux:API app installed
- termux-api package installed
Install API package if needed:
```bash
pkg install termux-api
```

# Usage
Make the script executable:
```bash
chmod +x torch-blinker.sh
```
Run:
```bash
./torch-blinker.sh
```
# Controls:
Key       Action
n         Pause / Resume
q         Quit
Ctrl + C  Force exit safely

# Configuration
Inside the script:
```bash
SLEEP=0.12
```
Controls the toggle interval (seconds).
Lower values attempt faster blinking, but actual speed depends on Android torch API latency.

# Technical Notes
Torch toggling speed is limited by Android's hardware abstraction layer.
Rapid state switching may not scale linearly due to system-level throttling.
This project intentionally keeps the implementation minimal and dependency-free.
