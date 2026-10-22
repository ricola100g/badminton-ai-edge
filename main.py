#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
=============================================================================
Badminton Edge AI Real-Time Video Analytics Pipeline
Firefly RK3588 + MemryX MX3 M.2 AI Accelerator
=============================================================================
This program executes the pre-compiled native ARM64 core engine.
Do not distribute source code without authorization.
=============================================================================
"""

import sys
import os

# Ensure repo directory is in Python module search path
REPO_ROOT = os.path.dirname(os.path.abspath(__file__))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)

# Ensure X11 DISPLAY is set for GUI / HDMI output
if "DISPLAY" not in os.environ:
    os.environ["DISPLAY"] = ":0"

def check_environment():
    """Verify system prerequisites before loading core binary."""
    # Check Python version
    if sys.version_info < (3, 8):
        print(f"[Error] Python 3.8+ is required. Found Python {sys.version_info.major}.{sys.version_info.minor}")
        sys.exit(1)

    # Check NPU device
    npu_dev = "/dev/memx0"
    if not os.path.exists(npu_dev):
        print(f"[Warning] MemryX NPU device '{npu_dev}' not found.")
        print("          Please verify the MemryX M.2 card is inserted and the driver is loaded.")
        print("          Run 'ls -l /dev/memx*' to inspect device nodes.")

def main():
    check_environment()
    try:
        import badminton_core
    except ImportError as err:
        print("=" * 60)
        print("[Fatal Error] Failed to load compiled 'badminton_core' module.")
        print(f"Details: {err}")
        print("=" * 60)
        print("Troubleshooting steps:")
        print("  1. Run './install.sh' to verify and install all dependencies.")
        print("  2. Ensure Python 3.10 is installed on ARM64 Linux (Ubuntu 20.04 / 22.04).")
        print("  3. Make sure 'badminton_core.cpython-310-aarch64-linux-gnu.so' exists in:")
        print(f"     {REPO_ROOT}")
        print("=" * 60)
        sys.exit(1)

    badminton_core.main()

if __name__ == "__main__":
    main()
