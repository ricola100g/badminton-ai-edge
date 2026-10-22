#!/usr/bin/env bash
# =============================================================================
# Badminton AI Edge Demo Runner Script
# Hardware: Firefly RK3588 + MemryX MX3 M.2 AI Card
# =============================================================================

set -e

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

echo "=================================================================="
echo "  羽球 AI 即時影像分析與戰術儀表板系統 (Demo Runner)"
echo "  Badminton Edge AI Real-Time Analytics System"
echo "=================================================================="

# Check Python environment
if ! command -v python3 >/dev/null 2>&1; then
    echo "[錯誤 Error] 未安裝 python3，請先執行 ./install.sh"
    exit 1
fi

# Check MemryX NPU device
if [ -e /dev/memx0 ]; then
    if [ ! -r /dev/memx0 ] || [ ! -w /dev/memx0 ]; then
        echo "[提示 Warning] 偵測到 /dev/memx0 但目前使用者缺少讀寫權限。"
        echo "正在嘗試調整權限 (需密碼)..."
        sudo chmod 666 /dev/memx0 2>/dev/null || true
    fi
    echo "[硬體狀態] MemryX MX3 NPU (/dev/memx0): 已連線並就緒 ✓"
else
    echo "[硬體警告] 未發現 /dev/memx0，請確認 MemryX M.2 卡已插妥且驅動已載入。"
fi

# Set CPU / NPU performance mode if possible (optional, won't fail if no sudo)
if [ -f "$SCRIPT_DIR/set_performance.sh" ]; then
    bash "$SCRIPT_DIR/set_performance.sh" 2>/dev/null || true
fi

# Clean up stale shared memory or lingering instances
cleanup_stale() {
    # Remove lingering shm files matching badminton
    find /dev/shm -name "*badminton*" -delete 2>/dev/null || true
}
cleanup_stale

echo "[啟動中] 載入原生編譯核心引擎..."
python3 "$SCRIPT_DIR/main.py" "$@"
