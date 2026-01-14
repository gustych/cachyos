# LMStudio Performance Benchmarking Guide

Testing LMStudio in normal vs overclocking mode on CachyOS to understand performance gains and trade-offs.

## Quick Start

```bash
# Install LMStudio
yay -S lm-studio

# Start benchmarking
bash ~/CachyOS-Setup-Documentation/lmstudio-benchmark.sh
```

---

## What You'll Be Testing

This guide covers comprehensive benchmarking across four dimensions:

1. **Speed Metrics** - Tokens/second, generation time, response latency
2. **Quality Assessment** - Response coherence, accuracy, consistency between modes
3. **Power/Performance** - CPU/GPU usage, power draw, efficiency
4. **Thermal Performance** - Temperature under load, thermal throttling

---

## Prerequisites

### Install Required Tools

```bash
# Base system monitoring
sudo pacman -S sysstat curl jq

# LMStudio (if not installed)
yay -S lm-studio

# Optional: Better monitoring
yay -S btop htop gpu-monitor-tools
```

### Create Working Directory

```bash
mkdir -p ~/.lmstudio-benchmarks
cd ~/.lmstudio-benchmarks
```

---

## Installation & Setup

### 1. Install LMStudio

```bash
# Install from AUR
yay -S lm-studio

# Or download from https://lmstudio.ai (if not in AUR)
```

### 2. Download Test Models

Start LMStudio and download these models (varies by preference):

**Small Models** (Fast, lower resource usage)
- `Llama 2 7B` - 4.2 GB
- `Mistral 7B` - 4.0 GB
- `Phi 2` - 1.4 GB

**Medium Models** (Balanced)
- `Llama 2 13B` - 7.4 GB
- `Mistral 8x7B MoE` - 26 GB (if available)

**Large Models** (Comprehensive testing)
- `Llama 2 70B` - 39 GB
- `Mixtral 8x22B` - 85 GB (if VRAM allows)

**Recommendation for testing:** Start with Mistral 7B and Llama 2 13B.

### 3. Configure LMStudio Server

LMStudio settings > Server:
- **Context length:** 2048 tokens (standard testing)
- **GPU acceleration:** Enabled
- **CPU threads:** Auto-detect or set to your core count

---

## Benchmark Scripts

Run the main benchmarking script:

```bash
bash ~/CachyOS-Setup-Documentation/lmstudio-benchmark.sh
```

This script will:
1. Start LMStudio server (if not running)
2. Run predefined prompts for each model
3. Collect timing, power, and thermal data
4. Save results to structured JSON/CSV files
5. Generate comparison reports

---

## Manual Benchmarking Process

### Setup: Baseline (Normal Mode)

**Step 1: Prepare System**
```bash
# Create backup before overclocking changes
safety-manager pre "LMStudio benchmarking - baseline test"

# Clear any cached data
sudo sync && sudo echo 3 > /proc/sys/vm/drop_caches

# Close unnecessary applications
# Keep: LMStudio, monitoring tools, terminal
```

**Step 2: Monitor System Metrics**

Open a new terminal and run:
```bash
# Real-time monitoring dashboard
btop

# Or use the monitoring script:
bash ~/.lmstudio-benchmarks/monitor-performance.sh
```

**Step 3: Start LMStudio Server**
```bash
# Check if running
curl -s http://localhost:8000/api/models | jq .

# If not running, start it from the GUI or:
# lm-studio --headless (depends on installation)
```

### Test 1: Speed Benchmark

**Standard Prompt for Speed Testing:**
```
This is a test prompt to measure response speed.
Please write a detailed explanation of how neural
networks work, covering the main concepts, training
methods, and practical applications. Be thorough
and educational.
```

**Run the test:**
```bash
bash ~/.lmstudio-benchmarks/speed-test.sh
```

This measures:
- **First token latency** - Time to first response
- **Throughput** - Tokens/second generation
- **Total generation time** - Full response completion time

**Expected output:**
```
Model: mistral-7b
First Token: 245ms
Throughput: 18.3 tokens/sec
Total Time: 4.2 seconds for 77 tokens
```

### Test 2: Quality Assessment

**Quality Testing Prompts:**

Save these to `~/.lmstudio-benchmarks/quality-prompts.txt`:

```
1. Explain quantum computing in simple terms (4-5 sentences)
2. What are the three types of machine learning?
3. Write a Python function that reverses a string
4. List the pros and cons of renewable energy
5. What is the capital of France? (Sanity check)
6. Explain blockchain technology
7. How does photosynthesis work?
8. What are the main causes of climate change?
```

**Run quality tests:**
```bash
bash ~/.lmstudio-benchmarks/quality-test.sh
```

**Evaluation criteria:**
- **Accuracy** - Are answers factually correct?
- **Coherence** - Is the response well-structured?
- **Consistency** - Does the model give similar answers when prompted again?
- **Hallucinations** - Any made-up facts or data?

