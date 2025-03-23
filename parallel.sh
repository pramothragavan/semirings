#!/bin/bash

mkdir -p results
mkdir -p logs
mkdir -p runs
mkdir -p pid

run_forjoe() {
    local i=$1
    echo "Starting ForJoe($i) in the background..."
    
    cat > "runs/run_$i.g" << EOF
LoadPackage("aisemirings");
result := ForJoe($i);
PrintTo("results/result_$i.txt", result);
quit;
EOF
    
    gap -q runs/run_$i.g > "logs/forjoe_$i.log" 2>&1 &
    
    echo $! > "pid/pid_$i.txt"
    echo "ForJoe($i) started with PID $(cat pid/pid_$i.txt). Output logged to logs/forjoe_$i.log"
}

for i in {1..10}; do
    run_forjoe $i
    sleep 1
done

echo "Waiting for all processes to complete..."
for i in {1..10}; do
    if [ -f "pid/pid_$i.txt" ]; then
        pid=$(cat "pid/pid_$i.txt")
        wait $pid 2>/dev/null
        echo "ForJoe($i) completed"
    fi
done

total=0
echo "----------------------------------------------------------------------"
for i in {1..10}; do
    if [ -f "results/result_$i.txt" ]; then
        result=$(cat "results/result_$i.txt")
        total=$((total + result))
    else
        echo "ERROR: results/result_$i.txt not found for ForJoe($i)"
    fi
done

echo "----------------------------------------------------------------------"
echo "Total: $total"

rm -f runs/run_*.g
rm -f pid/pid_*.txt
rm -rf results
rm -rf logs
rm -rf runs
rm -rf pid