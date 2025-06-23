#!/usr/bin/env bash

CORES=10

for d in results logs runs pid; do
    dir="parallel/${d}"
    mkdir -p "$dir"
    rm -f -- "$dir"/*
done

run_forjoe() {
    local i=$1
    local gap_script="parallel/runs/run_${i}.g"

    cat > "${gap_script}" << EOF
LoadPackage("semigroups");
LoadPackage("smallsemi");
LoadPackage("semirings");

flag := false;
file := InputTextFile(Concatenation(GAPInfo.PackagesLoaded.semirings[1],
                                    "parallel/cores.txt"));
cores := EvalString(ReadLine(file));
CloseStream(file);

if ${i} > Length(cores) then
    PrintTo("parallel/results/result_${i}.txt", 0);
    Info(InfoSemirings, 1, "Not enough processes to warrant using core ${i}");
    flag := true;
else
    cores := cores[${i}];
fi;

if not flag then
    file := InputTextFile("parallel/temp_struct.txt");
    structure := EvalString(ReadLine(file));
    CloseStream(file);

    result := CallFuncList(SETUPFINDER, Concatenation(structure, [cores]));
    PrintTo("parallel/results/result_${i}.txt", result);
fi;

Print("\\nTime taken: ", Float(Runtimes().user_time) / 3600000, " hours\\n");
quit;
EOF

    gap -q "${gap_script}" > "parallel/logs/${i}.log" 2>&1 &
    local pid=$!
    printf 'Process %02d, PID %d (log %s)\n' \
           "${i}" "${pid}" "parallel/logs/${i}.log"
    pids+=("${pid}")
}

while IFS= read -r structure || [[ -n $structure ]]; do
    printf '%s\n' "${structure}" > "parallel/temp_struct.txt"

    gap -q "parallel/distribute.g"

    pids=()
    for ((i=1; i<=CORES; i++)); do
        run_forjoe "${i}"
        sleep 0.2
    done

    for pid in "${pids[@]}"; do
        wait "${pid}"
    done

    total=0
    for f in "parallel"/results/result_*.txt; do
        [[ -s $f ]] && total=$(( total + $(<"$f") ))
    done

    printf '%s\n' '----------------------------------------------------------------------'
    printf '%s\n' "RESULT for structure ${structure}"
    printf '%s\n\n' "Total = ${total}"

    rm -f "parallel"/results/result_*.txt
done < "parallel/structure.txt"

for d in results logs runs pid; do
    rm -rf  "parallel/${d}"
done

rm -f "parallel/temp_struct.txt"
rm -f "parallel/cores.txt"