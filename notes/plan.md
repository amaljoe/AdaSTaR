# AdaSTaR Reproduction Plan

**Paper:** AdaSTaR: Adaptive Data Sampling for Training Self-Taught Reasoners (Koh et al., NeurIPS 2025)  
**arXiv:** https://arxiv.org/abs/2505.16322  
**Method:** `adastar_new_square` (deterministic, primary method), seed=10  
**Hardware:** 4×L40S GPUs

---

## Paper's Exact Claims

### Table 1 — Llama-3.2-3B

| Task | Accuracy | Iters | PFLOPs |
|------|----------|-------|--------|
| GSM8K | 77.0% | **2** | 19.3 |
| SVAMP | 75.5% | **9** | 65.7 |
| ARC-C | 73.8% | **10** | 174.4 |
| ANLI-R1 | 66.8% | **21** | 1,340.9 |
| CQA | 78.0% | **20** | 779.3 |
| CLadder | 95.6% | **23** | 3,610.0 |

### Appendix H — Qwen2.5-3B
GSM8K: 77.0%, ARC-C: 73.8%, SVAMP: 75.5%  
*(Iteration counts for Qwen not extracted from paper)*

### Appendix I — Gemma-7B
Best on 4/5 benchmarks  
*(Exact numbers not extracted)*

---

## Step Growth Schedule

`n_steps = 40 × 1.2^(iter-1)` (exponential growth)

| Iter | Steps | Samples |
|------|-------|---------|
| 1 | 40 | 320 |
| 2 | 48 | 384 |
| 9 | 172 | 1,376 |
| 10 | 206 | 1,648 |
| 20 | 1,276 | 10,208 |
| 21 | 1,531 | 12,248 |
| 23 | 2,205 | 17,640 |

---

## Models

| Model | Status | Size |
|-------|--------|------|
| `Qwen/Qwen2.5-3B` | ✅ cached | ~6GB |
| `meta-llama/Llama-3.2-3B` | ✅ cached | ~12GB |
| `google/gemma-7b` | ❌ needs download | ~14GB |

---

## Experiment Queue (ascending compute / PFLOPs)

All experiments run with `--method=adastar_new_square --seed=10`.

| # | Experiment | Config | n_iters | Est. PFLOPs | Est. Time | Status |
|---|-----------|--------|---------|-------------|-----------|--------|
| 1 | GSM8K + Qwen2.5-3B | gsm8k_qwen.json | 2 | ~19 | ~8 min | ✅ DONE |
| 2 | GSM8K + Llama-3.2-3B | gsm8k.json | 2 | ~19 | ~8 min | ⏳ queued |
| 3 | SVAMP + Llama-3.2-3B | svamp.json | 9 | ~35 | ~25 min | ⏳ queued |
| 4 | SVAMP + Qwen2.5-3B | svamp_qwen.json | 9 | ~66 | ~45 min | ⏳ queued |
| 5 | SVAMP + Gemma-7B | svamp7b.json | 9 | ~95 | ~60 min | ⏳ queued |
| 6 | ARC-C + Llama-3.2-3B | arc_challenge.json | 10 | ~100 | ~55 min | ⏳ queued |
| 7 | ARC-C + Qwen2.5-3B | arc_challenge_qwen.json | 10 | ~174 | ~70 min | ⏳ queued |
| 8 | ARC-C + Gemma-7B | arc_challenge7b.json | 10 | ~250 | ~100 min | ⏳ queued |
| 9 | CQA + Llama-3.2-3B | cqa.json | 20 | ~779 | ~9 hrs | ⏳ night 2 |
| 10 | ANLI-R1 + Llama-3.2-3B | anli_r1.json | 21 | ~1341 | ~11 hrs | ⏳ night 3 |
| 11 | CLadder + Llama-3.2-3B | cladder.json | 23 | ~3610 | ~15+ hrs | ⏳ night 4 |

**Night 1 total (exp 1–8): ~6.3 hours ✅ overnight-safe**

---

## Commands

### Night 1 — `~/workspace/adastar/run_night1.sh`

