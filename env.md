# AdaSTaR Environment Setup

Uses the same apptainer + `/dev/shm/vllm` environment as `../ixbrl-tagging/`. See that project's `env.md` for full setup details.

---

## Fast restore (< 1 min)

```bash
restorevllm    # extracts ~/envs/vllm.tar.zst → /dev/shm/vllm
app            # enter apptainer
mamba activate /dev/shm/vllm
```

## Project-specific packages

The following packages are needed beyond the base vllm env. Install once after restoring:

```bash
apptainer exec --nv ~/images/cuda-custom-amal_latest.sif /dev/shm/vllm/bin/pip install \
    jsonlines lm_dataformat optimum gdown --quiet
```

After installing, resave the snapshot:
```bash
savevllm
```

## Run an experiment

```bash
cd ~/workspace/adastar
app
mamba activate /dev/shm/vllm
export LD_PRELOAD=/dev/shm/vllm/lib/libstdc++.so.6

# AdaSTaR (square variant — main method)
python iteration_train.py --config=configs/arc_challenge.json --method=adastar_new_square --seed=10

# AdaSTaR (stochastic variant)
python iteration_train.py --config=configs/arc_challenge.json --method=adastar_new --seed=10
```

## Key packages (all satisfied by base vllm env + extras above)

| Package        | Version      | Source       |
|----------------|--------------|--------------|
| torch          | 2.9.1+cu128  | vllm env     |
| transformers   | 4.57.6       | vllm env     |
| trl            | 0.29.0       | vllm env     |
| peft           | 0.18.1       | vllm env     |
| accelerate     | 1.13.0       | vllm env     |
| flash_attn     | 2.8.3        | prebuilt whl |
| jsonlines      | latest       | pip          |
| lm_dataformat  | latest       | pip          |
| optimum        | latest       | pip          |
| gdown          | latest       | pip          |

## Verify

```bash
apptainer exec --nv ~/images/cuda-custom-amal_latest.sif /dev/shm/vllm/bin/python -c "
import torch, transformers, trl, peft, jsonlines, lm_dataformat, optimum, gdown
print('torch:', torch.__version__)
print('transformers:', transformers.__version__)
print('all ok')
"
```
