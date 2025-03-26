#!/bin/bash

mkdir -p parallel/results
mkdir -p parallel/logs
mkdir -p parallel/runs
mkdir -p parallel/pid

rm -rf parallel/logs/*

if [ ! -f "parallel/cores.txt" ]; then
    echo "cores.txt not found. Generating partition from structure.txt..."
    
    gap -q parallel/distribute.g
    touch parallel/gen
fi

run_forjoe() {
    local i=$1
    
    cat > "parallel/runs/run_$i.g" << EOF
LoadPackage("semigroups");
LoadPackage("smallsemi");
LoadPackage("aisemirings");
flag := false;
file := InputTextFile(Concatenation(GAPInfo.PackagesLoaded.aisemirings[1], "parallel/cores.txt"));
line := ReadLine(file);
CloseStream(file);
cores := EvalString(line);
if $i > Length(cores) then
    PrintTo("parallel/results/result_$i.txt", 0);
    Info(InfoSemirings, 1, "Not enough processes to warrant using core $i");
    flag := true;
else
    cores := cores[$i];
fi;
if not flag then
    file := InputTextFile(Concatenation(GAPInfo.PackagesLoaded.aisemirings[1], "parallel/structure.txt"));
    structure := EvalString(ReadLine(file));
    CloseStream(file);
    result := CallFuncList(SETUPFINDER, Concatenation(structure, [cores]));
    PrintTo("parallel/results/result_$i.txt", result);
fi;
Print(Runtimes());
quit;
EOF
    
    gap -q parallel/runs/run_$i.g > "parallel/logs/$i.log" 2>&1 &
    
    echo $! > "parallel/pid/pid_$i.txt"
    echo "Process $i started with PID $(cat parallel/pid/pid_$i.txt). Output @ parallel/logs/$i.log"
}

for i in {1..10}; do
    run_forjoe $i
    sleep 1
done

echo "Waiting for all processes to complete..."
for i in {1..10}; do
    if [ -f "parallel/pid/pid_$i.txt" ]; then
        pid=$(cat "parallel/pid/pid_$i.txt")
        wait $pid 2>/dev/null
        echo "Process $i completed"
    fi
done

total=0
for i in {1..10}; do
    if [ -f "parallel/results/result_$i.txt" ]; then
        result=$(cat "parallel/results/result_$i.txt")
        total=$((total + result))
    else
        echo "ERROR: parallel/results/result_$i.txt not found"
    fi
done

echo "----------------------------------------------------------------------"
structure=$(cat parallel/structure.txt)
echo "RESULT for structure $structure"
echo "Total = $total"
echo "----------------------------------------------------------------------"

rm -rf parallel/runs
rm -rf parallel/pid
rm -rf parallel/results

if [ -f "parallel/gen" ]; then
    rm -f parallel/cores.txt
    rm -f parallel/gen
fi