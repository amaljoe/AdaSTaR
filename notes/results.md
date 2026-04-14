# AdaSTaR Reproduction Results

Last updated: 2026-04-14  
Method: `adastar_new_square`, seed=10, 4×L40S GPUs

---

## GSM8K + Qwen2.5-3B (✅ DONE — 2 iters)

**Paper claim (App. H):** 77.0%  
**Log:** `train_gsm8k_qwen_seed10.log`

| Iter | Split | Our Acc | Paper |
|------|-------|---------|-------|
| 1 | train | 72.68% | — |
| 1 | dev | 68.6% | — |
| 2 | train | 78.91% | — |
| 2 | dev | **73.2%** | **77.0%** |

**Gap: -3.8pp below paper.** Qwen may need more than 2 iterations to converge to 77%. Paper's Table 1 iter counts are for Llama; Qwen convergence iteration unknown.

---

## GSM8K + Llama-3.2-3B (⚠️ NEEDS RERUN — base model results invalid)

**Paper claim (Table 1):** 77.0% @ 2 iters, 19.3 PFLOPs  
**Log:** `train_gsm8k_llama_seed10.log`  
**⚠️ Config now fixed to Llama-3.2-3B-Instruct but Night 1 skipped this (old dir existed). Delete `gsm8k/gsm8k_adastar_new_square_10/` and re-run.**

| Iter | Split | Our Acc | Paper |
|------|-------|---------|-------|
| 1 | train | 18.27% | — |
| 1 | dev | 26.00% | — |
| 2 | train | 21.24% | — |
| 2 | dev | **28.0%** | **77.0%** |

