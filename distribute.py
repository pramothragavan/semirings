def distribute_to_piles(mapA, totals, p):
    n = len(mapA)
    weights = [totals[m - 1] for m in mapA]  # 0-index
    items = sorted([(w, i) for i, w in enumerate(weights)], key=lambda x: -x[0])
    piles = [(0, []) for _ in range(p)]
    assignment = [None] * n

    print(len(items))
    for weight, idx in items:
        if idx % 100000 == 0:
            print(idx)
        pile_index = min(range(p), key=lambda j: piles[j][0])
        current_sum, indices = piles[pile_index]
        piles[pile_index] = (current_sum + weight, indices + [idx])
        assignment[idx] = pile_index

    return assignment

import ast
with open('mapA.txt', 'r') as file:
    mapA = ast.literal_eval(file.read().strip())

with open('totals.txt', 'r') as file:
    totals = ast.literal_eval(file.read().strip())

p = 10
assignment = distribute_to_piles(mapA, totals, p)

piles_lists = [[] for _ in range(p)]
for idx, pile in enumerate(assignment):
    piles_lists[pile].append(idx + 1)

import json
with open('cores.txt', 'w') as file:
    json.dump(piles_lists, file)

print("Data successfully written to cores.txt")

weights = [totals[m - 1] for m in mapA]
pile_sums = [0] * p
for i, pile in enumerate(assignment):
    pile_sums[pile] += weights[i]

print("Total weights on each pile:", pile_sums)