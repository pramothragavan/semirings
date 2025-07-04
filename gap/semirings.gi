#
# semirings: Enumerate/count semirings
#
# Implementations
#

BindGlobal("AdditiveIdentityNC",
function(A, idList)
  local i;
  i := 1;
  while A[i] <> idList do
    i := i + 1;
  od;
  return i;
end);

BindGlobal("CountFinder",
function(allA, allM, mapA, mapM, shift, cosetReps, IsRig)
  local A, M, reps, sigma, j, i, count, tmp, keyM, keyA, completed,
  total, totals, idList, constLists, idA;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  count  := 0;
  tmp    := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);
  totals := List(cosetReps, row -> List(row, Length));
  if IsRig then
    idList     := [1 .. Size(allA[1])];
    constLists := List([1 .. Size(allA[1])],
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

    if IsRig then
      idA := AdditiveIdentityNC(A, idList);
    fi;

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
        SEMIRINGSPermuteMultiplicationTable(tmp, M, sigma);
        if IsRig and tmp[idA] <> constLists[idA] then
            continue;
        fi;
        if IsLeftRightDistributive(A, tmp) then
          count := count + 1;
        fi;
      od;
    od;
    i := i + 1;
  od;
  Info(InfoSemirings, 1, "At 100%, found ", count);
  return count;
end);

