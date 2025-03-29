#
# aisemirings: Enumerate/count (ai-)semirings
#
# Implementations
#

# Function to count ai-semirings

BindGlobal("GAPAdditiveIdentityIsMultiplicativeZero",
function(A, M)
  local i, n;
  n := Length(A);
  i := 1;
  while A[i] <> [1 .. n] do
    i := i + 1;
  od;
  return M[i] = List([1 .. n], x -> i);
end);

BindGlobal("CountFinder",
function(allA, allM, mapA, mapM, shift, cosetReps, IsRig)
  local A, M, reps, sigma, j, i, count, tmp, keyM, keyA, completed,
  total, totals;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  count  := 0;
  tmp    := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);
  totals := List(cosetReps, row -> List(row, Length));

  total := 0;
  for i in [1 .. Length(allA)] do
    for j in [1 .. Length(allM)] do
      if j <= Length(mapM) then
        total := total + totals[mapA[i]][mapM[j]];
      else
        total := total + totals[mapA[i]][mapM[j - shift]];
      fi;
    od;
  od;
  Unbind(totals);

  i         := 0;
  completed := 0;

  for A in allA do
    keyA := mapA[i + 1];
    j    := 0;
    Info(InfoSemirings, 1, "At ", String(Float((completed) * 100 / (total))),
    "%, found ", count, " so far");

    for M in allM do
      j    := j + 1;

      if j <= Length(allM) - shift then
        keyM := mapM[j];
      else
        keyM := mapM[j - shift];
      fi;

      reps      := cosetReps[keyA][keyM];
      completed := completed + Length(reps);

      for sigma in reps do
        PermuteMultiplicationTable(tmp, M, sigma);
        if IsLeftRightDistributive(A, tmp) then
          if IsRig then
            if GAPAdditiveIdentityIsMultiplicativeZero(A, tmp) then
              count := count + 1;
            fi;
          else
            count := count + 1;
          fi;
        fi;
      od;
    od;
    i := i + 1;
  od;
  Info(InfoSemirings, 1, "At 100%, found ", count);
  return count;
end);

