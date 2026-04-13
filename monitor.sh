#!/bin/bash
# Overnight monitor: checks for errors and updates results
LOG_DIR=~/workspace/adastar
NOTES=~/workspace/adastar/notes/results.md

collect_result() {
    local task=$1 exp=$2
    local f="${LOG_DIR}/${task}/${exp}/eval_log.json"
    if [ -f "$f" ]; then
        python3 -c "
import json
data = json.load(open('$f'))
dev = [x for x in data if x.get('split')=='dev']
if dev:
    last = dev[-1]
    print(f\"  iter={last['iter']} acc={last['accuracy']*100:.1f}%\")
else:
    print('  (no dev eval yet)')
" 2>/dev/null
    else
        echo "  (not started)"
    fi
}

check_errors() {
    local logfile=$1
    if [ -f "$logfile" ]; then
        tail -c 2000 "$logfile" | tr '\r' '\n' | grep -E "Error|Traceback|FAILED" | grep -v "UserWarning\|FutureWarning\|DeprecationWarning" | tail -3
    fi
}

while true; do
    echo "======== [$(date)] ========"
    
    echo "=== CURRENT JOB ==="
    tmux capture-pane -t job:0.0 -p -S -3 2>&1 | tail -3
    
    echo "=== RESULTS ==="
    echo "GSM8K/Qwen:  $(collect_result gsm8k gsm8k_qwen_adastar_new_square_10)"
    echo "GSM8K/Llama: $(collect_result gsm8k gsm8k_adastar_new_square_10)"
    echo "SVAMP/Llama: $(collect_result svamp svamp_adastar_new_square_10)"
    echo "SVAMP/Qwen:  $(collect_result svamp svamp_qwen_adastar_new_square_10)"
    echo "SVAMP/Gemma: $(collect_result svamp svamp7b_adastar_new_square_10)"
    echo "ARC/Llama:   $(collect_result arc_challenge arc_challenge_adastar_new_square_10)"
    echo "ARC/Qwen:    $(collect_result arc_challenge arc_challenge_qwen_adastar_new_square_10)"
    echo "ARC/Gemma:   $(collect_result arc_challenge arc_challenge7b_adastar_new_square_10)"
    
    echo "=== ERRORS CHECK ==="
    for log in train_gsm8k_llama_seed10.log train_svamp_llama_seed10.log train_svamp_qwen_seed10.log train_arc_llama_seed10.log; do
        errs=$(check_errors "$LOG_DIR/$log")
        if [ -n "$errs" ]; then
            echo "⚠️  $log: $errs"
        fi
    done
    echo "(no new errors)" 
    
    sleep 300  # Check every 5 minutes
done
