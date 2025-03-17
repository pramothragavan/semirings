#
# aisemirings: Enumerate/count (ai-)semirings
#
# Implementations
#

# Function to count ai-semirings
BindGlobal("CountFinder",
function(allA, allM, autMs, map, shift)
  local A, AA, autA, M, autM, reps, sigma, j, i,
  doubleCosetCache, value, count, gens, tmp;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  i     := 0;
  count := 0;
  tmp   := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);

  for A in allA do
    AA   := MultiplicationTable(A);
    autA := AutomorphismGroup(A);
    autA := Image(IsomorphismPermGroup(autA));

    j                := 0;
    doubleCosetCache := HashMap();

    for M in allM do
      j    := j + 1;
      PrintFormatted("At {}%, found {} so far\r\c",
                Float((i * Length(allM) + j) * 100 /
                (Length(allA) * Length(allM))),
                count);

      if j <= Length(allM) - shift then
        autM := autMs[map[j]];
      else
        autM := autMs[map[j - shift]];
      fi;

      M    := M!.MultiplicationTable;
      gens := GeneratorsSmallest(autM);

      value := doubleCosetCache[gens];
      if value <> fail then
        reps := value;
      else
        # Compute double coset reps: Aut(A)\S_n/Aut(M)
        reps := DoubleCosetRepsAndSizes(SymmetricGroup(Size(A)),
                                        autM, autA);
        reps                   := List(reps, x -> x[1]);
        doubleCosetCache[gens] := reps;
      fi;

      for sigma in reps do
        PermuteMultiplicationTable(tmp, M, sigma);
        if IsLeftRightDistributive(AA, tmp) then
          count := count + 1;
        fi;
      od;
    od;
    i    := i + 1;
  od;
    PrintFormatted("\nFound {} candidates!\n", count);
  return count;
end);

# Function to find ai-semirings
BindGlobal("Finder",
function(allA, allM, autMs, map, shift)
  local A, AA, autA, list, M, autM, reps, sigma, j, i,
  temp, doubleCosetCache, value, gens, temp_table;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  list         := [];
  i            := 0;
  temp_table   := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);

  for A in allA do
    AA   := MultiplicationTable(A);
    autA := AutomorphismGroup(A);
    autA := Image(IsomorphismPermGroup(autA));

    j                := 0;
    temp             := [];
    doubleCosetCache := HashMap();

    for M in allM do
      j    := j + 1;
      PrintFormatted("At {}%, found {} so far\r\c",
                Float((i * Length(allM) + j) * 100 /
                (Length(allA) * Length(allM))),
                Length(list) + Length(temp));

      if j <= Length(allM) - shift then
        autM := autMs[map[j]];
      else
        autM := autMs[map[j - shift]];
      fi;

      M    := M!.MultiplicationTable;
      gens := GeneratorsSmallest(autM);

      value := doubleCosetCache[gens];
      if value <> fail then
        reps := value;
      else
        # Compute double coset reps: Aut(A)\S_n/Aut(M)
        reps := DoubleCosetRepsAndSizes(SymmetricGroup(Size(A)),
                                        autM, autA);
        reps                   := List(reps, x -> x[1]);
        doubleCosetCache[gens] := reps;
      fi;

      for sigma in reps do
        PermuteMultiplicationTable(temp_table, M, sigma);
        if IsLeftRightDistributive(AA, temp_table) then
          AddSet(temp, List(temp_table, ShallowCopy));
        fi;
      od;
    od;
    i    := i + 1;
    temp := List(temp, x -> [AA, x]);
    UniteSet(list, temp);
  od;
    PrintFormatted("\nFound {} candidates!\n", Length(list));
  return list;
end);

BindGlobal("SETUPFINDER",
function(n, flag, structA, structM)
  local allA, allM, NSD, anti, SD, autM, pos,
  uniqueAutMs, map, shift, sg, i;

  allA := CallFuncList(AllSmallSemigroups, Concatenation([n], structA));
  PrintFormatted("Found {} candidates for A!\n", Length(allA));

  Print("Finding non-self-dual semigroups...\n");
  NSD      := CallFuncList(AllSmallSemigroups,
                           Concatenation([n, IsSelfDualSemigroup, false],
                                          structM));
  shift    := Length(NSD);

  Print("Finding corresponding dual semigroups...\n");
  anti   := List(NSD, DualSemigroup);

  for sg in anti do
    sg!.MultiplicationTable :=
      TransposedMat(sg!.DualSemigroup!.MultiplicationTable);
  od;

  Print("Adding in self-dual semigroups...\n");
  SD   := CallFuncList(AllSmallSemigroups,
                          Concatenation([n, IsSelfDualSemigroup, true],
                                         structM));

  allM        := Concatenation(SD, NSD);
  PrintFormatted("Found {} candidates for M!\n", Length(SD) + Length(NSD) * 2);

  uniqueAutMs := [];
  map         := List([1 .. Length(allM)], ReturnFail);

  Print("Finding automorphism groups...\n");
  for i in [1 .. Length(allM)] do
    autM := Image(IsomorphismPermGroup(AutomorphismGroup(allM[i])));
    pos  := Position(uniqueAutMs, autM);
    if pos = fail then
      Add(uniqueAutMs, autM);
      map[i] := Length(uniqueAutMs);
    else
      map[i] := pos;
    fi;
    Unbind(allM[i]!.AutomorphismGroup);
  od;

  PrintFormatted("Found {} unique automorphism groups!\n", Length(uniqueAutMs));
  Print("Unbinding variables and collecting garbage...\n");

  for sg in NSD do
    Unbind(sg!.DualSemigroup);
  od;

  allM := Concatenation(allM, anti);

  Unbind(NSD);
  Unbind(anti);
  Unbind(SD);
  CollectGarbage(true);

  if flag then
    Print("Counting ai-semirings...\n");
    return CountFinder(allA, allM, uniqueAutMs, map, shift);
  else
    Print("Finding ai-semirings...\n");
    return Finder(allA, allM, uniqueAutMs, map, shift);
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