# Badminton Edge AI Real-Time Video Analytics Pipeline

[English](README.md) | [繁體中文](README_zh-TW.md) | [简体中文](README_zh-CN.md)

[![Hardware](https://img.shields.io/badge/Hardware-Rockchip%20RK3588-blue.svg)](https://en.wikipedia.org/wiki/Rockchip)
[![NPU](https://img.shields.io/badge/NPU-MemryX%20MX3%20M.2-green.svg)](https://memryx.com)
[![Display](https://img.shields.io/badge/Output-HDMI%201080p60%20Zero--Tear-orange.svg)]()
[![Inference](https://img.shields.io/badge/Inference-30%20FPS%20Realtime-red.svg)]()

High-performance real-time badminton match analytics and tactical HUD dashboard designed specifically for **Firefly RK3588** and **MemryX MX3 M.2 Edge AI Accelerator**.
Built upon a zero-copy POSIX shared memory architecture and asynchronous dual-buffered streaming, achieving **1080p60 HDMI fullscreen output** and **authentic 30 FPS YOLOv8 pose inference** with near-zero CPU overhead.
Designed for non-engineers, sales, and field specialists to install in 3 simple steps and deliver seamless customer demonstrations.

---

## 1. Key Features & Customer Value

1. **Ultra-Smooth Real-Time Playback**: Full NPU acceleration on MemryX MX3 with async dual-buffering keeps ARM CPU cool and locks HDMI 60Hz tear-free presentation at authentic 30 FPS inference.
2. **Singles (1v1) & Doubles (2v2) Support**:
   - **Singles Mode**: Tracks far court (P1) and near court (P2), filtering out high umpire chair and audience.
   - **Doubles Mode**: Simultaneously tracks all 4 players with front/back court separation.
   - **Auto-Detection**: Dynamically clusters player spatial distribution within the first 30 frames.
3. **2D BWF Court Mini-Map & Ground Tracking**:
   - Uses **dual-ankle ground contact points (Keypoints 15, 16)** for Homography projection, eliminating perspective distortion during jumping smashes.
   - Real-time cumulative player movement heatmap overlay (`cv.COLORMAP_TURBO`).
4. **Bottom HUD Tactical Dashboard (3 Live Cards)**:
   - **Card 1 (Stamina & Radar)**: Instantaneous speed (km/h), cumulative running distance (m), court zones, and dynamic stamina expenditure progress bar.
   - **Card 2 (Offense/Defense Analytics)**: Live posture recognition (`Smash`, `Net Kill`, `Drive`, `Drop`, `Lift`) and pressure distribution balance bar.
   - **Card 3 (Rally Tactics)**: Shot exchange counter, rally intensity rating, and tactical feature assessment.
5. **Bundled Demonstration Videos**: Pre-packaged high-definition clips (`videos/Badminton_SinglePlay_20s.mp4`) are included—no extra downloads required.

---

## 2. Hardware & Environment Requirements

| Component | Specification | Notes |
| :--- | :--- | :--- |
| **Mainboard** | Firefly RK3588 (8-Core ARM64) | 4GB / 8GB / 16GB DDR4 compatible |
| **AI Accelerator** | MemryX MX3 M.2 Key-M PCIe card | Inserted in M.2 slot (`/dev/memx0`) |
| **Display** | HDMI Monitor (1920x1080 @ 60Hz) | Connected to RK3588 HDMI output |
| **Operating System** | Ubuntu Linux 20.04 / 22.04 LTS (ARM64) | X11 Desktop environment (`DISPLAY=:0`) |
| **Camera (Optional)** | UVC USB Camera | Supports 1080p @ 30 FPS MJPG mode |

---

## 3. Quick Start for Non-Engineers (3 Simple Steps)

Open the **Terminal** application on the Ubuntu desktop and run these three commands:

### Step 1: Clone the Repository
```bash
git clone https://github.com/ricola100g/badminton-ai-edge.git
cd badminton-ai-edge
```

### Step 2: Run One-Click Environment Setup Wizard
```bash
chmod +x install.sh
./install.sh
```
> The wizard automatically:
> - Checks Python 3.10 and installs GUI/multimedia dependencies
> - Configures MemryX NPU device permissions (`/dev/memx0`)
> - **Generates a "Badminton AI Demo" desktop icon on your Ubuntu desktop**

### Step 3: Launch the Customer Demo
You have two simple ways to launch:
- **Option A (Recommended)**: Double-click the **Badminton AI Demo** icon on your Desktop.
- **Option B**: Run from terminal:
  ```bash
  ./run_demo.sh
  ```

---

## 4. How to Present to Customers (Demo Walkthrough)

Upon launch, the HUD startup configuration menu appears:

```text
+--------------------------------------------------------------+
|  BADMINTON AI EDGE ANALYTICS — STARTUP MENU                 |
+--------------------------------------------------------------+
| [●] Local Video File:  [ videos/Badminton_SinglePlay_20s.mp4 ] [Browse]
| [ ] USB Live Camera:   [ /dev/video0 - USB 1080P Camera      ] [Refresh]
|                                                              |
| Match Mode:    (●) Singles 1v1   ( ) Doubles 2v2   ( ) Auto   |
| Camera View:   (●) End Court     ( ) Side View     ( ) Auto   |
| Run Duration:  [0.0] sec (0 = full match)  [10s] [30s] [Full] |
| Record Video:  [0] (0 = disable disk recording, or enter name)|
|                                                              |
|                  [ ★ START LIVE ANALYTICS ★ ]                |
+--------------------------------------------------------------+
```

### Recommended Presentation Steps:
1. **Pre-recorded Demonstration**:
   - The default selection is `videos/Badminton_SinglePlay_20s.mp4`.
   - Click the green button **"★ START LIVE ANALYTICS ★"**.
   - The system immediately displays the 1080p full-screen analysis with 2D court mini-map and 3 tactical cards.
2. **Live USB Camera Demonstration**:
   - Choose **"USB Live Camera"**, select your camera device node (`/dev/video0`).
   - Click **"START LIVE ANALYTICS"** for real-time person tracking.
3. **Keyboard Controls**:
   - Press **`q`** or **`ESC`**: Exit current playback and safely return to the startup menu.
   - Press **`f`**: Toggle fullscreen mode.

---

## 5. Non-Engineer Troubleshooting & Debug Guide

If you encounter any issues during setup or demonstration, follow this step-by-step checklist:

### Issue 1: Desktop icon does not open or terminal shows `Cannot connect to X server :0`
- **Cause**: X11 display environment variable is missing.
- **Fix**:
  1. Ensure the HDMI cable is firmly connected and the Ubuntu desktop is active.
  2. In Terminal, run:
     ```bash
     export DISPLAY=:0
     xhost +local:
     ./run_demo.sh
     ```

### Issue 2: `MemryX NPU device /dev/memx0 not found` or Permission Denied
- **Cause**: M.2 card loose, PCIe driver not loaded, or user lacks read/write permissions.
- **Fix**:
  1. Check device existence:
     ```bash
     ls -l /dev/memx*
     ```
  2. Grant permissions:
     ```bash
     sudo chmod 666 /dev/memx*
     sudo usermod -a -G plugdev $USER
     ```
  3. If no `/dev/memx*` node appears, turn off power, reseat the M.2 card, and verify MemryX Linux driver installation.

### Issue 3: USB Camera is laggy (only 5 FPS)
- **Cause**: USB cameras default to uncompressed `YUYV` in 1080p, exceeding USB 2.0 bandwidth limit.
- **Fix**:
  - The pipeline automatically requests hardware `MJPG` dual-buffered streaming. Verify your camera supports MJPG:
    ```bash
    v4l2-ctl -d /dev/video0 --list-formats-ext
    ```
  - Plug camera into the blue **USB 3.0** port on RK3588.

### Issue 4: Desktop icon prompt says "Untrusted Application Launcher"
- **Cause**: Ubuntu GNOME security requirement for newly created `.desktop` files.
- **Fix**:
  - Right-click the desktop shortcut and click **"Allow Launching"**. The icon will change to the Badminton AI logo.

### Issue 5: "Failed to load compiled badminton_core module"
- **Cause**: Missing Python 3.10 runtime or C++ dependencies.
- **Fix**:
  - Re-run the installation script:
    ```bash
    ./install.sh
    ```
  - Verify `python3 --version` outputs `Python 3.10.x` on `aarch64`.

---

## 6. Directory Structure

```text
badminton-ai-edge/
├── README.md                                        # English Documentation (This file)
├── README_zh-TW.md                                  # Traditional Chinese Documentation
├── README_zh-CN.md                                  # Simplified Chinese Documentation
├── install.sh                                       # One-click installer & desktop shortcut wizard
├── run_demo.sh                                      # One-click demo launcher script
├── main.py                                          # Launcher entrypoint
├── badminton_core.cpython-310-aarch64-linux-gnu.so  # Compiled ARM64 native binary (source protected)
├── set_performance.sh                               # RK3588 performance governor script
├── assets/
│   └── badminton_icon.png                           # Desktop launcher icon
├── models/
│   ├── YOLO_v8_medium_pose_640_640_3_onnx.dfp       # MemryX MX3 DFP neural network model
│   └── YOLO_v8_medium_pose_640_640_3_onnx_post.onnx # Post-processing ONNX model
└── videos/
    ├── Badminton_SinglePlay_20s.mp4                 # 20-second sample match video
    └── SinglePlayers_20s.mp4                        # 20-second sample match video
```

---

## 7. License & Intellectual Property Notice

The core algorithms and pipeline acceleration routines in this repository are compiled into native ARM64 machine binaries. Unauthorized reverse engineering, decompilation, or redistribution is strictly prohibited.
For licensing and commercial inquiries, please contact the maintainer.
