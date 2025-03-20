DISTRIBUTE := function(args...)
  local allA, allM, NSD, anti, SD, autM, out, mapA, mapM,
  uniqueAutMs, shift, sg, i, autA, uniqueAutAs, reps, j,
  n, structA, structM, totals, f;

  n       := args[1];
  structA := args[3];
  structM := args[4];

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

  for i in [1 .. shift] do
    Add(mapM, mapM[Length(mapM) - shift - 1 + i]);
  od;

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

  totals := List(reps, row -> Sum(List(row, Length)));
  Print(totals);
  f := IO_CompressedFile("totals.txt", "w");
  IO_Write(f, totals);
  IO_Close(f);
  f := IO_CompressedFile("mapA.txt", "w");
  IO_Write(f, mapA);
  IO_Close(f);
  Exec("python distribute.py");
  Exec("rm totals.txt mapA.txt");
end;

DISTRIBUTE(7, true, [IsBand, true, IsCommutative, true], []);