# Function to find semirings
BindGlobal("Finder",
function(allA, allM, mapA, mapM, shift, cosetReps, isRig)
  local A, list, M, reps, sigma, j, i, totals, idList, constLists,
  tmp, temp_table, keyA, keyM, completed, total, idA;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  list         := [];
  temp_table   := List([1 .. Size(allA[1])], x -> [1 .. Size(allA[1])]);
  totals       := List(cosetReps, row -> List(row, Length));
  if isRig then
    idList     := [1 .. Size(allA[1])];
    constLists := List([1 .. Size(allA[1])],
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

    if isRig then
      idA := AdditiveIdentityNC(A, idList);
    fi;

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
        SEMIRINGSPermuteMultiplicationTable(temp_table, M, sigma);
        if isRig and temp_table[idA] <> constLists[idA] then
            continue;
        fi;
        if IsLeftRightDistributive(A, temp_table) then
          AddSet(tmp, List(temp_table, ShallowCopy));
        fi;
      od;
    od;
    i    := i + 1;
    UniteSet(list, List(tmp, x -> [A, x]));
  od;
  Info(InfoSemirings, 1, "At 100%, found ", Length(list));
  return list;
end);

BindGlobal("FindAntiAutomorphism",
function(M)
  local n, perm, tmp;
  if IsCommutative(M) then
    return ();
  fi;
  n   := Size(M);
  M   := M!.MultiplicationTable;
  tmp := List(M, ShallowCopy);

  for perm in SymmetricGroup(n) do
    SEMIRINGSPermuteMultiplicationTable(tmp, M, perm);
    if M = TransposedMat(tmp) then
      return perm;
    fi;
  od;
  ErrorNoReturn("No anti-automorphism found!");
end);

BindGlobal("UniqueAutomorphismGroups",
function(all, U2E)
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
    elif U2E and IsSelfDualSemigroup(all[i]) then
      aut := Image(IsomorphismPermGroup(AutomorphismGroup(all[i])));
      aut := Group(Concatenation(
                  GeneratorsOfGroup(aut), [FindAntiAutomorphism(all[i])]));
      Unbind(all[i]!.AutomorphismGroup);
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
function(n, flag, structA, structM, U2E, args...)
  local allA, allM, NSD, anti, SD, autM, out, mapA, mapM,
  uniqueAutMs, shift, i, autA, uniqueAutAs, reps, j, sg, isRig;

  allA := CallFuncList(AllSmallSemigroups, Concatenation([n], structA));
  Info(InfoSemirings, 1, "Found ", Length(allA), " candidates for A!");

  Info(InfoSemirings, 1, "Finding non-self-dual semigroups...");
  NSD := CallFuncList(AllSmallSemigroups,
                      Concatenation([n, IsSelfDualSemigroup, false],
                                     structM));
  shift := Length(NSD);

  if not U2E then
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
  fi;

  Info(InfoSemirings, 1, "Adding in self-dual semigroups...");
  SD := CallFuncList(AllSmallSemigroups,
                     Concatenation([n, IsSelfDualSemigroup, true],
                                    structM));

  allM := Concatenation(SD, NSD);

  if not U2E then
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
  else
    if Length(args) > 0 then
      allM := List(args[1], i -> allM[i]);
      Info(InfoSemirings, 1, "Found ", Length(allM),
          " candidates for M!");
      Unbind(anti);
    else
      Info(InfoSemirings, 1, "Found ", Length(SD) + Length(NSD),
          " candidates for M!");
    fi;
  fi;

  Unbind(NSD);
  Unbind(SD);
  CollectGarbage(true);

  Info(InfoSemirings, 1, "Finding automorphism groups...");
  out         := UniqueAutomorphismGroups(allM, U2E);
  uniqueAutMs := out[1];
  mapM        := out[2];
  allM        := List(allM, x -> x!.MultiplicationTable);

  out         := UniqueAutomorphismGroups(allA, false);
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
  if Length(args) = 0 and not U2E then
    allM := Concatenation(allM, anti);
    Unbind(anti);
  fi;

  Unbind(uniqueAutMs);
  Unbind(uniqueAutAs);
  Unbind(out);
  CollectGarbage(true);

  if PositionSublist(structA, [IsGroupAsSemigroup, true]) = fail and
      PositionSublist(structM, [IsSemigroupWithZero, true]) <> fail then
     isRig := true;
  else
     isRig := false;
  fi;

  if flag then
    Info(InfoSemirings, 1, "Counting...");
    return CountFinder(allA, allM, mapA, mapM, shift, reps, isRig);
  else
    Info(InfoSemirings, 1, "Enumerating...");
    return Finder(allA, allM, mapA, mapM, shift, reps, isRig);
  fi;
end);

BindGlobal("SEMIRINGS_STRUCTURE_REC",
rec(
# up to n = 4 available at
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings
  AiSemirings        := [[IsBand, true, IsCommutative, true], # additive reduct
                         []],                                 # multiplicative reduct

# A037291
  RingsWithOne       := [[IsGroupAsSemigroup, true, IsCommutative, true],
                         [IsMonoidAsSemigroup, true]],

# A027623
  Rings              := [[IsGroupAsSemigroup, true, IsCommutative, true],
                         []],

# up to n = 4 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings
  Semirings          := [[IsCommutative, true],
                         []],

# rings without requirement for negatives
# often referred to as a semiring in literature
# up to n = 6 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_identity_and_zero
  SemiringsWithOneAndZero := [[IsCommutative, true, IsMonoidAsSemigroup, true],
                              [IsMonoidAsSemigroup, true,
                                IsSemigroupWithZero, true]],

# up to n = 7 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings_with_identity_and_zero
  AiSemiringsWithOneAndZero := [[IsBand, true, IsCommutative, true,
                                  IsMonoidAsSemigroup, true],
                                [IsMonoidAsSemigroup, true,
                                  IsSemigroupWithZero, true]],

# rings without requirement for negatives or multiplicative identity
# up to n = 4 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_zero
  SemiringsWithZero   := [[IsCommutative, true, IsMonoidAsSemigroup, true],
                          [IsSemigroupWithZero, true]],

# up to n = 5 available here:
# https://math.chapman.edu/~jipsen/structures/doku.php?id=idempotent_semirings_with_zero
  AiSemiringsWithZero := [[IsBand, true, IsCommutative, true,
                            IsMonoidAsSemigroup, true],
                          [IsSemigroupWithZero, true]],

# up to n = 5 available here:
# (page seems to be incorrectly named)
# https://math.chapman.edu/~jipsen/structures/doku.php?id=semirings_with_identity
  AiSemiringsWithOne := [[IsBand, true, IsCommutative, true],
                         [IsMonoidAsSemigroup, true]],

  SemiringsWithOne   := [[IsCommutative, true],
                         [IsMonoidAsSemigroup, true]],

  CommutativeSemirings := [[IsCommutative, true],
                           [IsCommutative, true]],

  CommutativeSemiringsWithOne := [[IsCommutative, true],
                                  [IsCommutative, true,
                                   IsMonoidAsSemigroup, true]],

  CommutativeSemiringsWithZero := [[IsCommutative, true,
                                    IsMonoidAsSemigroup, true],
                                   [IsCommutative, true,
                                    IsSemigroupWithZero, true]],

  CommutativeSemiringsWithOneAndZero := [[IsCommutative, true,
                                          IsMonoidAsSemigroup, true],
                                         [IsCommutative, true,
                                          IsSemigroupWithZero, true,
                                          IsMonoidAsSemigroup, true]],

  Semifields := [[IsCommutative, true, IsMonoidAsSemigroup, true],
                 [IsZeroGroup, true]]));

for key in RecNames(SEMIRINGS_STRUCTURE_REC) do
  InstallGlobalFunction(ValueGlobal(Concatenation("Nr", key)),
      (function(capturedKey)
         return function(n, args...)
           if Length(args) = 0 then
            return CallFuncList(SETUPFINDER,
              Concatenation([n, true], SEMIRINGS_STRUCTURE_REC.(capturedKey),
                            [false]));
           elif Length(args) = 1 then
            if not args[1] in [true, false] then
              ErrorNoReturn("Invalid second argument, must be boolean",
                            " (to indicate up to isomorphism [false] or",
                            " equivalence [true])");
            fi;
            return CallFuncList(SETUPFINDER,
              Concatenation([n, true], SEMIRINGS_STRUCTURE_REC.(capturedKey),
                            args));
           else
            ErrorNoReturn("There should be at most 2 arguments");
           fi;
         end;
       end)(key));

  InstallGlobalFunction(ValueGlobal(Concatenation("All", key)),
      (function(capturedKey)
         return function(n, args...)
           if Length(args) = 0 then
            return CallFuncList(SETUPFINDER,
              Concatenation([n, false], SEMIRINGS_STRUCTURE_REC.(capturedKey),
                            [false]));
           elif Length(args) = 1 then
            if not args[1] in [true, false] then
              ErrorNoReturn("Invalid second argument, must be boolean",
                            " (to indicate up to isomorphism [false] or",
                            " equivalence [true])");
            fi;
            return CallFuncList(SETUPFINDER,
              Concatenation([n, false], SEMIRINGS_STRUCTURE_REC.(capturedKey),
                            args));
           else
            ErrorNoReturn("Invalid number of arguments!");
           fi;
         end;
       end)(key));
od;

InstallGlobalFunction(NrSemiringsWithX,
  function(n, structA, structM, args...)
    if Length(args) = 0 then
      return CallFuncList(SETUPFINDER,
          [n, true, Concatenation([IsCommutative, true], structA),
           structM, false]);
    elif Length(args) = 1 then
      if not args[1] in [true, false] then
        ErrorNoReturn("Invalid second argument, must be boolean",
                      " (to indicate up to isomorphism [false] or",
                      " equivalence [true])");
      fi;
      return CallFuncList(SETUPFINDER,
        Concatenation([n, true, Concatenation([IsCommutative, true], structA),
                       structM], args));
    else
      ErrorNoReturn("Invalid number of arguments!");
    fi;
  end);

InstallGlobalFunction(AllSemiringsWithX,
  function(n, structA, structM, args...)
    if Length(structA) mod 2 <> 0 or Length(structM) mod 2 <> 0 then
      ErrorNoReturn("Invalid structure arguments",
                    "must be lists of even length");
    fi;
    if Length(args) = 0 then
      return CallFuncList(SETUPFINDER,
            [n, false, Concatenation([IsCommutative, true], structA),
             structM, false]);
    elif Length(args) = 1 then
      if not args[1] in [true, false] then
        ErrorNoReturn("Invalid second argument, must be boolean",
                      " (to indicate up to isomorphism [false] or",
                      " equivalence [true])");
      fi;
      return CallFuncList(SETUPFINDER,
        Concatenation([n, false, Concatenation([IsCommutative, true], structA),
                       structM], args));
    else
      ErrorNoReturn("Invalid number of arguments!");
    fi;
end);

InstallGlobalFunction(Semi6String,
  function(S)
    local n, b, blist, v, i, j, bitpos, chunk, str, k, A, M;

    if Length(S) <> 2 then
      ErrorNoReturn("Argument <S> should be a list containing two Cayley tables");
    fi;
    A := S[1];
    M := S[2];
    n := Length(A);

    if n = 0 or n > 62 then
      ErrorNoReturn("Cayley tables must be non-empty and at most 62");
    fi;

    if Length(A) <> Length(M) then
      ErrorNoReturn("Cayley tables must be of same size");
    fi;

    for i in [1 .. n] do
        if Length(A[i]) <> n or Length(M[i]) <> n then
          ErrorNoReturn("Cayley tables must be square");
        fi;
        if not (IsInt(A[i][1]) and IsHomogeneousList(A[i])) or
            not (IsInt(M[i][1]) and IsHomogeneousList(M[i])) then
            ErrorNoReturn("Cayley tables must be lists of integers");
        fi;
    od;

    if n > 1 then
      b := Log2Int(n - 1) + 1;
    else
      b := 1;
    fi;

    # header: like graph6; one char for n (add 63)
    str := [CharInt(n + 63)];

    # initialise bitlist with overestimate
    blist  := BlistList([1 .. 2 * n * n * b], []);
    bitpos := 1;

    # encode A
    for i in [1 .. n] do
      for j in [i .. n] do
        v := A[i][j] - 1;  # shift to 0-based
        for k in [1 .. b] do
          if v mod 2 = 1 then
            blist[bitpos + b - k] := true;
          fi;
          v := QuoInt(v, 2);  # integer divide by 2 (shift right)
        od;
        bitpos := bitpos + b;
      od;
    od;

    # encode M
    for i in [1 .. n] do
      for j in [1 .. n] do
        v := M[i][j] - 1;
        for k in [1 .. b] do
          if v mod 2 = 1 then
            blist[bitpos + b - k] := true;
          fi;
          v := QuoInt(v, 2);
        od;
        bitpos := bitpos + b;
      od;
    od;

    # pad to multiple of 6
    while (bitpos - 1) mod 6 <> 0 do
      blist[bitpos] := false;
      bitpos        := bitpos + 1;
    od;

    # encode in 6-bit blocks
    for i in [1, 7 .. bitpos - 6] do
      chunk := 0;
      for j in [0 .. 5] do
        if blist[i + j] then
          chunk := chunk + 2 ^ (5 - j);
        fi;
      od;
      Add(str, CharInt(chunk + 63));
    od;

    return str;
end);

InstallGlobalFunction(SemiringFromSemi6String,
  function(s)
    local chars, n, b, bits, i, j, k, pos, val, A, M;

    chars := List(s, c -> IntChar(c) - 63);
    n     := chars[1];
    if n > 1 then
      b := Log2Int(n - 1) + 1;
    else
      b := 1;
    fi;

    bits := BlistList([1 .. (Length(chars) - 1) * 6], []);
    pos  := 1;
    for i in [2 .. Length(chars)] do
      val := chars[i];
      for j in [0 .. 5] do
        if val mod 2 = 1 then
          bits[pos + 5 - j] := true;
        fi;
        val := QuoInt(val, 2);
      od;
      pos := pos + 6;
    od;

    A   := List([1 .. n], i -> List([1 .. n], j -> 0));
    M   := List([1 .. n], i -> List([1 .. n], j -> 0));
    pos := 1;

    for i in [1 .. n] do
      for j in [i .. n] do
        val := 0;
        for k in [1 .. b] do
          if bits[pos] then
              val := val + 2 ^ (b - k);
          fi;
          pos := pos + 1;
        od;
        val     := val + 1;
        A[i][j] := val;
        A[j][i] := val;
      od;
    od;

    for i in [1 .. n] do
      for j in [1 .. n] do
        val := 0;
        for k in [1 .. b] do
          if bits[pos] then
            val := val + 2 ^ (b - k);
          fi;
          pos := pos + 1;
        od;
        M[i][j] := val + 1;
      od;
    od;

    return [A, M];
  end);

BindGlobal("SEMIRINGS_IsSemiring",
  function(S)
    local A, M, As, Ms, oldBoE, oldSNE;

    if Length(S) <> 2 then
      return false;
    fi;

    A := S[1];
    M := S[2];

    oldBoE := BreakOnError;
    BreakOnError := false;
    SilentNonInteractiveErrors := true;
    oldSNE := SilentNonInteractiveErrors;

    As := CALL_WITH_CATCH(SemigroupByMultiplicationTable, [A]);
    Ms := CALL_WITH_CATCH(SemigroupByMultiplicationTable, [M]);

    BreakOnError               := oldBoE;
    SilentNonInteractiveErrors := oldSNE;

    if As[1] = false or Ms[1] = false then
      return false;
    fi;

    if not IsCommutativeSemigroup(As[2]) then
      return false;
    fi;

    if not IsLeftRightDistributive(A, M) then
      return false;
    fi;

    return true;
end);

InstallGlobalFunction(Semi6Encode,
  function(name, srs, args...)
    local f, mode, sr;
    if not (IsString(name) or IsFile(name)) then
      ErrorNoReturn("the 1st argument <filename> must be a string or a file,");
    fi;

    if SEMIRINGS_IsSemiring(srs) then
      srs := [srs];
    fi;

    mode := "a";

    if IsString(name) then
      if Length(args) = 1 then
        if not args[1] in ["w", "a"] then
          ErrorNoReturn("the optional argument <mode> must be \"w\" or \"a\",");
        fi;
        mode := args[1];
      elif Length(args) > 1 then
        ErrorNoReturn("there should be at most 3 arguments,");
      fi;
      if IsString(name) and not IsExistingFile(name) then
        mode := "w";
      fi;
      f := IO_CompressedFile(name, mode);
    elif IsFile(name) then
      if Length(args) > 0 then
        ErrorNoReturn("the optional argument <mode> cannot be specified for",
                      " an existing file object, please use the filename",
                      " instead,");
      fi;
      f := name;
      if f!.closed then
        ErrorNoReturn("the 1st argument <filename> is closed,");
      elif f!.wbufsize = false then
        ErrorNoReturn("the mode of the 1st argument <filename> must be ",
                      "\"w\" or \"a\",");
      fi;
    fi;

    for sr in srs do
      if not SEMIRINGS_IsSemiring(sr) then
        IO_Close(f);
        ErrorNoReturn("the argument <srs> must be a semiring or a list of",
                      " semirings,");
      fi;
      IO_WriteLine(f, Semi6String(sr));
    od;

    IO_Close(f);
    return IO_OK;
end);

BindGlobal("Semi6DecoderWrapper",
  function(file)
    local line;
    line := IO_ReadLine(file);
    if line = "" then
      return IO_Nothing;
    fi;
    return SemiringFromSemi6String(line);
end);

InstallGlobalFunction(Semi6Decode,
function(arg...)
  local nr, name, file, i, next, out;

  # defaults
  nr      := infinity;

  if Length(arg) = 1 then
    name := arg[1];
  elif Length(arg) = 2 then
    name    := arg[1];
    nr      := arg[2];
  else
    ErrorNoReturn("there must be 1 or 2 arguments,");
  fi;

  if not (IsString(name) or IsFile(name)) then
    ErrorNoReturn("the 1st argument <filename> must be a string or IO ",
                  "file object,");
  elif not (IsPosInt(nr) or IsInfinity(nr)) then
    ErrorNoReturn("the argument <nr> must be a positive integer or ",
                  "infinity");
  fi;

  if IsString(name) then
    file := IO_CompressedFile(name, "r");
  else
    file := name;
    if file!.closed then
      ErrorNoReturn("the 1st argument <filename> is a closed file,");
    elif file!.rbufsize = false then
      ErrorNoReturn("the mode of the 1st argument <filename> must be \"r\",");
    fi;
  fi;

  if nr < infinity then
    i    := 0;
    next := fail;
    while i < nr - 1 and next <> IO_Nothing do
      i    := i + 1;
      next := IO_ReadLine(file);
    od;
    if next <> IO_Nothing then
      out := Semi6DecoderWrapper(file);
    else
      out := IO_Nothing;
    fi;
    if IsString(arg[1]) then
      IO_Close(file);
    fi;
    return out;
  fi;

  out  := [];
  next := Semi6DecoderWrapper(file);

  while next <> IO_Nothing do
    Add(out, next);
    next := Semi6DecoderWrapper(file);
  od;

  if IsString(arg[1]) then
    IO_Close(file);
  fi;

  return out;
end);