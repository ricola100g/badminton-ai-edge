#!/bin/bash
set -e
echo "Setting CPU governor to performance..."
for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance | sudo tee "$g" >/dev/null
done

echo "Setting DDR/NPU/GPU/VENC to performance..."
[ -f /sys/class/devfreq/dmc/governor ] && echo performance | sudo tee /sys/class/devfreq/dmc/governor >/dev/null
[ -f /sys/class/devfreq/fdab0000.npu/governor ] && echo performance | sudo tee /sys/class/devfreq/fdab0000.npu/governor >/dev/null
[ -f /sys/class/devfreq/fb000000.gpu/governor ] && echo performance | sudo tee /sys/class/devfreq/fb000000.gpu/governor >/dev/null

echo "Current CPU Frequencies:"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq
echo "Done!"
