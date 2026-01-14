# LM Studio Benchmark Results

**Date:** 2026-01-14
**System:** CachyOS Linux with Hyprland
**Purpose:** Baseline performance testing before overclocking

---

## System Specs

| Component | Details |
|-----------|---------|
| **CPU** | AMD Ryzen 9 5900XT 16-Core (32 threads) |
| **RAM** | 62GB DDR4 |
| **GPU** | AMD Radeon RX 5700 XT (8GB VRAM) |
| **Storage** | NVMe SSD (btrfs) |
| **Kernel** | 6.18.5-2-cachyos |

---

## Baseline Results (Normal Mode)

| Model | Parameters | Speed (tok/s) | RAM Used | CPU Temp | Notes |
|-------|------------|---------------|----------|----------|-------|
| Mistral 7B | 7B | **63.42** | 5.0 GB | 45-48°C | Fastest overall |
| Apertus 8B | 8B | **57.80** | 5.6 GB | 44°C | Fast + quality |
| GPT-OSS 20B | 20B | **14.76** | 23 GB | 48°C | Best value (MXFP4) |
| Llama 3.1 8B | 8B | 9.33 | 8.5 GB | 44°C | Slower than expected |
| Qwen 2.5 Coder 14B | 14B | 5.10 | 20 GB | 47°C | Good for coding |
| Mistral Small 24B | 24B | 2.78 | 39 GB | 45-47°C | Highest quality |

---

## Quality Test Results

All models answered correctly:
- ✅ Math: "What is 2+2?" → 4
- ✅ Concepts: Machine learning explanation
- ✅ Lists: Programming languages
- ✅ Facts: Capital of France → Paris
- ✅ Science: Photosynthesis explanation

**Notable:** Larger models provided more detailed, formatted answers (markdown, bullet points).

---

## Performance Analysis

### Speed Tiers

**Tier 1 - Real-time (50+ tok/s):**
- Mistral 7B, Apertus 8B
- Best for: Chat, quick responses, daily use

**Tier 2 - Fast (10-50 tok/s):**
- GPT-OSS 20B
- Best for: Balanced quality/speed

**Tier 3 - Moderate (5-10 tok/s):**
- Llama 3.1 8B, Qwen Coder 14B
- Best for: Coding, detailed tasks

**Tier 4 - Slow (<5 tok/s):**
- Mistral 24B
- Best for: Complex reasoning, important tasks

### RAM Usage Pattern

```
7B models:   ~5 GB  (fits easily)
8B models:   ~5-8 GB (fits in VRAM)
14B models:  ~20 GB (CPU + partial GPU)
20B models:  ~23 GB (CPU heavy)
24B models:  ~39 GB (CPU only)
```

### Thermal Observations

- CPU stayed cool throughout: 44-48°C
- No thermal throttling observed
- System remained stable under all loads
- 62GB RAM handled 39GB model comfortably

---

## Recommendations

### Daily Use
- **Mistral 7B** or **Apertus 8B** - Fast, responsive, good quality

### Coding
- **Qwen 2.5 Coder 14B** - Specialized for code, detailed explanations

### Best Value
- **GPT-OSS 20B** - Larger model, surprisingly fast (MXFP4 quantization)

### Maximum Quality
- **Mistral Small 24B** - Best answers, but slow (2.8 tok/s)

---

## Overclocking Tests

**Status:** Pending (next session)

### Test Order (run in this sequence)

1. **Mistral 7B** - Load and run benchmark
2. **Apertus 8B** - Load and run benchmark
3. **GPT-OSS 20B** - Load and run benchmark
4. **Qwen 2.5 Coder 14B** - Load and run benchmark
5. **Mistral Small 24B** - Load and run benchmark (optional, slow)

### Commands Ready

```bash
# Start LM Studio
~/.local/bin/lm-studio &

# Monitor GPU (separate terminal)
watch -n 1 /opt/rocm/bin/rocm-smi

# Run benchmark (after loading each model)
bash ~/CachyOS-Setup-Documentation/lmstudio-benchmark.sh overclocked
```

### What to Compare

| Model | Baseline | Overclocked | Gain |
|-------|----------|-------------|------|
| Mistral 7B | 63.42 tok/s | ? | ? |
| Apertus 8B | 57.80 tok/s | ? | ? |
| GPT-OSS 20B | 14.76 tok/s | ? | ? |
| Qwen Coder 14B | 5.10 tok/s | ? | ? |
| Mistral 24B | 2.78 tok/s | ? | ? |

---

## Files

- Benchmark script: `~/CachyOS-Setup-Documentation/lmstudio-benchmark.sh`
- Monitor script: `~/CachyOS-Setup-Documentation/monitor-performance.sh`
- Raw results: `~/.lmstudio-benchmarks/results/baseline/`

---

## Recovery Info

Snapshot #40 created before testing: "Before LM Studio stress test"

To rollback if needed:
```bash
sudo snapper rollback 40
sudo reboot
```

---

**Last Updated:** 2026-01-14 21:55