# Function to find ai-semirings
BindGlobal("Finder",
function(allA, allM, mapA, mapM, shift, cosetReps, IsRig)
  local A, list, M, reps, sigma, j, i, totals,
  tmp, temp_table, keyA, keyM, completed, total;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  list         := [];
  temp_table   := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);
  totals       := List(cosetReps, row -> List(row, Length));

  total := 0;
  for i in [1 .. Length(allA)] do
    for j in [1 .. Length(allM)] do
      if j <= Length(mapM) then
        total := total + totals[mapA[i]][mapM[j]];
      else
        total := total + totals[mapA[i]][mapM[j - shift]];
      fi;
    od;
  od;
  Unbind(totals);

  i         := 0;
  completed := 0;

  for A in allA do
    keyA := mapA[i + 1];
    j    := 0;
    tmp  := [];
    Info(InfoSemirings, 1, "At ", String(Float((completed) * 100 / (total))),
         "%, found ", Length(list), " so far");

    for M in allM do
      j    := j + 1;

      if j <= Length(allM) - shift then
        keyM := mapM[j];
      else
        keyM := mapM[j - shift];
      fi;

      reps      := cosetReps[keyA][keyM];
      completed := completed + Length(reps);

      for sigma in reps do
        PermuteMultiplicationTable(temp_table, M, sigma);
        if IsLeftRightDistributive(A, temp_table) then
          if IsRig then
            if GAPAdditiveIdentityIsMultiplicativeZero(A, M) then
              AddSet(tmp, List(temp_table, ShallowCopy));
            fi;
          else
            AddSet(tmp, List(temp_table, ShallowCopy));
          fi;
        fi;
      od;
    od;
    i    := i + 1;
    UniteSet(list, List(tmp, x -> [A, x]));
  od;
  Info(InfoSemirings, 1, "At 100%, found ", Length(list));
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
function(n, flag, structA, structM, IsRig, args...)
  local allA, allM, NSD, anti, SD, autM, out, mapA, mapM,
  uniqueAutMs, shift, i, autA, uniqueAutAs, reps, j;

  allA := CallFuncList(AllSmallSemigroups, Concatenation([n], structA));
  if Length(args) > 0 then
    allA := List(args[1], i -> allA[i]);
  fi;
  Info(InfoSemirings, 1, "Found ", Length(allA), " candidates for A!");

  Info(InfoSemirings, 1, "Finding non-self-dual semigroups...");
  NSD := CallFuncList(AllSmallSemigroups,
                      Concatenation([n, IsSelfDualSemigroup, false],
                                     structM));
  shift := Length(NSD);

  Info(InfoSemirings, 1, "Finding corresponding dual semigroups...");
  anti := List([1 .. Length(NSD)],
              x -> TransposedMat(NSD[x]!.MultiplicationTable));

  Info(InfoSemirings, 1, "Adding in self-dual semigroups...");
  SD := CallFuncList(AllSmallSemigroups,
                     Concatenation([n, IsSelfDualSemigroup, true],
                                    structM));

  allM := Concatenation(SD, NSD);
  Info(InfoSemirings, 1, "Found ", Length(SD) + Length(NSD) * 2,
       " candidates for M!");
  Unbind(NSD);
  Unbind(SD);
  CollectGarbage(true);

  Info(InfoSemirings, 1, "Finding automorphism groups...");
  out         := UniqueAutomorphismGroups(allM);
  uniqueAutMs := out[1];
  mapM        := out[2];
  allM        := List(allM, x -> x!.MultiplicationTable);

  out         := UniqueAutomorphismGroups(allA);
  uniqueAutAs := out[1];
  mapA        := out[2];
  allA        := List(allA, x -> x!.MultiplicationTable);

  Info(InfoSemirings, 1, "Found ", Length(uniqueAutAs),
       " unique automorphism groups for A!");
  Info(InfoSemirings, 1, "Found ", Length(uniqueAutMs),
       " unique automorphism groups for M!");

  Info(InfoSemirings, 1, "Finding double coset reps...");
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

  Info(InfoSemirings, 1, "Unbinding variables and collecting garbage...");
  allM := Concatenation(allM, anti);

  Unbind(anti);
  Unbind(uniqueAutMs);
  Unbind(uniqueAutAs);
  Unbind(out);
  CollectGarbage(true);

  if flag then
    Info(InfoSemirings, 1, "Counting...");
    return CountFinder(allA, allM, mapA, mapM, shift, reps, IsRig);
  else
    Info(InfoSemirings, 1, "Enumerating...");
    return Finder(allA, allM, mapA, mapM, shift, reps, IsRig);
  fi;
end);

# Breakdown of parameters:
# n:        order of the semiring
# flag:     true for counting, false for enumerating
# structA:  constraints on A as a semigroup
# structM:  constraints on M as a semigroup
# IsRig:    true if we need to check that the additive identity
#           is a multiplicative zero

# up to n = 4 available at
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings
InstallGlobalFunction(NrAiSemirings,
            n -> SETUPFINDER(n, true,
                            [IsBand, true, IsCommutative, true],
                            [],
                            false));

InstallGlobalFunction(AllAiSemirings,
            n -> SETUPFINDER(n, false,
                            [IsBand, true, IsCommutative, true],
                            [],
                            false));

# we define rings as having a multiplicative identity
InstallGlobalFunction(NrRings,  # A037291
            n -> SETUPFINDER(n, true,
                            [IsGroupAsSemigroup, true, IsCommutative, true],
                            [IsMonoidAsSemigroup, true],
                            false));

InstallGlobalFunction(AllRings,
            n -> SETUPFINDER(n, false,
                            [IsGroupAsSemigroup, true, IsCommutative, true],
                            [IsMonoidAsSemigroup, true],
                            false));

