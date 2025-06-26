#@local CheckSemi6, l1, l2
gap> START_TEST("Semirings tests: semi6");
gap> LoadPackage("semirings", false);;
gap> l1 := InfoLevel(InfoSemirings);;
gap> SetInfoLevel(InfoSemirings, 0);;
gap> l2 := InfoLevel(InfoSmallsemi);;
gap> SetInfoLevel(InfoSmallsemi, 0);;
gap> CheckSemi6 := function(srs)
>  local failures, sr;
>  failures := 0;
>  for sr in srs do
>    if Semi6Decode(Semi6Encode(sr)) <> sr then
>      failures := failures + 1;
>    fi;
>  od;
>  return failures;
> end;;
gap> CheckSemi6(AllSemirings(1));
0
gap> CheckSemi6(AllSemirings(2));
0
gap> CheckSemi6(AllSemirings(3));
0
gap> CheckSemi6(AllSemirings(4));
0
gap> CheckSemi6(AllRings(1));
0
gap> CheckSemi6(AllRings(2));
0
gap> CheckSemi6(AllRings(3));
0
gap> CheckSemi6(AllRings(4));
0
gap> CheckSemi6(AllRings(5));
0
gap> CheckSemi6(AllSemiringsWithOne(1));
0
gap> CheckSemi6(AllSemiringsWithOne(2));
0
gap> CheckSemi6(AllSemiringsWithOne(3));
0
gap> CheckSemi6(AllSemiringsWithOne(4));
0
gap> CheckSemi6(AllSemiringsWithOne(5));
0
gap> CheckSemi6(AllRingsWithOne(1));
0
gap> CheckSemi6(AllRingsWithOne(2));
0
gap> CheckSemi6(AllRingsWithOne(3));
0
gap> CheckSemi6(AllRingsWithOne(4));
0
gap> CheckSemi6(AllRingsWithOne(5));
0
gap> CheckSemi6(AllSemiringsWithOneAndZero(1));
0
gap> CheckSemi6(AllSemiringsWithOneAndZero(2));
0
gap> CheckSemi6(AllSemiringsWithOneAndZero(3));
0
gap> CheckSemi6(AllSemiringsWithOneAndZero(4));
0
gap> CheckSemi6(AllSemiringsWithOneAndZero(5));
0
gap> CheckSemi6(AllAiSemirings(1));
0
gap> CheckSemi6(AllAiSemirings(2));
0
gap> CheckSemi6(AllAiSemirings(3));
0
gap> CheckSemi6(AllAiSemirings(4));
0
gap> CheckSemi6(AllAiSemirings(5));
0
gap> CheckSemi6(AllAiSemiringsWithOneAndZero(1));
0
gap> CheckSemi6(AllAiSemiringsWithOneAndZero(2));
0
gap> CheckSemi6(AllAiSemiringsWithOneAndZero(3));
0
gap> CheckSemi6(AllAiSemiringsWithOneAndZero(4));
0
gap> CheckSemi6(AllAiSemiringsWithOneAndZero(5));
0
gap> SetInfoLevel(InfoSemirings, l1);;
gap> SetInfoLevel(InfoSmallsemi, l2);;
gap> STOP_TEST("Semirings tests: semi6", 0);