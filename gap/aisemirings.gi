#
# aisemirings: Enumerate/count (ai-)semirings
#
# Implementations
#

# Function to count ai-semirings
BindGlobal("CountFinder",
function(allA, allM, mapA, mapM, shift, cosetReps)
  local A, M, reps, sigma, j, i, count, tmp, keyM, keyA,
  totalComputations, completedComputations, totals;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  count  := 0;
  tmp    := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);
  totals := List(cosetReps, row -> List(row, Length));

  totalComputations := 0;
  for i in [1 .. Length(allA)] do
    for j in [1 .. Length(allM)] do
      if j <= Length(mapM) then
        totalComputations := totalComputations + totals[mapA[i]][mapM[j]];
      else
        totalComputations := totalComputations +
                             totals[mapA[i]][mapM[j - shift]];
      fi;
    od;
  od;

  i                     := 0;
  completedComputations := 0;

  for A in allA do
    keyA := mapA[i + 1];
    j    := 0;

    for M in allM do
      j    := j + 1;

      if j <= Length(allM) - shift then
        keyM := mapM[j];
      else
        keyM := mapM[j - shift];
      fi;
      reps                  := cosetReps[keyA][keyM];

      completedComputations := completedComputations + totals[keyA][keyM];
      Info(InfoSemirings, 1, "At ", Float((completedComputations) * 100 /
                (totalComputations)), "%, found ", count, " so far");

      for sigma in reps do
        PermuteMultiplicationTable(tmp, M, sigma);
        if IsLeftRightDistributive(A, tmp) then
          count := count + 1;
        fi;
      od;
    od;
    i := i + 1;
  od;
    PrintFormatted("\nFound {} candidates!\n", count);
  return count;
end);

# Function to find ai-semirings
BindGlobal("Finder",
function(allA, allM, mapA, mapM, shift, cosetReps)
  local A, list, M, reps, sigma, j, i, totals,
  tmp, temp_table, keyA, keyM, totalComputations,
  completedComputations;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  list         := [];
  temp_table   := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);
  totals       := List(cosetReps, row -> List(row, Length));

  totalComputations := 0;
  for i in [1 .. Length(allA)] do
    for j in [1 .. Length(allM)] do
      if j <= Length(mapM) then
        totalComputations := totalComputations + totals[mapA[i]][mapM[j]];
      else
        totalComputations := totalComputations +
                             totals[mapA[i]][mapM[j - shift]];
      fi;
    od;
  od;

  i                     := 0;
  completedComputations := 0;

  for A in allA do
    keyA := mapA[i + 1];
    j    := 0;
    tmp  := [];

    for M in allM do
      j    := j + 1;


      if j <= Length(allM) - shift then
        keyM := mapM[j];
      else
        keyM := mapM[j - shift];
      fi;

      reps                  := cosetReps[keyA][keyM];
      completedComputations := completedComputations + totals[keyA][keyM];
      Info(InfoSemirings, 1, "At ", Float((completedComputations) * 100 /
                (totalComputations)), "%, found ", Length(list) + Length(tmp),
                " so far");

      for sigma in reps do
        PermuteMultiplicationTable(temp_table, M, sigma);
        if IsLeftRightDistributive(A, temp_table) then
          AddSet(tmp, List(temp_table, ShallowCopy));
        fi;
      od;
    od;
    i    := i + 1;
    UniteSet(list, List(tmp, x -> [A, x]));
  od;
    PrintFormatted("\nFound {} candidates!\n", Length(list));
  return list;
end);

BindGlobal("UniqueAutomorphismGroups",
function(all)
  local uniqueAuts, map, aut, pos, i;
  uniqueAuts := [];
  map        := List([1 .. Length(all)], ReturnFail);
  for i in [1 .. Length(all)] do
    aut  := Image(IsomorphismPermGroup(AutomorphismGroup(all[i])));
    pos  := Position(uniqueAuts, aut);
    if pos = fail then
      Add(uniqueAuts, aut);
      map[i] := Length(uniqueAuts);
    else
      map[i] := pos;
    fi;
    Unbind(all[i]!.AutomorphismGroup);
  od;
  return [uniqueAuts, map];
end);

