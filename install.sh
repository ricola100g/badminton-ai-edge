#!/usr/bin/env bash
# =============================================================================
# Badminton AI Edge One-Click Installation & Setup Script
# Target Hardware: ProAI88 (ARM64) + MemryX MX3 M.2 AI Card
# Target OS: Ubuntu 20.04 / 22.04 LTS (aarch64)
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo "~$CURRENT_USER")

echo -e "${BLUE}==================================================================${NC}"
echo -e "${GREEN}   羽球 AI 即時影像分析與戰術儀表板系統 — 一鍵環境配置精靈${NC}"
echo -e "${GREEN}   Badminton AI Edge One-Click Environment Setup Wizard${NC}"
echo -e "${BLUE}==================================================================${NC}"
echo "安裝目錄 (Install Directory): $SCRIPT_DIR"
echo "執行使用者 (Target User):     $CURRENT_USER ($USER_HOME)"
echo ""

# 1. 檢查硬體架構
echo -e "${BLUE}[步驟 1/6] 檢查硬體架構 (Checking Hardware Architecture)...${NC}"
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
    echo -e "${RED}[錯誤 Error] 本系統專為 ARM64 (RK3588) 設計，偵測到非相容架構: $ARCH${NC}"
    exit 1
fi
echo -e "  ✓ 硬體架構符合: $ARCH (Rockchip RK3588)"

# 2. 檢查 Python 版本
echo -e "${BLUE}[步驟 2/6] 檢查 Python 環境 (Checking Python Version)...${NC}"
if ! command -v python3 >/dev/null 2>&1; then
    echo -e "${YELLOW}  正在安裝 Python3...${NC}"
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
fi
PY_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo -e "  ✓ 偵測到 Python 版本: $PY_VER"

# 3. 安裝系統相依函式庫 (APT Packages)
echo -e "${BLUE}[步驟 3/6] 安裝系統級多媒體與 GUI 相依庫 (Installing System Libraries)...${NC}"
sudo apt-get update -qq
sudo apt-get install -y -qq \
    python3-tk \
    python3-pil \
    python3-pil.imagetk \
    v4l-utils \
    libgl1 \
    libglib2.0-0 \
    fonts-noto-cjk \
    libdrm2 \
    mesa-utils >/dev/null 2>&1 || true
echo -e "  ✓ 系統多媒體與中文字型套件已安裝就緒"

# 4. 安裝 Python 相依套件 (Pip Dependencies)
echo -e "${BLUE}[步驟 4/6] 檢查並安裝 Python 相依套件 (Installing Python Packages)...${NC}"
pip3 install --quiet --upgrade pip setuptools wheel 2>/dev/null || true
# 注意: MemryX SDK 目前相依於 NumPy 1.x 系列 (如 numpy==1.26.4)，不可升級為 NumPy 2.x
pip3 install --quiet "numpy<2" "pillow" "scipy" 2>/dev/null || true

# 檢查 memryx 套件
if python3 -c "import memryx" >/dev/null 2>&1; then
    echo -e "  ✓ MemryX Python SDK (memryx.AsyncAccl): 已安裝"
else
    echo -e "${YELLOW}  [提醒] 尚未偵測到 memryx Python 套件。若您尚未安裝 MemryX 驅動與 SDK，請造訪 https://developer.memryx.com 進行安裝。${NC}"
fi

# 5. 配置 MemryX NPU udev 規則與使用者權限
echo -e "${BLUE}[步驟 5/6] 設定 MemryX NPU 裝置權限與 udev 規則 (Configuring NPU Permissions)...${NC}"
UDEV_RULE_FILE="/etc/udev/rules.d/99-memryx.rules"
if [ ! -f "$UDEV_RULE_FILE" ]; then
    echo 'KERNEL=="memx[0-9]*", MODE="0666", GROUP="plugdev"' | sudo tee "$UDEV_RULE_FILE" >/dev/null
    sudo udevadm control --reload-rules 2>/dev/null || true
    sudo udevadm trigger 2>/dev/null || true
    echo -e "  ✓ 已建立 udev 規則: $UDEV_RULE_FILE (開放 /dev/memx* 讀寫)"
fi

# 確保當前使用者屬於 video 與 plugdev 群組
sudo usermod -a -G video "$CURRENT_USER" 2>/dev/null || true
sudo usermod -a -G plugdev "$CURRENT_USER" 2>/dev/null || true

if [ -e /dev/memx0 ]; then
    sudo chmod 666 /dev/memx0 2>/dev/null || true
    echo -e "  ✓ MemryX NPU 裝置節點 /dev/memx0 讀寫權限已開放"
fi

# 6. 建立桌面捷徑 (Desktop Icon)
echo -e "${BLUE}[步驟 6/6] 建立桌面啟動圖示 (Creating Desktop Shortcut)...${NC}"
DESKTOP_DIR="$USER_HOME/Desktop"
if [ ! -d "$DESKTOP_DIR" ]; then
    DESKTOP_DIR="$USER_HOME/桌面"
fi

mkdir -p "$DESKTOP_DIR" 2>/dev/null || true

SHORTCUT_FILE="$DESKTOP_DIR/Badminton_AI_Demo.desktop"
cat << EOF > "$SHORTCUT_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Badminton AI Demo
Name[zh_TW]=羽球 AI 即時分析系統
Name[zh_CN]=羽毛球 AI 实时分析系统
Comment=Edge AI Real-Time Badminton Video Analytics
Exec=/bin/bash "$SCRIPT_DIR/run_demo.sh"
Icon=$SCRIPT_DIR/assets/badminton_icon.png
Path=$SCRIPT_DIR
Terminal=false
Categories=AudioVideo;Video;Player;
StartupNotify=true
EOF

chmod +x "$SHORTCUT_FILE"
chown "$CURRENT_USER:$CURRENT_USER" "$SHORTCUT_FILE" 2>/dev/null || true

# 啟用 GNOME 信任捷徑 (避免彈出 Untrusted Application 提示)
if command -v gio >/dev/null 2>&1; then
    gio set "$SHORTCUT_FILE" metadata::trusted true 2>/dev/null || true
fi

# 檔案權限設定
chmod +x "$SCRIPT_DIR/run_demo.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/main.py" 2>/dev/null || true
if [ -f "$SCRIPT_DIR/set_performance.sh" ]; then
    chmod +x "$SCRIPT_DIR/set_performance.sh" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}==================================================================${NC}"
echo -e "${GREEN}  ✓ 安裝與環境配置完成！(Installation Complete!)${NC}"
echo -e "${GREEN}==================================================================${NC}"
echo -e "1. 桌面快捷圖示已建立： ${YELLOW}$SHORTCUT_FILE${NC}"
echo -e "   -> 您可直接在桌面雙擊此圖示啟動 Demo！"
echo ""
echo -e "2. 或在終端機輸入指令啟動："
echo -e "   ${BLUE}cd \"$SCRIPT_DIR\" && ./run_demo.sh${NC}"
echo -e "${GREEN}==================================================================${NC}"
