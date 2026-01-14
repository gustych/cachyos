#!/bin/bash

# LMStudio Benchmarking Suite
# Tests LMStudio performance in normal vs overclocking mode
# Usage: bash lmstudio-benchmark.sh [mode]
# Modes: baseline, overclocked, both (default: baseline)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BENCHMARK_DIR="${HOME}/.lmstudio-benchmarks"
RESULTS_DIR="${BENCHMARK_DIR}/results"
LMSTUDIO_URL="http://localhost:1234/v1"
LMSTUDIO_PORT=1234
MODE="${1:-baseline}"

# Test configuration
SPEED_TEST_TIMEOUT=120
QUALITY_TEST_TIMEOUT=300
THERMAL_TEST_DURATION=600  # 10 minutes

# Create directories
mkdir -p "${RESULTS_DIR}/baseline" "${RESULTS_DIR}/overclocked" "${BENCHMARK_DIR}/logs"

# Logging
LOG_FILE="${BENCHMARK_DIR}/logs/benchmark-$(date +%Y%m%d-%H%M%S).log"
exec 1> >(tee -a "${LOG_FILE}")
exec 2>&1

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."

    local missing=()

    # Core requirements
    for cmd in curl jq; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    # Optional but recommended
    if ! command -v nvidia-smi &> /dev/null && ! command -v rocm-smi &> /dev/null; then
        log_warning "GPU monitoring tools not found (nvidia-smi or rocm-smi)"
    fi

    if ! command -v python3 &> /dev/null; then
        log_warning "Python3 not found - some analysis features will be limited"
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing[*]}"
        log_info "Install with: sudo pacman -S ${missing[*]}"
        return 1
    fi

    log_success "All dependencies available"
    return 0
}

# Check LMStudio server
check_lmstudio() {
    log_info "Checking LMStudio server on port ${LMSTUDIO_PORT}..."

    if curl -s "${LMSTUDIO_URL}/models" > /dev/null 2>&1; then
        log_success "LMStudio server is running"
        return 0
    else
        log_error "LMStudio server not responding on ${LMSTUDIO_URL}"
        log_info "Start LMStudio and ensure server is running on port ${LMSTUDIO_PORT}"
        return 1
    fi
}

# Get available models
get_models() {
    curl -s "${LMSTUDIO_URL}/models" | jq -r '.data[].id' 2>/dev/null || {
        echo "ERROR" >&2
        return 1
    }
}

# System info collection
collect_system_info() {
    local mode=$1
    local output_dir="${RESULTS_DIR}/${mode}"
    local info_file="${output_dir}/system-info.txt"

    log_info "Collecting system information..."

    {
        echo "=== System Information ==="
        echo "Date: $(date)"
        echo "Hostname: $(hostname)"
        echo ""

        echo "=== CPU Info ==="
        lscpu | grep -E "Model name|Architecture|CPU\(s\)|Core\(s\)|Thread\(s\)"
        echo ""

        echo "=== Memory Info ==="
        free -h | head -3
        echo ""

        echo "=== GPU Info ==="
        if command -v nvidia-smi &> /dev/null; then
            nvidia-smi -L || echo "NVIDIA GPU not detected"
        elif command -v rocm-smi &> /dev/null; then
            rocm-smi || echo "AMD GPU not detected"
        else
            echo "No GPU monitoring tools found"
        fi
        echo ""

        echo "=== Kernel ==="
        uname -a
        echo ""

        echo "=== CachyOS Info ==="
        if [ -f /etc/os-release ]; then
            grep -E "NAME|VERSION|ID" /etc/os-release
        fi
    } | tee "${info_file}"
}

