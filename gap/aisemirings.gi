#
# aisemirings: Enumerate/count (ai-)semirings
#
# Implementations
#

# Function to count ai-semirings

BindGlobal("GAPAdditiveIdentityIsMultiplicativeZero",
function(A, M, idList, constLists)
  local i;
  i := 1;
  while A[i] <> idList do
    i := i + 1;
  od;
  return M[i] = constLists[i];
end);

BindGlobal("CountFinder",
function(allA, allM, mapA, mapM, shift, cosetReps, IsRig)
  local A, M, reps, sigma, j, i, count, tmp, keyM, keyA, completed,
  total, totals, R1, R2;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  count  := 0;
  tmp    := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);
  totals := List(cosetReps, row -> List(row, Length));
  if IsRig then
    R1   := [1 .. Size(allA[1])];
    R2   := List([1 .. Size(allA[1])],
                        i -> List([1 .. Size(allA[1])], x -> i));
  fi;

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

      if j > Length(mapM) then
        keyM := mapM[j - shift];
      else
        keyM := mapM[j];
      fi;

      reps      := cosetReps[keyA][keyM];
      completed := completed + Length(reps);

      for sigma in reps do
        PermuteMultiplicationTableNC(tmp, M, sigma);
        if IsLeftRightDistributive(A, tmp) then
          if IsRig then
            if AdditiveIdentityIsMultiplicativeZero(A, tmp, R1, R2) then
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
  local A, list, M, reps, sigma, j, i, totals, R1, R2,
  tmp, temp_table, keyA, keyM, completed, total;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  list         := [];
  temp_table   := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);
  totals       := List(cosetReps, row -> List(row, Length));
  if IsRig then
    R1      := [1 .. Size(allA[1])];
    R2      := List([1 .. Size(allA[1])],
                        i -> List([1 .. Size(allA[1])], x -> i));
  fi;

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

      if j > Length(mapM) then
        keyM := mapM[j - shift];
      else
        keyM := mapM[j];
      fi;

      reps      := cosetReps[keyA][keyM];
      completed := completed + Length(reps);

      for sigma in reps do
        PermuteMultiplicationTableNC(temp_table, M, sigma);
        if IsLeftRightDistributive(A, temp_table) then
          if IsRig then
            if AdditiveIdentityIsMultiplicativeZero(A, temp_table, R1, R2) then
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
    if IsDualSemigroupRep(all[i]) then
      if IsBound(all[i]!.DualSemigroup!.map) then
        map[i] := all[i]!.DualSemigroup!.map;
        continue;
      else
        aut := Image(IsomorphismPermGroup(
                    AutomorphismGroup(all[i]!.DualSemigroup)));
      fi;
      Unbind(all[i]!.DualSemigroup!.AutomorphismGroup);
    else
      aut  := Image(IsomorphismPermGroup(AutomorphismGroup(all[i])));
      Unbind(all[i]!.AutomorphismGroup);
    fi;
    pos  := Position(uniqueAuts, aut);
    if pos = fail then
      Add(uniqueAuts, aut);
      map[i]      := Length(uniqueAuts);
      all[i]!.map := Length(uniqueAuts);
    else
      map[i]      := pos;
      all[i]!.map := pos;
    fi;
  od;
  return [uniqueAuts, map];
end);