**Record results in:**
`~/.lmstudio-benchmarks/results/quality-results.csv`

### Test 3: Power & Performance Monitoring

**Real-time monitoring (run in background):**
```bash
bash ~/.lmstudio-benchmarks/monitor-performance.sh &
MONITOR_PID=$!

# Run a generation task
bash ~/.lmstudio-benchmarks/speed-test.sh

# Stop monitoring
kill $MONITOR_PID
```

**Metrics collected:**
- CPU usage (%)
- GPU usage (%)
- Memory usage (GB)
- Power draw (Watts) - requires `intel_rapl` or similar
- Temperature (°C)

### Test 4: Thermal Performance

**Extended thermal test:**
```bash
bash ~/.lmstudio-benchmarks/thermal-test.sh
```

This runs repeated prompts for 30 minutes to observe:
- **Thermal ramp-up time** - How long to reach max temp
- **Thermal stability** - Does it stabilize or keep rising?
- **Throttling detection** - Any performance drops from thermal limits?
- **Fan behavior** - If applicable

---

## Testing with Overclocking

### Before Overclocking

1. **Create system snapshot:**
   ```bash
   safety-manager pre "GPU/CPU overclocking test - snapshot for recovery"
   snapshot-manager list  # Verify snapshot created
   ```

2. **Document baseline results:**
   - Copy all results from `~/.lmstudio-benchmarks/results/baseline/`
   - Keep a backup: `cp -r ~/.lmstudio-benchmarks/results ~/.lmstudio-benchmarks/results-backup`

### Apply Overclocking

**GPU Overclocking (AMD/NVIDIA - check your hardware):**

For NVIDIA (if applicable):
```bash
# View current clocks
nvidia-smi -q | grep "Clock\|Power Draw"

# Over-clocking (requires careful setup - check nvidia-utils documentation)
# This is hardware-specific!
```

For AMD:
```bash
# Check GPU info
lspci | grep VGA

# ROCm/AMD tools vary - check rocm documentation
```

**CPU Overclocking:**
- Typically done in BIOS/UEFI (CachyOS BIOS settings)
- Or use tools like `cpupower` for frequency scaling

### Overclocked Testing

1. **Clear caches again:**
   ```bash
   sudo sync && sudo echo 3 > /proc/sys/vm/drop_caches
   ```

2. **Run same tests with "_OC" suffix:**
   ```bash
   bash ~/.lmstudio-benchmarks/speed-test.sh _OC
   bash ~/.lmstudio-benchmarks/quality-test.sh _OC
   bash ~/.lmstudio-benchmarks/thermal-test.sh _OC
   ```

3. **Compare results** (see Analysis section below)

### Return to Stock Settings

```bash
# If using software overclocking, revert settings
# If BIOS overclocking, reset in BIOS

# Verify normal clocks
# Then delete the snapshot if satisfied:
safety-manager post "Overclocking test completed - returned to stock"
```

---

## Results Template

Create `~/.lmstudio-benchmarks/results/comparison-template.md`:

```markdown
# LMStudio Benchmark Results

## System Info
- **CPU:** [Your CPU]
- **GPU:** [Your GPU]
- **RAM:** [GB]
- **OS:** CachyOS
- **Kernel:** [Your kernel]
- **LMStudio Version:** [Version]
- **Test Date:** [YYYY-MM-DD]

## Models Tested
- [ ] Phi 2 (1.4 GB)
- [ ] Mistral 7B (4.0 GB)
- [ ] Llama 2 13B (7.4 GB)
- [ ] Llama 2 70B (39 GB)

## Speed Results

| Model | Mode | First Token (ms) | Throughput (tok/s) | Total Time (s) |
|-------|------|-----------------|-------------------|----------------|
| Mistral 7B | Normal | | | |
| Mistral 7B | OC | | | |
| Llama 2 13B | Normal | | | |
| Llama 2 13B | OC | | | |

## Power & Thermal (Steady State)

| Model | Mode | Avg CPU% | Avg GPU% | Avg Temp°C | Max Temp°C | Power Draw(W) |
|-------|------|----------|----------|-----------|-----------|---------------|
| Mistral 7B | Normal | | | | | |
| Mistral 7B | OC | | | | | |

## Quality Assessment

| Model | Mode | Accuracy | Coherence | Consistency | Notes |
|-------|------|----------|-----------|-------------|-------|
| Mistral 7B | Normal | | | | |
| Mistral 7B | OC | | | | |

### Quality Notes
- Hallucinations: [None / Describe any]
- Response consistency: [Same across 3 runs? Y/N]
- Any quality degradation in OC mode: [Describe]

## Analysis & Conclusions

### Performance Gains
```
Mistral 7B:
  - Speed increase: [X%]
  - Power increase: [Y%]
  - Thermal increase: [Z°C]