# Speed test function
run_speed_test() {
    local model=$1
    local mode=$2
    local output_dir="${RESULTS_DIR}/${mode}"
    local output_file="${output_dir}/speed-test-${model//\//-}.json"

    log_info "Running speed test for ${model} (${mode} mode)..."

    local prompt="Explain how neural networks work. Provide a detailed explanation covering: 1) Basic concepts and structure, 2) How training works, 3) Common architectures, 4) Real-world applications. Be thorough and educational."

    local start_time=$(date +%s.%N)

    # Make request to LMStudio (OpenAI-compatible chat format)
    local response=$(curl -s -X POST "${LMSTUDIO_URL}/chat/completions" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"${model}\",
            \"messages\": [{\"role\": \"user\", \"content\": \"${prompt}\"}],
            \"temperature\": 0.7,
            \"max_tokens\": 256,
            \"stream\": false
        }" \
        --max-time "${SPEED_TEST_TIMEOUT}" 2>/dev/null || echo "{\"error\": \"timeout\"}")

    local end_time=$(date +%s.%N)
    local total_time=$(echo "${end_time} - ${start_time}" | bc)

    # Parse response (chat format)
    local completion=$(echo "${response}" | jq -r '.choices[0].message.content // "ERROR"' 2>/dev/null || echo "ERROR")
    local tokens=$(echo "${response}" | jq -r '.usage.completion_tokens // 0' 2>/dev/null || echo "0")

    if [ "${completion}" != "ERROR" ] && [ "${tokens}" != "0" ]; then
        local throughput=$(echo "scale=2; ${tokens} / ${total_time}" | bc)

        {
            echo "{"
            echo "  \"model\": \"${model}\","
            echo "  \"mode\": \"${mode}\","
            echo "  \"timestamp\": \"$(date -Iseconds)\","
            echo "  \"total_time_seconds\": ${total_time},"
            echo "  \"tokens_generated\": ${tokens},"
            echo "  \"throughput_tokens_per_sec\": ${throughput},"
            echo "  \"first_token_latency_ms\": \"N/A\","
            echo "  \"success\": true"
            echo "}"
        } | tee "${output_file}"

        log_success "Speed test completed: ${throughput} tokens/sec"
    else
        log_error "Speed test failed for ${model}"
        {
            echo "{"
            echo "  \"model\": \"${model}\","
            echo "  \"mode\": \"${mode}\","
            echo "  \"success\": false,"
            echo "  \"error\": \"Test failed or timed out\""
            echo "}"
        } | tee "${output_file}"
        return 1
    fi
}

# Quality test function
run_quality_test() {
    local model=$1
    local mode=$2
    local output_dir="${RESULTS_DIR}/${mode}"
    local output_file="${output_dir}/quality-test-${model//\//-}.log"

    log_info "Running quality test for ${model} (${mode} mode)..."

    # Standard quality test prompts
    local prompts=(
        "What is 2+2?"
        "Explain machine learning in one sentence."
        "List three programming languages."
        "What is the capital of France?"
        "Explain photosynthesis briefly."
    )

    {
        echo "=== Quality Test Results ==="
        echo "Model: ${model}"
        echo "Mode: ${mode}"
        echo "Timestamp: $(date -Iseconds)"
        echo ""

        for i in "${!prompts[@]}"; do
            echo "--- Prompt $((i+1)) ---"
            echo "Question: ${prompts[$i]}"

            local response=$(curl -s -X POST "${LMSTUDIO_URL}/chat/completions" \
                -H "Content-Type: application/json" \
                -d "{
                    \"model\": \"${model}\",
                    \"messages\": [{\"role\": \"user\", \"content\": \"${prompts[$i]}\"}],
                    \"temperature\": 0.7,
                    \"max_tokens\": 100,
                    \"stream\": false
                }" \
                --max-time "${QUALITY_TEST_TIMEOUT}" 2>/dev/null || echo "{\"error\": \"timeout\"}")

            local answer=$(echo "${response}" | jq -r '.choices[0].message.content // "ERROR"' 2>/dev/null || echo "ERROR")
            echo "Answer: ${answer}"
            echo ""
        done
    } | tee "${output_file}"

    log_success "Quality test completed"
}

