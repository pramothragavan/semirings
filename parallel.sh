#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    echo "No Nr*(…) arguments supplied. Nothing to do." >&2
    exit 1
fi

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
cd "$SCRIPT_DIR" || exit 1

cleanup() {
    rm -f parallel/{structure.txt,temp_struct.txt,cores.txt}
    rm -rf parallel/{results,logs,runs,pid}
}

trap cleanup INT TERM
trap cleanup EXIT

: > parallel/structure.txt
orig_tokens=()

: > parallel/structure.txt
orig_tokens=()

for tok in "$@"; do
    if [[ "$tok" =~ ^NrSemiringsWithX[[:space:]]*\([[:space:]]*([0-9]+)[[:space:]]*,[[:space:]]*(\[[^][]*\])[[:space:]]*,[[:space:]]*(\[[^][]*\])[[:space:]]*(,[[:space:]]*(true|false))?[[:space:]]*\)$ ]]; then
        n=${BASH_REMATCH[1]}
        structA=${BASH_REMATCH[2]}
        structM=${BASH_REMATCH[3]}
        flag=${BASH_REMATCH[5]:-false}

        printf '[%s,true,Concatenation([IsCommutative, true], %s),%s,%s]\n' \
               "$n" "$structA" "$structM" "$flag" >> parallel/structure.txt
        orig_tokens+=( "$tok" )
        continue

    elif [[ "$tok" =~ ^Nr([A-Za-z0-9_]+)\([[:space:]]*([0-9]+)[[:space:]]*(,[[:space:]]*(true|false))?[[:space:]]*\)$ ]]; then
        category=${BASH_REMATCH[1]}
        n=${BASH_REMATCH[2]}
        flag=${BASH_REMATCH[4]:-false}

        printf 'Concatenation([%s, true], SEMIRINGS_STRUCTURE_REC.("%s"), [%s])\n' \
               "$n" "$category" "$flag" >> parallel/structure.txt
    else
        echo "Ignoring unrecognised token: $tok"
    fi

    orig_tokens+=( "$tok" )
done


[[ -s parallel/structure.txt ]] || {
    echo "No valid Nr*(…) arguments parsed; aborting." >&2
    exit 1
}

SEMIRINGS_CORES="${SEMIRINGS_CORES:-$(getconf _NPROCESSORS_ONLN)}"
export SEMIRINGS_CORES
echo "Using $SEMIRINGS_CORES cores"

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
    pids+=("${pid}")
}

idx=0
while IFS= read -r structure || [[ -n $structure ]]; do
    printf '%s\n' "${structure}" > "parallel/temp_struct.txt"

    gap -q "parallel/distribute.g"

    pids=()
    for ((i=1; i<=SEMIRINGS_CORES; i++)); do
        run_forjoe "${i}"
        sleep 0.2
    done

    printf '%s\n' "Running processes concurrently, logs available @ semirings/parallel/logs"

    for pid in "${pids[@]}"; do
        wait "${pid}"
    done

    total=0
    for f in "parallel"/results/result_*.txt; do
        [[ -s $f ]] && total=$(( total + $(<"$f") ))
    done

    label=${orig_tokens[$idx]}
    ((idx++))

    printf '%s\n' '----------------------------------------------------------------------'
    printf '%s\n' "${label} = ${total}"
    printf '%s\n' '----------------------------------------------------------------------'

    rm -f "parallel"/results/result_*.txt
done < "parallel/structure.txt"