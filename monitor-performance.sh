#!/bin/bash

# Real-time Performance Monitor for LMStudio Testing
# Runs in background and logs CPU, GPU, memory, and thermal data
# Usage: bash monitor-performance.sh &
# Stop with: kill %1 or pkill -f monitor-performance

set -euo pipefail

# Configuration
BENCHMARK_DIR="${HOME}/.lmstudio-benchmarks"
RESULTS_DIR="${BENCHMARK_DIR}/results"
MODE="${1:-baseline}"
MONITOR_DIR="${RESULTS_DIR}/${MODE}"
INTERVAL=2  # seconds between measurements

# Create output files
OUTPUT_CSV="${MONITOR_DIR}/system-monitor-$(date +%s).csv"
mkdir -p "${MONITOR_DIR}"

echo "Performance Monitor started"
echo "Logging to: ${OUTPUT_CSV}"
echo "Press Ctrl+C to stop"

# Write CSV header
{
    echo "timestamp,cpu_usage_percent,cpu_temp_c,memory_used_mb,memory_available_mb,memory_usage_percent"
} > "${OUTPUT_CSV}"

# Check for GPU monitoring
HAS_NVIDIA=false
HAS_AMD=false
if command -v nvidia-smi &> /dev/null; then
    HAS_NVIDIA=true
    echo "timestamp,cpu_usage_percent,cpu_temp_c,memory_used_mb,memory_available_mb,memory_usage_percent,gpu_usage_percent,gpu_memory_mb,gpu_temp_c" > "${OUTPUT_CSV}"
elif command -v rocm-smi &> /dev/null; then
    HAS_AMD=true
    echo "timestamp,cpu_usage_percent,cpu_temp_c,memory_used_mb,memory_available_mb,memory_usage_percent,gpu_usage_percent,gpu_memory_mb,gpu_temp_c" > "${OUTPUT_CSV}"
fi

# Monitoring loop
while true; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # CPU usage (last second)
    read cpu_user cpu_nice cpu_system cpu_idle cpu_iowait <<< \
        $(awk '/^cpu / {print $2, $3, $4, $5, $6}' /proc/stat)

    cpu_total=$((cpu_user + cpu_nice + cpu_system + cpu_idle + cpu_iowait))
    cpu_usage=$(echo "scale=1; 100 * (${cpu_user} + ${cpu_nice} + ${cpu_system}) / ${cpu_total}" | bc 2>/dev/null || echo "N/A")

    # CPU temperature
    cpu_temp="N/A"
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        cpu_temp_raw=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo "0")
        cpu_temp=$(echo "scale=1; ${cpu_temp_raw} / 1000" | bc)
    fi

    # Memory usage
    read mem_total mem_used <<< $(free -b | awk 'NR==2 {print $2, $3}')
    mem_available=$((mem_total - mem_used))
    mem_used_mb=$((mem_used / 1024 / 1024))
    mem_available_mb=$((mem_available / 1024 / 1024))
    mem_usage=$(echo "scale=1; 100 * ${mem_used} / ${mem_total}" | bc)

    # Build output line
    output="${timestamp},${cpu_usage},${cpu_temp},${mem_used_mb},${mem_available_mb},${mem_usage}"

    # Add GPU metrics if available
    if [ "${HAS_NVIDIA}" = true ]; then
        gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1 || echo "N/A")
        gpu_memory=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null | head -1 || echo "N/A")
        gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -1 || echo "N/A")
        output="${output},${gpu_usage},${gpu_memory},${gpu_temp}"
    elif [ "${HAS_AMD}" = true ]; then
        gpu_usage=$(rocm-smi --json 2>/dev/null | grep -o '"gpu_usage": [0-9]*' | head -1 | grep -o '[0-9]*' || echo "N/A")
        gpu_memory=$(rocm-smi --json 2>/dev/null | grep -o '"sclk": "[^"]*"' | head -1 | sed 's/"sclk": "\([^"]*\)"/\1/' || echo "N/A")
        gpu_temp=$(rocm-smi --json 2>/dev/null | grep -o '"temperature": [0-9]*' | head -1 | grep -o '[0-9]*' || echo "N/A")
        output="${output},${gpu_usage},${gpu_memory},${gpu_temp}"
    fi

    # Append to CSV
    echo "${output}" >> "${OUTPUT_CSV}"

    # Display in terminal (overwrite previous line)
    printf "\r[%s] CPU: %s%% | Temp: %s°C | RAM: %sMB/%sMB" \
        "${timestamp}" "${cpu_usage}" "${cpu_temp}" "${mem_used_mb}" "$(( (mem_total / 1024 / 1024) ))"

    # Sleep for interval
    sleep "${INTERVAL}"
done