# Thermal monitoring function
run_thermal_test() {
    local model=$1
    local mode=$2
    local output_dir="${RESULTS_DIR}/${mode}"
    local output_file="${output_dir}/thermal-test-${model//\//-}.csv"
    local duration=${THERMAL_TEST_DURATION}

    log_info "Running thermal test for ${model} (${mode} mode) - ${duration}s duration..."

    local start_time=$(date +%s)
    local end_time=$((start_time + duration))

    {
        echo "timestamp,cpu_temp,cpu_usage,gpu_temp,gpu_usage,memory_usage_mb"

        while [ $(date +%s) -lt "${end_time}" ]; do
            local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            local cpu_temp="N/A"
            local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
            local gpu_temp="N/A"
            local gpu_usage="N/A"
            local mem_usage=$(free -m | awk 'NR==2{print $3}')

            # Get CPU temp if available
            if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
                cpu_temp=$(echo "scale=1; $(cat /sys/class/thermal/thermal_zone0/temp) / 1000" | bc)
            fi

            # Try NVIDIA GPU
            if command -v nvidia-smi &> /dev/null; then
                gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
                gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
            fi

            echo "${timestamp},${cpu_temp},${cpu_usage},${gpu_temp},${gpu_usage},${mem_usage}"

            sleep 2
        done
    } | tee "${output_file}"

    log_success "Thermal test completed"
}

# Get first available model
get_first_model() {
    curl -s "${LMSTUDIO_URL}/models" | jq -r '.data[0].id' 2>/dev/null || return 1
}

# Run all tests for a mode
run_all_tests() {
    local mode=$1

    log_info "Starting benchmark suite for ${mode} mode..."

    # Collect system info
    collect_system_info "${mode}"

    # Get first available model (for demo, use just one)
    local model
    model=$(get_first_model) || {
        log_error "No models available"
        return 1
    }

    log_info "Testing with model: ${model}"

    # Run tests
    run_speed_test "${model}" "${mode}" || true
    run_quality_test "${model}" "${mode}" || true
    run_thermal_test "${model}" "${mode}" || true

    log_success "Completed all tests for ${mode} mode"
}

# Generate summary report
generate_summary() {
    local summary_file="${RESULTS_DIR}/summary.txt"

    log_info "Generating summary report..."

    {
        echo "=== LMStudio Benchmark Summary ==="
        echo "Generated: $(date)"
        echo ""

        echo "=== Baseline Results ==="
        if [ -f "${RESULTS_DIR}/baseline/speed-test"* ]; then
            jq . "${RESULTS_DIR}"/baseline/speed-test* 2>/dev/null | grep -E "model|throughput" || echo "No baseline results"
        fi
        echo ""

        echo "=== Overclocked Results ==="
        if [ -f "${RESULTS_DIR}/overclocked/speed-test"* ]; then
            jq . "${RESULTS_DIR}"/overclocked/speed-test* 2>/dev/null | grep -E "model|throughput" || echo "No overclocked results"
        fi
        echo ""

        echo "=== Detailed Results Location ==="
        echo "Results directory: ${RESULTS_DIR}"
        echo "Logs directory: ${BENCHMARK_DIR}/logs"

    } | tee "${summary_file}"
}

# Main execution
main() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         LMStudio Performance Benchmarking Suite             ║"
    echo "║            CachyOS Normal vs Overclocking                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""

    # Check system
    check_dependencies || exit 1
    check_lmstudio || exit 1

    # Run tests based on mode
    case "${MODE}" in
        baseline)
            run_all_tests "baseline"
            ;;
        overclocked)
            run_all_tests "overclocked"
            ;;
        both)
            run_all_tests "baseline"
            log_info "Baseline testing complete. Apply overclocking then run in overclocked mode."
            run_all_tests "overclocked"
            ;;
        *)
            log_error "Unknown mode: ${MODE}"
            echo "Usage: $0 [baseline|overclocked|both]"
            exit 1
            ;;
    esac

    # Generate summary
    generate_summary

    echo ""
    log_success "Benchmark complete!"
    echo ""
    log_info "Results saved to: ${RESULTS_DIR}"
    log_info "Review results: cat ${RESULTS_DIR}/summary.txt"
    log_info "Compare results: diff ${RESULTS_DIR}/baseline ${RESULTS_DIR}/overclocked"
}

# Run main
main
