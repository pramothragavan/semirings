#!/usr/bin/env python3
def distribute_to_piles(mapM, totals, p):
    n = len(mapM)
    weights = [totals[m - 1] for m in mapM]  # 0-index
    items = sorted([(w, i) for i, w in enumerate(weights)], key=lambda x: -x[0])
    piles = [(0, []) for _ in range(p)]
    assignment = [None] * n

    for i, (weight, idx) in enumerate(items):
        if i > 0 and i % 100000 == 0:
            print(f"{i} completed")
        pile_index = min(range(p), key=lambda j: piles[j][0])
        current_sum, indices = piles[pile_index]
        piles[pile_index] = (current_sum + weight, indices + [idx])
        assignment[idx] = pile_index

    return assignment

import ast, json, pathlib, os
path = str(pathlib.Path(__file__).parent.resolve()) 
with open(path + '/mapM.txt', 'r') as file:
    mapM = ast.literal_eval(file.read().strip())

with open(path + '/totals.txt', 'r') as file:
    totals = ast.literal_eval(file.read().strip())

try:
    p = int(os.getenv("SEMIRINGS_CORES", "0"))
    if p <= 0:
        raise ValueError
except ValueError:
    p = os.cpu_count() or 1

p = min(p, len(mapM))
assignment = distribute_to_piles(mapM, totals, p)

piles_lists = [[] for _ in range(p)]
for idx, pile in enumerate(assignment):
    piles_lists[pile].append(idx + 1)

with open(path + '/cores.txt', 'w') as file: 
    json.dump(piles_lists, file)