BindGlobal("SETUPFINDER",
function(n, flag, structA, structM)
  local allA, allM, NSD, anti, SD, autM, out, mapA, mapM,
  uniqueAutMs, shift, sg, i, autA, uniqueAutAs, reps, j;

  allA := CallFuncList(AllSmallSemigroups, Concatenation([n], structA));
  PrintFormatted("Found {} candidates for A!\n", Length(allA));

  Print("Finding non-self-dual semigroups...\n");
  NSD := CallFuncList(AllSmallSemigroups,
                      Concatenation([n, IsSelfDualSemigroup, false],
                                     structM));
  shift := Length(NSD);

  Print("Finding corresponding dual semigroups...\n");
  anti := List(NSD, DualSemigroup);

  for sg in anti do
    sg!.MultiplicationTable :=
      TransposedMat(sg!.DualSemigroup!.MultiplicationTable);
  od;

  Print("Adding in self-dual semigroups...\n");
  SD := CallFuncList(AllSmallSemigroups,
                     Concatenation([n, IsSelfDualSemigroup, true],
                                    structM));

  allM := Concatenation(SD, NSD);
  PrintFormatted("Found {} candidates for M!\n", Length(SD) + Length(NSD) * 2);

  Print("Finding automorphism groups...\n");
  out         := UniqueAutomorphismGroups(allM);
  uniqueAutMs := out[1];
  mapM        := out[2];

  out         := UniqueAutomorphismGroups(allA);
  uniqueAutAs := out[1];
  mapA        := out[2];

  PrintFormatted("Found {} unique automorphism groups for A!\n",
                 Length(uniqueAutAs));
  PrintFormatted("Found {} unique automorphism groups for M!\n",
                 Length(uniqueAutMs));

  Print("Finding double coset reps...\n");
  reps := List([1 .. Length(uniqueAutAs)],
               x -> List([1 .. Length(uniqueAutMs)]));
  i := 0;
  for autA in uniqueAutAs do
    i := i + 1;
    j := 0;
    for autM in uniqueAutMs do
      j          := j + 1;
      reps[i][j] := List(DoubleCosetRepsAndSizes(
                          SymmetricGroup(n), autM, autA), x -> x[1]);
    od;
  od;

  Print("Unbinding variables and collecting garbage...\n");
  allM := Concatenation(allM, anti);
  allM := List(allM, x -> x!.MultiplicationTable);
  allA := List(allA, x -> x!.MultiplicationTable);

  Unbind(NSD);
  Unbind(anti);
  Unbind(SD);
  Unbind(uniqueAutMs);
  Unbind(uniqueAutAs);
  Unbind(out);
  CollectGarbage(true);

  if flag then
    Print("Counting ai-semirings...\n");
    return CountFinder(allA, allM, mapA, mapM, shift, reps);
  else
    Print("Finding ai-semirings...\n");
    return Finder(allA, allM, mapA, mapM, shift, reps);
  fi;
end);

InstallGlobalFunction(NrAiSemirings,
                      n -> SETUPFINDER(n, true,
                                      [IsBand, true, IsCommutative, true],
                                      []));

InstallGlobalFunction(AllAiSemirings,
                      n -> SETUPFINDER(n, false,
                                      [IsBand, true, IsCommutative, true],
                                      []));

InstallGlobalFunction(NrRingsWithOne,
            n -> SETUPFINDER(n, true,
                            [IsGroupAsSemigroup, true, IsCommutative, true],
                            [IsMonoidAsSemigroup, true]));

InstallGlobalFunction(AllRingsWithOne,
            n -> SETUPFINDER(n, false,
                            [IsGroupAsSemigroup, true, IsCommutative, true],
                            [IsMonoidAsSemigroup, true]));

InstallGlobalFunction(NrRings,
            n -> SETUPFINDER(n, true,
                            [IsGroupAsSemigroup, true, IsCommutative, true],
                            []));

InstallGlobalFunction(AllRings,
            n -> SETUPFINDER(n, false,
                            [IsGroupAsSemigroup, true, IsCommutative, true],
                            []));