# 羽毛球 AI 实时影像分析与战术仪表板系统 (Badminton Edge AI Analytics)

[English](README.md) | [繁體中文](README_zh-TW.md) | [简体中文](README_zh-CN.md)

[![Hardware](https://img.shields.io/badge/Hardware-ProAI88-blue.svg)](https://en.wikipedia.org/wiki/Rockchip)
[![NPU](https://img.shields.io/badge/NPU-MemryX%20MX3%20M.2-green.svg)](https://memryx.com)
[![Display](https://img.shields.io/badge/Output-HDMI%201080p60%20Zero--Tear-orange.svg)]()
[![Pipeline](https://img.shields.io/badge/Inference-30%20FPS%20Realtime-red.svg)]()

本项目为专为 **ProAI88 边缘计算板** 与 **MemryX MX3 M.2 AI 加速卡** 打造的高性能羽毛球实时影像分析系统，实现 **1080p 60Hz HDMI 满版原生输出** 与 **30 FPS 实时姿态推断**，专为非工程背景的业务与展示人员设计，3 步骤即可完成安装并向客户流畅演示。

---

## 一、 核心亮点与客户演示价值

1. **极致流畅演示**：MemryX MX3 NPU 硬件异步推断，不占用 ARM CPU 计算资源，稳定保持 30 FPS 实时帧率与 HDMI 60Hz 画面。
2. **单打 / 双打自适应切换**：
   - **单打模式 (1v1)**：锁定远端 (P1) 与近端 (P2) 选手，自动排除裁判高脚椅与看台观众。
   - **双打模式 (2v2)**：同时追踪 4 名球员，精准区分前场与后场站位。
3. **国际标准 BWF 2D 俯视战术小地图**：
   - 采用**双脚踝触地点 (Keypoints 15, 16)** 进行单应性 (Homography) 地面投影，消除跳杀跳起时的透视偏移。
   - 累计选手实时跑动热区图 (Heatmap)。
4. **底部三大实时战术数据看板 (1440x270)**：
   - **卡片 1**：选手跑动瞬速 (km/h)、全场累计跑动距离 (m)、当前站位区、动态体能消耗进度条。
   - **卡片 2**：中央实时攻防对抗分析，动作识别（起跳扣杀 Smash、网前扑球 Net Kill、平抽快挡 Drive 等）。
   - **卡片 3**：回合对拉拍数实时统计、对抗强度评级、战术特征判读。
5. **内置演示视频**：已附带高质量羽毛球国际赛事精选演示视频 (`videos/test2.mp4`)，无需额外下载。

---

## 二、 硬件与环境需求

| 项目 | 规格需求 | 备注 |
| :--- | :--- | :--- |
| **主板** | ProAI88 (8-Core ARM64) | 4GB / 8GB / 16GB DDR4 均兼容 |
| **AI 加速卡** | MemryX MX3 M.2 Key-M PCIe | 插入 M.2 插槽并加载驱动 (`/dev/memx0`) |
| **屏幕输出** | HDMI 显示器 (支持 1920x1080 @ 60Hz) | 连接主板 HDMI 输出口 |
| **操作系统** | Ubuntu Linux 20.04 / 22.04 LTS (ARM64) | 具备 X11 桌面环境 (`DISPLAY=:0`) |
| **摄像头 (选配)** | UVC USB 免驱摄像头 | 支持 1080p 30FPS MJPG 模式 |

---

## 三、 非工程人员极速安装指引 (3 步骤搞定)

如果您不是工程师，请打开 ProAI88 桌面上的“终端 (Terminal)”，依序复制粘贴以下 3 个步骤：

### 步骤 1：下载项目 (Clone)
```bash
git clone https://github.com/ricola100g/badminton-ai-edge.git
cd badminton-ai-edge
```

### 步骤 2：执行一键环境安装向导
```bash
chmod +x install.sh
./install.sh
```
> 安装向导将全自动：
> - 检查并补齐 Python 3.10 与 GUI 依赖库
> - 配置 MemryX NPU 设备权限 (`/dev/memx0`)
> - **在 Ubuntu 桌面上自动创建“羽球 AI 实时分析系统”快捷图标**

### 步骤 3：启动演示
您可以通过两种方式启动展示：
- **方式 A (推荐)**：直接在 Ubuntu 桌面上**双击“羽球 AI 实时分析系统 (Badminton AI Demo)”图标**。
- **方式 B**：在终端机中运行：
  ```bash
  ./run_demo.sh
  ```

---

## 四、 向客户演示之操作流程 (Demo Walkthrough)

启动系统后，画面将弹出直观的**深色运动 HUD 风格启动配置菜单**：

```text
+--------------------------------------------------------------+
|  BADMINTON AI EDGE ANALYTICS — STARTUP MENU                 |
+--------------------------------------------------------------+
| [●] 本地视频文件: [ videos/test2.mp4                     ] [浏览]
| [ ] USB 实时摄像头: [ /dev/video0 - USB 1080P Camera     ] [刷新]
|                                                              |
| 比赛模式: (●) 单打 1v1    ( ) 双打 2v2    ( ) 自动识别        |
| 视角类型: (●) 端线转播视角 ( ) 侧面边线视角 ( ) 自动判断     |
| 运行周期: [0.0] 秒 (0 代表完整播放) [10秒] [30秒] [全片]       |
| 视频存储: [0] (输入 0 不占用磁盘，输入文件名则自动后台录像)    |
|                                                              |
|                  [ ★ 开始实时智能分析 ★ ]                    |
+--------------------------------------------------------------+
```

### 演示推荐操作：
1. **内置视频演示**：
   - 默认已选中 `videos/test2.mp4`。
   - 直接点击最下方绿色按钮 **“★ 开始实时智能分析 ★”**。
   - 画面即进入全屏 1080p HDMI 实时分析，右侧呈现 2D 俯视小地图，下方呈现三大动态卡片。
2. **USB 摄像头现场演示**：
   - 选择“USB 实时摄像头”，下拉选择摄像头设备节点（通常为 `/dev/video0`）。
   - 点击“开始实时智能分析”，即刻进行全场选手追踪与骨架绘制。
3. **快捷键操作**：
   - 按 **`q`** 或 **`ESC`**：退出当前分析，安全返回配置菜单。
   - 按 **`f`**：切换全屏模式。

---

## 五、 常见问题与排错指南 (Troubleshooting)

如果在安装或演示过程中遇到问题，请按照以下步骤排查：

### 问题 1：双击桌面图标没有反应，或终端提示 `Cannot connect to X server :0`
- **原因**：系统未找到图形桌面显示环境变量。
- **排查与解决**：
  1. 确认 HDMI 信号线已连接显示器，且已进入桌面。
  2. 在终端运行：
     ```bash
     export DISPLAY=:0
     xhost +local:
     ./run_demo.sh
     ```

### 问题 2：提示找不到 MemryX NPU 设备 (`/dev/memx0 not found`) 或权限不足
- **原因**：MemryX M.2 卡未插紧、PCIe 驱动未加载，或当前用户缺乏读写权限。
- **排查与解决**：
  1. 检查硬件节点：
     ```bash
     ls -l /dev/memx*
     ```
  2. 开放读写权限：
     ```bash
     sudo chmod 666 /dev/memx*
     sudo usermod -a -G plugdev $USER
     ```
  3. 若 `ls /dev/memx*` 完全无节点显示，请关机重新插拔 M.2 卡并确认驱动安装。

### 问题 3：使用 USB 摄像头时画面卡顿，帧率仅 5 FPS
- **原因**：USB 摄像头在 1080p 分辨率下默认协商为未压缩 YUYV 格式，受 USB 2.0 带宽限制。
- **排查与解决**：
  - 系统已内置自动协商硬件 MJPG 格式双缓冲机制。请确认摄像头支持 MJPG：
    ```bash
    v4l2-ctl -d /dev/video0 --list-formats-ext
    ```
  - 将摄像头插入 ProAI88 板载蓝色的 **USB 3.0** 插口。

### 问题 4：桌面图标双击后提示“Untrusted Application Launcher”
- **原因**：Ubuntu GNOME 桌面环境对新创建的快捷方式默认需要一次性授权。
- **排查与解决**：
  - 在桌面的快捷图标上点击鼠标右键，选择 **“Allow Launching (允许启动)”**，图标将恢复为羽毛球图案，之后即可双击运行。

### 问题 5：提示“Failed to load compiled badminton_core module”
- **原因**：缺少 Python 3.10 或 C++ 运行时共享库。
- **排查与解决**：
  - 重新执行一键安装脚本：
    ```bash
    ./install.sh
    ```
  - 确认 `python3 --version` 为 `Python 3.10.x`，硬件架构为 `aarch64`。

---

## 六、 项目目录结构

```text
badminton-ai-edge/
├── README.md                                        # 英文使用说明
├── README_zh-TW.md                                  # 繁体中文使用说明
├── README_zh-CN.md                                  # 简体中文使用说明 (本文件)
├── install.sh                                       # 一键安装与桌面图标配置向导
├── run_demo.sh                                      # 一键启动演示脚本
├── main.py                                          # 启动加载器
├── badminton_core.cpython-310-aarch64-linux-gnu.so  # 核心算法原生编译二进制动态库 (无源码泄露)
├── set_performance.sh                               # ProAI88 高性能模式调节脚本
├── assets/
│   └── badminton_icon.png                           # 系统桌面图标
├── models/
│   ├── YOLO_v8_medium_pose_640_640_3_onnx.dfp       # MemryX MX3 NPU 姿态推断神经网络
│   └── YOLO_v8_medium_pose_640_640_3_onnx_post.onnx # 后处理 ONNX 模型
└── videos/
    ├── test2.mp4                                    # 男子单打演示视频 (默认)
    ├── Badminton_SinglePlay_20s.mp4                 # 20 秒单打精选演示短片
    └── SinglePlayers_20s.mp4                        # 20 秒单打演示短片
```

---

## 七、 授权与知识产权声明

本项目之核心算法与神经网络部署管线已全量编译为原生 ARM64 机器码动态库，未经授权严禁反编译、逆向工程或非授权二次分发。
商业合作与技术支持，请联系项目维护人员。
