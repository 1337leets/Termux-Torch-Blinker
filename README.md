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
# Controls

| Key        | Action             |
|------------|--------------------|
| `n`        | Pause / Resume     |
| `q`        | Quit               |
| `Ctrl+C`   | Force exit safely  |

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

# Python version
`torch-blinker.py` does the same job in Python and adds five speed levels that can be changed while it runs.

It uses the `termux` Python module from the `termux-api` package on PyPI to switch the torch. The Termux:API app from F-Droid is needed as well.

```bash
pip install termux-api
```

```bash
python3 torch-blinker.py
```

| Key        | Action                                      |
|------------|---------------------------------------------|
| `1` to `5` | Toggle interval 0.10, 0.07, 0.05, 0.03 or 0.01 s |
| `n`        | Pause / Resume                              |
| `q`        | Quit                                        |
| `Ctrl+C`   | Force exit safely                           |

It starts at level 3 (0.05 s). As with the shell version, the real blink rate is limited by how fast Android switches the torch.
