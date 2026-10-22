# 羽球 AI 即時影像分析與戰術儀表板系統 (Badminton Edge AI Analytics)

[English](README.md) | [繁體中文](README_zh-TW.md) | [简体中文](README_zh-CN.md)

[![Hardware](https://img.shields.io/badge/Hardware-Rockchip%20RK3588-blue.svg)](https://en.wikipedia.org/wiki/Rockchip)
[![NPU](https://img.shields.io/badge/NPU-MemryX%20MX3%20M.2-green.svg)](https://memryx.com)
[![Display](https://img.shields.io/badge/Output-HDMI%201080p60%20Zero--Tear-orange.svg)]()
[![Pipeline](https://img.shields.io/badge/Inference-30%20FPS%20Realtime-red.svg)]()

本專案為專為 **Firefly RK3588 邊緣運算板** 與 **MemryX MX3 M.2 AI 加速卡** 打造的高效能羽球即時影像分析系統。系統透過零複製（Zero-Copy）共享記憶體架構與非同步雙緩衝串流，實現 **1080p 60Hz HDMI 滿版原生輸出** 與 **30 FPS 即時姿態推論**，專為非工程背景的業務與展示人員設計，3 步驟即可完成安裝並向客戶流暢展示。

---

## 一、 核心亮點與客戶展示價值

1. **極致流暢展示**：MemryX MX3 NPU 硬體非同步推論，不佔用 ARM CPU 運算資源，維持 30 FPS 實時幀率與 HDMI 60Hz 零撕裂畫面。
2. **單打 / 雙打自適應切換**：
   - **單打模式 (1v1)**：鎖定遠端 (P1) 與近端 (P2) 選手，排除裁判高腳椅與看台觀眾。
   - **雙打模式 (2v2)**：鎖定雙方 4 名球員，精準區分前場與後場站位。
3. **國際標準 BWF 2D 俯視戰術小地圖**：
   - 採用**雙腳踝接地接觸點 (Keypoints 15, 16)** 進行單應性 (Homography) 地面投影，消除跳殺跳起時的透視偏移。
   - 累計選手即時跑動熱區圖 (Heatmap)。
4. **底部三大即時戰術數據看板 (1440x270)**：
   - **卡片 1**：選手跑動瞬速 (km/h)、全場累計跑動距離 (m)、當前站位區、動態體能消耗進度條。
   - **卡片 2**：中央即時攻防對抗分析，動作辨識（起跳扣殺 Smash、網前撲球 Net Kill、平抽快擋 Drive 等）。
   - **卡片 3**：回合拉鋸拍數即時統計、對抗強度評級、戰術特徵判讀。
5. **內建示範影片**：已隨附高品質羽球賽事示範影片 (`videos/Badminton_SinglePlay_20s.mp4`)，無須額外下載。

---

## 二、 硬體與環境需求

| 項目 | 規格需求 | 備註 |
| :--- | :--- | :--- |
| **主板** | Firefly RK3588 (8-Core ARM64) | 4GB / 8GB / 16GB DDR4 均可 |
| **AI 加速卡** | MemryX MX3 M.2 Key-M PCIe | 需插入 M.2 插槽並載入驅動 (`/dev/memx0`) |
| **螢幕輸出** | HDMI 螢幕 (支援 1920x1080 @ 60Hz) | 連接主板 HDMI 輸出孔 |
| **作業系統** | Ubuntu Linux 20.04 / 22.04 LTS (ARM64) | 具備 X11 桌面環境 (`DISPLAY=:0`) |
| **攝影機 (選配)** | UVC USB 免驅動攝影機 | 支援 1080p 30FPS MJPG 模式 |

---

## 三、 非工程人員極速安裝指引 (3 步驟搞定)

如果您不是工程師，請打開 RK3588 桌面上的「終端機 (Terminal)」，依序複製貼上以下 3 個步驟：

### 步驟 1：下載專案 (Clone)
```bash
git clone https://github.com/ricola100g/badminton-ai-edge.git
cd badminton-ai-edge
```

### 步驟 2：執行一鍵環境安裝精靈
```bash
chmod +x install.sh
./install.sh
```
> 安裝精靈會全自動：
> - 檢查並補齊 Python 3.10 與 GUI 相依套件
> - 配置 MemryX NPU 裝置權限 (`/dev/memx0`)
> - **在 Ubuntu 桌面上自動建立「羽球 AI 即時分析系統」捷徑圖示**

### 步驟 3：啟動 Demo 展示
您有兩種方式可以啟動展示：
- **方式 A (推薦)**：直接在 Ubuntu 桌面上**雙擊「羽球 AI 即時分析系統 (Badminton AI Demo)」圖示**。
- **方式 B**：在終端機中執行：
  ```bash
  ./run_demo.sh
  ```

---

## 四、 向客戶展示之操作流程 (Demo Walkthrough)

當您啟動系統後，畫面上會彈出直覺的**深色運動 HUD 風格啟動選單**：

```text
+--------------------------------------------------------------+
|  BADMINTON AI EDGE ANALYTICS — STARTUP MENU                 |
+--------------------------------------------------------------+
| [●] 本機視訊檔案: [ videos/Badminton_SinglePlay_20s.mp4  ] [瀏覽]
| [ ] USB 實體攝影機: [ /dev/video0 - USB 1080P Camera     ] [重新整理]
|                                                              |
| 比賽模式: (●) 單打 1v1    ( ) 雙打 2v2    ( ) 自動辨識        |
| 攝影機視角: (●) 端線轉播視角 ( ) 側面邊線視角 ( ) 自動判斷     |
| 運行時長: [0.0] 秒 (0 代表完整播放) [10秒] [30秒] [全片]       |
| 視訊儲存: [0] (輸入 0 不佔用磁碟，輸入檔名則自動背景錄影)      |
|                                                              |
|                  [ ★ 開始即時智慧分析 ★ ]                    |
+--------------------------------------------------------------+
```

### 展示推薦設定：
1. **內建影片示範**：
   - 預設已選取 `videos/Badminton_SinglePlay_20s.mp4`。
   - 直接點擊最下方的綠色按鈕 **「★ 開始即時智慧分析 ★」**。
   - 畫面即會進入全螢幕 1080p HDMI 即時分析，右側呈現 2D 俯視小地圖，下方呈現三大動態卡片。
2. **實體 USB 攝影機示範**：
   - 選取「USB 實體攝影機」，下拉選擇攝影機節點（通常為 `/dev/video0` 或 `/dev/video1`）。
   - 點擊「開始即時智慧分析」，即刻進行全場選手偵測。
3. **快捷鍵控制**：
   - 按 **`q`** 或 **`ESC`**：退出當前分析，安全返回設定選單。
   - 按 **`f`**：切換全螢幕模式。

---

## 五、 常見問題與除錯指南 (Troubleshooting)

如果您在安裝或展示時遇到任何問題，請依照以下步驟逐一排查：

### 問題 1：點擊桌面圖示沒有反應，或終端機提示 `Cannot connect to X server :0`
- **原因**：系統未偵測到圖形桌面顯示環境變數。
- **解法**：
  1. 請確認 HDMI 線已接至螢幕，且螢幕已亮起進入 Ubuntu 桌面。
  2. 在終端機執行：
     ```bash
     export DISPLAY=:0
     xhost +local:
     ./run_demo.sh
     ```

### 問題 2：提示找不到 MemryX NPU 裝置 (`/dev/memx0 not found`) 或權限不足
- **原因**：MemryX M.2 卡未插緊、PCIe 驅動未載入，或當前使用者缺少權限。
- **解法**：
  1. 檢查硬體節點：
     ```bash
     ls -l /dev/memx*
     ```
  2. 若檔案存在但無法讀寫，執行以下指令開放權限：
     ```bash
     sudo chmod 666 /dev/memx*
     sudo usermod -a -G plugdev $USER
     ```
  3. 若 `ls /dev/memx*` 完全沒有顯示任何節點，請關機重新插拔 M.2 卡，並確認已安裝 MemryX 官方驅動程式。

### 問題 3：使用 USB 攝影機時畫面卡頓，幀率只有 5 FPS
- **原因**：USB 攝影機在 1080p 預設採用未壓縮的 YUYV 格式，受限於 USB 2.0 頻寬硬體上限。
- **解法**：
  - 本系統已內建自動協商硬體 MJPG 雙緩衝機制。請確認您的 USB 攝影機支援 MJPG 格式：
    ```bash
    v4l2-ctl -d /dev/video0 --list-formats-ext
    ```
  - 確保攝影機插入 RK3588 藍色的 **USB 3.0** 插槽，避免插在黑色 USB 2.0 造成供電或頻寬不足。

### 問題 4：桌面圖示雙擊後提示「Untrusted Application Launcher」
- **原因**：Ubuntu GNOME 安全機制預設要求使用者手動允許執行。
- **解法**：
  - 在桌面上的圖示上按滑鼠右鍵，選擇 **「Allow Launching (允許啟動)」**，圖示即會變為羽球圖案，之後即可直接雙擊啟動。

### 問題 5：提示「Failed to load compiled badminton_core module」
- **原因**：缺少 Python 3.10 或必要的 C++ 執行期共享庫。
- **解法**：
  - 請重新執行一次安裝精靈：
    ```bash
    ./install.sh
    ```
  - 確認 `python3 --version` 為 `Python 3.10.x`，硬體架構為 `aarch64`。

---

## 六、 專案目錄結構

```text
badminton-ai-edge/
├── README.md                                        # 英文使用說明
├── README_zh-TW.md                                  # 繁體中文使用說明 (本文件)
├── README_zh-CN.md                                  # 簡體中文使用說明
├── install.sh                                       # 一鍵安裝與桌面圖示配置精靈
├── run_demo.sh                                      # 一鍵啟動展示腳本
├── main.py                                          # 啟動載入器
├── badminton_core.cpython-310-aarch64-linux-gnu.so  # 核心演算法原生編譯二進位動態庫 (不含明文源碼)
├── set_performance.sh                               # RK3588 高效能模式設定腳本
├── assets/
│   └── badminton_icon.png                           # 系統桌面圖示
├── models/
│   ├── YOLO_v8_medium_pose_640_640_3_onnx.dfp       # MemryX MX3 NPU 姿態推論神經網路
│   └── YOLO_v8_medium_pose_640_640_3_onnx_post.onnx # 後處理 ONNX 模型
└── videos/
    ├── Badminton_SinglePlay_20s.mp4                 # 20 秒單打精選示範影片
    └── SinglePlayers_20s.mp4                        # 20 秒單打示範短片
```

---

## 七、 授權與智慧財產權聲明

本專案之核心演算法與神經網路部署管線已編譯為原生 ARM64 機器碼動態庫，未經授權禁止反編譯、逆向工程或未授權散布。
如有商務合作或技術支援需求，請聯繫專案維護人員。
