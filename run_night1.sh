#!/bin/bash
# AdaSTaR Night 1 experiments — ascending compute order
# Experiments #2-8 (GSM8K Qwen #1 already done)
set -e
export LD_PRELOAD=/dev/shm/vllm/lib/libstdc++.so.6
cd ~/workspace/adastar

echo "[$(date)] ===== Night 1 START ====="

# #2: GSM8K + Llama-3.2-3B (2 iters, ~19 PFLOPs)
echo "[$(date)] Starting #2: GSM8K + Llama-3.2-3B"
python iteration_train.py --config=configs/gsm8k.json \
  --method=adastar_new_square --seed=10 --n_iters=2 \
  2>&1 | tee train_gsm8k_llama_seed10.log
echo "[$(date)] DONE #2: GSM8K + Llama"

# #3: SVAMP + Llama-3.2-3B (9 iters, ~35 PFLOPs)
echo "[$(date)] Starting #3: SVAMP + Llama-3.2-3B"
python iteration_train.py --config=configs/svamp.json \
  --method=adastar_new_square --seed=10 --n_iters=9 \
  2>&1 | tee train_svamp_llama_seed10.log
echo "[$(date)] DONE #3: SVAMP + Llama"

# #4: SVAMP + Qwen2.5-3B (9 iters, ~66 PFLOPs)
echo "[$(date)] Starting #4: SVAMP + Qwen2.5-3B"
python iteration_train.py --config=configs/svamp_qwen.json \
  --method=adastar_new_square --seed=10 --n_iters=9 \
  2>&1 | tee train_svamp_qwen_seed10.log
echo "[$(date)] DONE #4: SVAMP + Qwen"

# Download Gemma-7B (needed for #5 and #8)
echo "[$(date)] Downloading google/gemma-7b..."
python -c "
from transformers import AutoModelForCausalLM, AutoTokenizer
AutoTokenizer.from_pretrained('google/gemma-7b')
AutoModelForCausalLM.from_pretrained('google/gemma-7b')
print('Gemma-7B OK')
" 2>&1 | tee download_gemma7b.log
echo "[$(date)] Gemma-7B downloaded"

# #5: SVAMP + Gemma-7B (9 iters, ~95 PFLOPs)
echo "[$(date)] Starting #5: SVAMP + Gemma-7B"
python iteration_train.py --config=configs/svamp7b.json \
  --method=adastar_new_square --seed=10 --n_iters=9 \
  2>&1 | tee train_svamp_gemma7b_seed10.log
echo "[$(date)] DONE #5: SVAMP + Gemma-7B"

# #6: ARC-C + Llama-3.2-3B (10 iters, ~100 PFLOPs)
echo "[$(date)] Starting #6: ARC-C + Llama-3.2-3B"
python iteration_train.py --config=configs/arc_challenge.json \
  --method=adastar_new_square --seed=10 --n_iters=10 \
  2>&1 | tee train_arc_llama_seed10.log
echo "[$(date)] DONE #6: ARC-C + Llama"

# #7: ARC-C + Qwen2.5-3B (10 iters, ~174 PFLOPs)
echo "[$(date)] Starting #7: ARC-C + Qwen2.5-3B"
python iteration_train.py --config=configs/arc_challenge_qwen.json \
  --method=adastar_new_square --seed=10 --n_iters=10 \
  2>&1 | tee train_arc_qwen_seed10.log
echo "[$(date)] DONE #7: ARC-C + Qwen"

# #8: ARC-C + Gemma-7B (10 iters, ~250 PFLOPs)
echo "[$(date)] Starting #8: ARC-C + Gemma-7B"
python iteration_train.py --config=configs/arc_challenge7b.json \
  --method=adastar_new_square --seed=10 --n_iters=10 \
  2>&1 | tee train_arc_gemma7b_seed10.log
echo "[$(date)] DONE #8: ARC-C + Gemma-7B"

echo "[$(date)] ===== Night 1 COMPLETE ====="