**Gap: -49pp below paper.** Base model starts at 18.3% accuracy (vs Qwen's 72.7%).  
Likely cause: paper uses `meta-llama/Llama-3.2-3B-Instruct` (instruction-tuned, higher base math accuracy).

---

---

## SVAMP + Llama-3.2-3B-Instruct (✅ DONE — 9 iters)

**Paper claim:** 75.5% @ 9 iters, 65.7 PFLOPs  
**Log:** `train_svamp_llama_seed10.log`

| Iter | Split | Our Acc | Paper |
|------|-------|---------|-------|
| 1 | dev | 26.0% | — |
| 2 | dev | 80.5% | — |
| 3 | dev | 85.5% | — |
| 4 | dev | 81.0% | — |
| 5 | dev | 82.5% | — |
| 6 | dev | 84.5% | — |
| 7 | dev | 86.0% | — |
| 8 | dev | 84.0% | — |
| 9 | dev | **88.0%** | **75.5%** |

**Gap: +12.5pp above paper.** Instruct model converges faster and higher.

---

## SVAMP + Qwen2.5-3B (✅ DONE — 9 iters)

**Paper claim (App. H):** 75.5%  
**Log:** `train_svamp_qwen_seed10.log`

| Iter | Dev Acc |
|------|---------|
| 1 | 57.5% |
| 2 | 79.5% |
| 3 | 86.5% |
| 4 | 87.5% |
| 5 | 92.0% |
| 6 | 92.5% |
| 7 | **93.5%** |
| 8 | 93.0% |
| 9 | 91.5% |

**Gap: +18pp above paper (peak 93.5% vs 75.5%).**

---

## SVAMP + Gemma-7B (✅ DONE — 9 iters)

**Paper claim (App. I):** TBD (paper says best on 4/5 benchmarks)  
**Log:** `train_svamp_gemma7b_seed10.log`

| Iter | Dev Acc |
|------|---------|
| 1 | 58.0% |
| 2 | 58.0% |
| 3 | 60.0% |
| 4 | 65.0% |
| 5 | 71.5% |
| 6 | 65.0% |
| 7 | 71.0% |
| 8 | 73.0% |
| 9 | **80.0%** |

**Final: 80.0% (vs SVAMP paper claim 75.5% for Llama/Qwen, +4.5pp). Slow ramp due to base model.**

---

## ARC-Challenge + Llama-3.2-3B-Instruct (✅ DONE — 10 iters)

**Paper claim:** 73.8% @ 10 iters, 174.4 PFLOPs  
**Log:** `train_arc_llama_seed10.log`

| Iter | Dev Acc |
|------|---------|
| 1 | 67.8% |
| 2 | 73.0% |
| 3 | 70.4% |
| 4 | 70.4% |
| 5 | 74.8% |
| 6 | 75.0% |
| 7 | **75.8%** |
| 8 | 73.2% |
| 9 | 73.4% |
| 10 | 74.0% |

**Final: 74.0%, peak 75.8% vs paper 73.8% (+0.2pp final, +2pp peak).**

---

## ARC-Challenge + Qwen2.5-3B (✅ DONE — 10 iters)

**Paper claim (App. H):** 73.8%  
**Log:** `train_arc_qwen_seed10.log`

| Iter | Dev Acc |
|------|---------|
| 1 | 56.8% |
| 2 | 80.8% |
| 3–6 | 79.8–81.4% |
| 7 | 82.4% |
| 8 | **83.8%** |
| 9 | 83.0% |
| 10 | 83.0% |

**Final: 83.0%, peak 83.8% vs paper 73.8% (+9.2pp).**

---

## ARC-Challenge + Gemma-7B (✅ DONE — 10 iters)

**Paper claim (App. I):** TBD (comparable to 73.8% Llama/Qwen)  
**Log:** `train_arc_gemma7b_seed10.log`

| Iter | Dev Acc |
|------|---------|
| 1–6 | 36–49.8% (slow ramp) |
| 7 | 58.6% |
| 8 | 73.2% |
| 9 | **74.4%** |
| 10 | **74.4%** |

**Final: 74.4% (+0.6pp vs paper's 73.8%). Explosive convergence in iters 7-9.**

---

## CQA + Llama-3.2-3B (⏳ night 2)

**Paper claim:** 78.0% @ 20 iters, 779.3 PFLOPs  
**Log:** `train_cqa_llama_seed10.log`

---

## ANLI-R1 + Llama-3.2-3B (⏳ night 3)

**Paper claim:** 66.8% @ 21 iters, 1,340.9 PFLOPs  
**Log:** `train_anli_llama_seed10.log`

---

## CLadder + Llama-3.2-3B (⏳ night 4+)

**Paper claim:** 95.6% @ 23 iters, 3,610.0 PFLOPs  
**Log:** `train_cladder_llama_seed10.log`

---

## Summary Table (fill as runs complete)

| Task | Model | Our Acc | Paper Acc | Δ | Status |
|------|-------|---------|-----------|---|--------|
| GSM8K | Qwen2.5-3B | 73.2% | 77.0% | -3.8pp | ✅ done |
| GSM8K | Llama-3.2-3B | 28.0% | 77.0% | -49pp | ⚠️ needs rerun (base model) |
| SVAMP | Llama-3.2-3B-Instruct | **88.0%** | 75.5% | **+12.5pp** | ✅ done |
| SVAMP | Qwen2.5-3B | **93.5%** | 75.5% | **+18pp** | ✅ done |
| SVAMP | Gemma-7B | **80.0%** | ~75.5% | **+4.5pp** | ✅ done |
| ARC-C | Llama-3.2-3B-Instruct | **74.0%** | 73.8% | **+0.2pp** | ✅ done |
| ARC-C | Qwen2.5-3B | **83.0%** | 73.8% | **+9.2pp** | ✅ done |
| ARC-C | Gemma-7B | **74.4%** | ~73.8% | **+0.6pp** | ✅ done |
| CQA | Llama-3.2-3B | — | 78.0% | — | ⏳ |
| ANLI-R1 | Llama-3.2-3B | — | 66.8% | — | ⏳ |
| CLadder | Llama-3.2-3B | — | 95.6% | — | ⏳ |
