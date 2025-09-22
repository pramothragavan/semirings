LoadPackage("semigroups");
LoadPackage("smallsemi");
LoadPackage("semirings");
l1 := InfoLevel(InfoSemirings);
SetInfoLevel(InfoSemirings, 0);
l2 := InfoLevel(InfoSmallsemi);
SetInfoLevel(InfoSmallsemi, 0);
DISTRIBUTE := function(args...)
  local allA, allM, NSD, SD, autM, out, mapM, totals, n, structA,
  structM, uniqueAutMs, i, autA, uniqueAutAs, reps, j, path, f, shift,
  colTotals, U2E;

  n       := args[1];
  structA := args[3];
  structM := args[4];
  U2E     := args[5];

  allA := CallFuncList(AllSmallSemigroups, Concatenation([n], structA));
  Info(InfoSemirings, 1, "Found ", Length(allA), " candidates for A!");

  Info(InfoSemirings, 1, "Finding non-self-dual semigroups...");
  NSD := CallFuncList(AllSmallSemigroups,
                      Concatenation([n, IsSelfDualSemigroup, false],
                                     structM));
  shift := Length(NSD);

  Info(InfoSemirings, 1, "Adding in self-dual semigroups...");
  SD := CallFuncList(AllSmallSemigroups,
                     Concatenation([n, IsSelfDualSemigroup, true],
                                    structM));

  allM := Concatenation(SD, NSD);
  if U2E then
     Info(InfoSemirings, 1, "Found ", Length(allM),
          " candidates for M!");
  else
     Info(InfoSemirings, 1, "Found ", Length(SD) + Length(NSD) * 2,
          " candidates for M!");
  fi;
  Unbind(NSD);
  Unbind(SD);
  CollectGarbage(true);

  Info(InfoSemirings, 1, "Finding automorphism groups...");
  out         := UniqueAutomorphismGroups(allM, U2E);
  uniqueAutMs := out[1];
  mapM        := out[2];
  i           := 0;
  if not U2E then
     mapM := Concatenation(mapM,
                           List([Length(allM) - shift + 1 .. Length(allM)],
                                x -> mapM[x]));
  fi;
  allM        := List(allM, x -> x!.MultiplicationTable);

  out         := UniqueAutomorphismGroups(allA, false);
  uniqueAutAs := out[1];
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

  totals    := List(reps, row -> List(row, Length));
  colTotals := List([1 .. Length(totals[1])],
           j -> Sum([1 .. Length(totals)], i -> totals[i][j]));

  Info(InfoSemirings, 1, "Unbinding variables and collecting garbage...");
  Unbind(allA);
  Unbind(allM);
  Unbind(reps);
  Unbind(uniqueAutMs);
  Unbind(uniqueAutAs);
  Unbind(out);
  CollectGarbage(true);

  path   := Concatenation(GAPInfo.PackagesLoaded.semirings[1], "parallel/");
  f      := IO_CompressedFile(Concatenation(path, "totals.txt"), "w");
  IO_Write(f, colTotals);
  IO_Close(f);
  f := IO_CompressedFile(Concatenation(path, "mapM.txt"), "w");
  IO_Write(f, mapM);
  IO_Close(f);
  Exec(Concatenation(path, "distribute.py"));
  Exec(Concatenation("rm ", path, "totals.txt ", path, "mapM.txt"));
end;

f := InputTextFile(Concatenation(GAPInfo.PackagesLoaded.semirings[1],
                   "parallel/temp_struct.txt"));
structure := EvalString(ReadLine(f));
CloseStream(f);
Print("Distributing across cores...\n");
Print(structure);
CallFuncList(DISTRIBUTE, structure);
SetInfoLevel(InfoSemirings, l1);
SetInfoLevel(InfoSmallsemi, l2);
quit;