InstallGlobalFunction(NrRngs,  # A027623
            n -> SETUPFINDER(n, true,
                            [IsGroupAsSemigroup, true, IsCommutative, true],
                            [],
                            false));

InstallGlobalFunction(AllRngs,
            n -> SETUPFINDER(n, false,
                            [IsGroupAsSemigroup, true, IsCommutative, true],
                            [],
                            false));

# up to n = 4 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings
InstallGlobalFunction(NrSemirings,
            n -> SETUPFINDER(n, true,
                            [IsCommutative, true],
                            [],
                            false));

InstallGlobalFunction(AllSemirings,
            n -> SETUPFINDER(n, false,
                            [IsCommutative, true],
                            [],
                            false));

# rings without requirement for negatives
# often referred to as a semiring in literature
# up to n = 6 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_identity_and_zero
InstallGlobalFunction(NrRigs,
            n -> SETUPFINDER(n, true,
                [IsCommutative, true, IsMonoidAsSemigroup, true],
                [IsMonoidAsSemigroup, true, IsSemigroupWithZero, true],
                true));

InstallGlobalFunction(AllRigs,
            n -> SETUPFINDER(n, false,
                [IsCommutative, true, IsMonoidAsSemigroup, true],
                [IsMonoidAsSemigroup, true, IsSemigroupWithZero, true],
                true));

# up to n = 7 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings_with_identity_and_zero
InstallGlobalFunction(NrAiRigs,
            n -> SETUPFINDER(n, true,
                [IsBand, true, IsCommutative, true, IsMonoidAsSemigroup, true],
                [IsMonoidAsSemigroup, true, IsSemigroupWithZero, true],
                true));

InstallGlobalFunction(AllAiRigs,
            n -> SETUPFINDER(n, false,
                [IsBand, true, IsCommutative, true, IsMonoidAsSemigroup, true],
                [IsMonoidAsSemigroup, true, IsSemigroupWithZero, true],
                true));

# rings without requirement for negatives or multiplicative identity
# up to n = 4 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_zero
InstallGlobalFunction(NrRgs,
            n -> SETUPFINDER(n, true,
                [IsCommutative, true, IsMonoidAsSemigroup, true],
                [IsSemigroupWithZero, true],
                true));

InstallGlobalFunction(AllRgs,
            n -> SETUPFINDER(n, false,
                [IsCommutative, true, IsMonoidAsSemigroup, true],
                [IsSemigroupWithZero, true],
                true));

# up to n = 5 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings_with_zero
InstallGlobalFunction(NrAiRgs,
            n -> SETUPFINDER(n, true,
                [IsBand, true, IsCommutative, true, IsMonoidAsSemigroup, true],
                [IsSemigroupWithZero, true],
                true));

InstallGlobalFunction(AllAiRgs,
            n -> SETUPFINDER(n, false,
                [IsBand, true, IsCommutative, true, IsMonoidAsSemigroup, true],
                [IsSemigroupWithZero, true],
                true));

# up to n = 5 available here:
# (page seems to be incorrectly named)
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_identity
InstallGlobalFunction(NrAiSemiringsWithOne,
            n -> SETUPFINDER(n, true,
                [IsBand, true, IsCommutative, true],
                [IsMonoidAsSemigroup, true],
                false));

InstallGlobalFunction(AllAiSemiringsWithOne,
            n -> SETUPFINDER(n, false,
                [IsBand, true, IsCommutative, true],
                [IsMonoidAsSemigroup, true],
                false));

InstallGlobalFunction(NrSemiringsWithOne,
            n -> SETUPFINDER(n, true,
                [IsCommutative, true],
                [IsMonoidAsSemigroup, true],
                false));

InstallGlobalFunction(AllSemiringsWithOne,
            n -> SETUPFINDER(n, false,
                [IsCommutative, true],
                [IsMonoidAsSemigroup, true],
                false));