BindGlobal("SETUPFINDER",
function(n, flag, structA, structM, IsRig, args...)
  local allA, allM, NSD, anti, SD, autM, out, mapA, mapM,
  uniqueAutMs, shift, i, autA, uniqueAutAs, reps, j, sg;

  allA := CallFuncList(AllSmallSemigroups, Concatenation([n], structA));
  Info(InfoSemirings, 1, "Found ", Length(allA), " candidates for A!");

  Info(InfoSemirings, 1, "Finding non-self-dual semigroups...");
  NSD := CallFuncList(AllSmallSemigroups,
                      Concatenation([n, IsSelfDualSemigroup, false],
                                     structM));
  shift := Length(NSD);

  Info(InfoSemirings, 1, "Finding corresponding dual semigroups...");
  if Length(args) > 0 then
    anti := List(NSD, DualSemigroup);
    for sg in anti do
      sg!.MultiplicationTable :=
            TransposedMat(sg!.DualSemigroup!.MultiplicationTable);
    od;
  else
    anti := List([1 .. Length(NSD)],
                 i -> TransposedMat(NSD[i]!.MultiplicationTable));
  fi;

  Info(InfoSemirings, 1, "Adding in self-dual semigroups...");
  SD := CallFuncList(AllSmallSemigroups,
                     Concatenation([n, IsSelfDualSemigroup, true],
                                    structM));

  allM := Concatenation(SD, NSD);

  if Length(args) > 0 then
    allM := Concatenation(allM, anti);
    allM := List(args[1], i -> allM[i]);
    Info(InfoSemirings, 1, "Found ", Length(allM),
        " candidates for M!");
    Unbind(anti);
  else
    Info(InfoSemirings, 1, "Found ", Length(SD) + Length(NSD) * 2,
         " candidates for M!");
  fi;
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
  if Length(args) = 0 then
    allM := Concatenation(allM, anti);
    Unbind(anti);
  fi;

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

BindGlobal("SEMIRINGS_STRUCTURE_REC",
rec(
# up to n = 4 available at
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings
  AiSemirings      := [[IsBand, true, IsCommutative, true],
                          [],
                          false],

# A037291
  Rings              := [[IsGroupAsSemigroup, true, IsCommutative, true],
                          [IsMonoidAsSemigroup, true],
                          false],

# A027623
  Rngs               := [[IsGroupAsSemigroup, true, IsCommutative, true],
                          [],
                          false],

# up to n = 4 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings
  Semirings          := [[IsCommutative, true],
                          [],
                          false],

# rings without requirement for negatives
# often referred to as a semiring in literature
# up to n = 6 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_identity_and_zero
  Rigs               := [[IsCommutative, true, IsMonoidAsSemigroup, true],
                          [IsMonoidAsSemigroup, true,
                           IsSemigroupWithZero, true],
                          true],

# up to n = 7 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings_with_identity_and_zero
  AiRigs             := [[IsBand, true, IsCommutative, true,
                          IsMonoidAsSemigroup, true],
                          [IsMonoidAsSemigroup, true,
                           IsSemigroupWithZero, true],
                          true],

# rings without requirement for negatives or multiplicative identity
# up to n = 4 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_zero
  Rgs                := [[IsCommutative, true, IsMonoidAsSemigroup, true],
                          [IsSemigroupWithZero, true],
                          true],

# up to n = 5 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings_with_zero
  AiRgs              := [[IsBand, true, IsCommutative, true,
                          IsMonoidAsSemigroup, true],
                          [IsSemigroupWithZero, true],
                          true],

# up to n = 5 available here:
# (page seems to be incorrectly named)
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_identity
  AiSemiringsWithOne := [[IsBand, true, IsCommutative, true],
                          [IsMonoidAsSemigroup, true],
                          false],

  SemiringsWithOne   := [[IsCommutative, true],
                          [IsMonoidAsSemigroup, true],
                          false]));

BindGlobal("WRITE_STRUCTURE",
function(f, n)
  local file, out;
  file := IO_CompressedFile(Concatenation(GAPInfo.PackagesLoaded.aisemirings[1],
                        "parallel/structure.txt"), "w");
  out := String(Concatenation([n, true], SEMIRINGS_STRUCTURE_REC.(f)));
  out := ReplacedString(out, "<Property \"", "");
  out := ReplacedString(out, "\">", "");
  IO_Write(file, out);
  Print("Successfully wrote to file.\n");
  IO_Close(file);
end);

for key in RecNames(SEMIRINGS_STRUCTURE_REC) do
  InstallGlobalFunction(ValueGlobal(Concatenation("Nr", key)),
      (function(capturedKey)
         return function(n)
           return CallFuncList(SETUPFINDER,
             Concatenation([n, true], SEMIRINGS_STRUCTURE_REC.(capturedKey)));
         end;
       end)(key));

  InstallGlobalFunction(ValueGlobal(Concatenation("All", key)),
      (function(capturedKey)
         return function(n)
           return CallFuncList(SETUPFINDER,
             Concatenation([n, false], SEMIRINGS_STRUCTURE_REC.(capturedKey)));
         end;
       end)(key));
od;