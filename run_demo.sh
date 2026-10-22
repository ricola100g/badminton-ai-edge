#!/usr/bin/env bash
# =============================================================================
# Badminton AI Edge Demo Runner Script
# Hardware: Firefly RK3588 + MemryX MX3 M.2 AI Card
# =============================================================================

# Resolve current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Ensure X11 display is available for GUI / HDMI presentation
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi

# Allow local X11 access
if command -v xhost >/dev/null 2>&1; then
    xhost +local: >/dev/null 2>&1 || true
fi

# Kill any stale or lingering pipeline instances that could hold /dev/memx0
pkill -9 -f "run_badminton_pipeline.py" 2>/dev/null || true
pkill -9 -f "badminton-ai-edge/main.py" 2>/dev/null || true

# Clean up stale shared memory files
find /dev/shm -name "*badminton*" -delete 2>/dev/null || true
find /dev/shm -name "psm_*" -delete 2>/dev/null || true

# Check MemryX NPU device permission
if [ -e /dev/memx0 ]; then
    if [ ! -r /dev/memx0 ] || [ ! -w /dev/memx0 ]; then
        sudo chmod 666 /dev/memx0 2>/dev/null || true
    fi
fi

# Set CPU / NPU performance mode if available
if [ -f "$SCRIPT_DIR/set_performance.sh" ]; then
    bash "$SCRIPT_DIR/set_performance.sh" 2>/dev/null || true
fi

# Run python pipeline with logging
LOG_FILE="/tmp/badminton_run.log"
echo "[啟動中] 載入原生編譯核心引擎..."
python3 "$SCRIPT_DIR/main.py" "$@" > "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ] && [ $EXIT_CODE -ne 130 ]; then
    if command -v zenity >/dev/null 2>&1 && [ -n "$DISPLAY" ]; then
        zenity --error --title="羽球 AI 系統提示" --text="程式異常結束 (結束碼: $EXIT_CODE)\n\n日誌摘要:\n$(tail -n 12 "$LOG_FILE")" --width=500 2>/dev/null || true
    fi
fi

exit $EXIT_CODE