```

### Trade-offs
- [ ] Stability: Any crashes or errors?
- [ ] Thermal throttling observed?
- [ ] Quality impact: Any degradation?
- [ ] Stability over time: Consistent performance?

### Recommendation
- Best for: [Your use case]
- Overclocking worth it: Yes/No
- Optimal mode: [Normal/OC]
- Reason: [Your conclusion]

## Raw Data Files
- `speed-test-normal.json`
- `speed-test-oc.json`
- `thermal-test-normal.csv`
- `thermal-test-oc.csv`
- `quality-test-normal.log`
- `quality-test-oc.log`
```

---

## Analysis & Comparison

### Generate Comparison Report

```bash
python3 ~/.lmstudio-benchmarks/compare-results.py \
  ~/.lmstudio-benchmarks/results/normal \
  ~/.lmstudio-benchmarks/results/overclocked
```

This produces:
- Performance delta (%)
- Thermal delta (°C)
- Power efficiency comparison
- Quality regression analysis

### Quick Manual Comparison

```bash
# View all results
ls -lh ~/.lmstudio-benchmarks/results/

# Compare specific tests
diff ~/.lmstudio-benchmarks/results/speed-test-normal.txt \
     ~/.lmstudio-benchmarks/results/speed-test-oc.txt

# Summary statistics
cat ~/.lmstudio-benchmarks/results/summary.txt
```

---

## Interpreting Results

### Speed Metrics

**Throughput (tokens/second):**
- 8-12 tok/s = Good for interactive use
- 15-25 tok/s = Very responsive
- 30+ tok/s = Excellent

**Overclocking impact:**
- Typical gain: 10-30% faster
- Diminishing returns after 2-3% CPU/GPU OC

### Power Draw

**Baseline expectations:**
- Idle: 20-40W
- Light load (inference): 60-120W
- Heavy load (large model): 150-300W

**Overclocking impact:**
- Typical increase: 20-50W more power draw
- Performance/watt ratio gets worse (more power for less speed gain)

### Thermal

**Safe operating temperatures:**
- CPU: <80°C (safe), <90°C (caution)
- GPU: <75°C (safe), <85°C (caution)
- Sustained >90°C risks throttling or hardware damage

**Overclocking thermal impact:**
- Expect +5-15°C increase
- Monitor for thermal throttling

### Quality Assessment

**No degradation expected:**
- Overclocking shouldn't reduce answer quality
- If you see wrong answers in OC mode = unstable, reduce OC

---

## Troubleshooting

### LMStudio Won't Start
```bash
# Check if port 8000 is in use
lsof -i :8000

# Kill conflicting process if needed
kill -9 <PID>

# Check logs
journalctl -xe
```

### Performance Tests Failing
```bash
# Verify server is running and responsive
curl http://localhost:8000/api/models

# Check GPU is being used
nvidia-smi  # For NVIDIA
rocm-smi    # For AMD
```

### Thermal Throttling Detected
```bash
# Check actual CPU frequency
watch -n 1 "cat /proc/cpuinfo | grep MHz"

# Check thermal limits
cat /sys/class/thermal/thermal_zone0/temp

# Reduce overclocking if throttling occurs
```

### Results Not Saving
```bash
# Ensure directory exists
mkdir -p ~/.lmstudio-benchmarks/results

# Check permissions
ls -ld ~/.lmstudio-benchmarks/results
chmod 755 ~/.lmstudio-benchmarks/results
```

---

## Safety Reminders

⚠️ **Before Overclocking:**
1. Create system snapshots with `safety-manager pre`
2. Document baseline results thoroughly
3. Test incrementally (small OC steps)
4. Monitor temperatures closely
5. Know how to revert changes quickly

⚠️ **During Testing:**
1. Don't leave overclocked system unattended
2. Have thermal monitoring visible at all times
3. Stop if temperatures exceed safe limits
4. Note any instability immediately

⚠️ **After Testing:**
1. Return to stock settings
2. Run stability tests
3. Compare results systematically
4. Document findings

---

## Next Steps

1. Run `bash ~/CachyOS-Setup-Documentation/lmstudio-benchmark.sh`
2. Let it complete baseline tests (30-60 minutes)
3. Review results in `~/.lmstudio-benchmarks/results/`
4. Document system info in comparison template
5. Apply overclocking and repeat tests
6. Analyze trade-offs and draw conclusions

---

## Additional Resources

### LMStudio
- Official: https://lmstudio.ai
- GitHub: https://github.com/lmstudio-ai

### Model Information
- Hugging Face Models: https://huggingface.co/models
- GGUF Format: https://github.com/ggerganov/llama.cpp

### Performance Tuning
- CachyOS Wiki: https://wiki.cachyos.org/
- Optimization guides in SETUP-GUIDE.txt

### Overclocking Resources
- Your hardware manufacturer's documentation
- Hardware-specific forums (r/overclocking, etc.)

---

**Last Updated:** 2026-01-14
**Test Configuration:** CachyOS + Hyprland
**Benchmark Script:** `lmstudio-benchmark.sh`