Run after GSM8K Qwen (#1) finishes:

```bash
#!/bin/bash
set -e
export LD_PRELOAD=/dev/shm/vllm/lib/libstdc++.so.6
cd ~/workspace/adastar

echo "[$(date)] Night 1 start"

python iteration_train.py --config=configs/gsm8k.json \
  --method=adastar_new_square --seed=10 --n_iters=2 \
  2>&1 | tee train_gsm8k_llama_seed10.log && echo "[$(date)] #2 DONE: GSM8K Llama"

python iteration_train.py --config=configs/svamp.json \
  --method=adastar_new_square --seed=10 --n_iters=9 \
  2>&1 | tee train_svamp_llama_seed10.log && echo "[$(date)] #3 DONE: SVAMP Llama"

python iteration_train.py --config=configs/svamp_qwen.json \
  --method=adastar_new_square --seed=10 --n_iters=9 \
  2>&1 | tee train_svamp_qwen_seed10.log && echo "[$(date)] #4 DONE: SVAMP Qwen"

python -c "from transformers import AutoModelForCausalLM, AutoTokenizer; AutoTokenizer.from_pretrained('google/gemma-7b'); AutoModelForCausalLM.from_pretrained('google/gemma-7b'); print('OK')" \
  2>&1 | tee download_gemma7b.log && echo "[$(date)] Gemma-7B downloaded"

python iteration_train.py --config=configs/svamp7b.json \
  --method=adastar_new_square --seed=10 --n_iters=9 \
  2>&1 | tee train_svamp_gemma7b_seed10.log && echo "[$(date)] #5 DONE: SVAMP Gemma-7B"

python iteration_train.py --config=configs/arc_challenge.json \
  --method=adastar_new_square --seed=10 --n_iters=10 \
  2>&1 | tee train_arc_llama_seed10.log && echo "[$(date)] #6 DONE: ARC-C Llama"

python iteration_train.py --config=configs/arc_challenge_qwen.json \
  --method=adastar_new_square --seed=10 --n_iters=10 \
  2>&1 | tee train_arc_qwen_seed10.log && echo "[$(date)] #7 DONE: ARC-C Qwen"

python iteration_train.py --config=configs/arc_challenge7b.json \
  --method=adastar_new_square --seed=10 --n_iters=10 \
  2>&1 | tee train_arc_gemma7b_seed10.log && echo "[$(date)] #8 DONE: ARC-C Gemma-7B"

echo "[$(date)] Night 1 COMPLETE"
```

### Night 2
```bash
cd ~/workspace/adastar && python iteration_train.py --config=configs/cqa.json \
  --method=adastar_new_square --seed=10 --n_iters=20 2>&1 | tee train_cqa_llama_seed10.log
```

### Night 3
```bash
cd ~/workspace/adastar && python iteration_train.py --config=configs/anli_r1.json \
  --method=adastar_new_square --seed=10 --n_iters=21 2>&1 | tee train_anli_llama_seed10.log
```

### Night 4
```bash
cd ~/workspace/adastar && python iteration_train.py --config=configs/cladder.json \
  --method=adastar_new_square --seed=10 --n_iters=23 2>&1 | tee train_cladder_llama_seed10.log
```

---

## Where Results Live

```
gsm8k/gsm8k_qwen_adastar_new_square_10/eval_log.json
gsm8k/gsm8k_adastar_new_square_10/eval_log.json
svamp/svamp_qwen_adastar_new_square_10/eval_log.json
svamp/svamp_adastar_new_square_10/eval_log.json
svamp/svamp7b_adastar_new_square_10/eval_log.json
arc_challenge/arc_challenge_qwen_adastar_new_square_10/eval_log.json
arc_challenge/arc_challenge_adastar_new_square_10/eval_log.json
arc_challenge/arc_challenge7b_adastar_new_square_10/eval_log.json
cqa/cqa_adastar_new_square_10/eval_log.json
anli_r1/anli_r1_adastar_new_square_10/eval_log.json
cladder/cladder_adastar_new_square_10/eval_log.json
```

---

## Bugs Fixed

1. **HF datasets cache race condition**: `hf_datasets.disable_caching()` added to `device_inference.py`, `device_train.py`, `device_inference_adastar_new_square.py`; `load_from_cache_file=False` added to all `.map()` calls in `utils.py` and `utils_adastar.py`.
2. **Missing `configs/gsm8k_qwen.json`**: Created manually.
