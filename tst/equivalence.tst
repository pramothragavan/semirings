#@local AntiIsomorphismFilter, l
gap> START_TEST("Semirings tests: equivalence");
gap> LoadPackage("semirings", false);;
gap> l1 := InfoLevel(InfoSemirings);;
gap> SetInfoLevel(InfoSemirings, 0);;
gap> l2 := InfoLevel(InfoSmallsemi);;
gap> SetInfoLevel(InfoSmallsemi, 0);;
gap> AntiIsomorphismFilter := function(all)
>  local result, processed, i, j, A1, M1, aut1, A2, M2, p, tmp, isAntiIso, auts;
>  result    := [];
>  processed := [];
>  tmp       := List([1 .. Size(all[1][2])], x -> [1 .. Size(all[1][2])]);
>  auts      := List(all, x -> Image(IsomorphismPermGroup(AutomorphismGroup(SemigroupByMultiplicationTable(x[1])))));
>  for i in [1 .. Length(all)] do
>    if not i in processed then
>      Add(result, all[i]);
>      A1   := all[i][1];
>      M1   := all[i][2];
>      aut1 := auts[i];
>      for j in [i + 1 .. Length(all)] do
>        if not j in processed then
>          A2   := all[j][1];
>          M2   := all[j][2];
>          if A1 = A2 then
>            isAntiIso := false;
>            for p in aut1 do
>              PermuteMultiplicationTableNC(tmp, M1, p);
>              if tmp = TransposedMat(M2) then
>                isAntiIso := true;
>                break;
>              fi;
>            od;
>            if isAntiIso then
>              AddSet(processed, j);
>            fi;
>          fi;
>        fi;
>      od;
>    fi;
>  od;
>  return result;
> end;;
gap> NrAiSemirings(1, true) = Length(AntiIsomorphismFilter(AllAiSemirings(1)));
true
gap> NrAiSemirings(2, true) = Length(AntiIsomorphismFilter(AllAiSemirings(2)));
true
gap> NrAiSemirings(3, true) = Length(AntiIsomorphismFilter(AllAiSemirings(3)));
true
gap> NrAiSemirings(4, true) = Length(AntiIsomorphismFilter(AllAiSemirings(4)));
true
gap> NrAiSemirings(5, true) = Length(AntiIsomorphismFilter(AllAiSemirings(5)));
true
gap> NrSemirings(2, true) = Length(AntiIsomorphismFilter(AllSemirings(2)));
true
gap> NrSemirings(3, true) = Length(AntiIsomorphismFilter(AllSemirings(3)));
true
gap> NrSemirings(4, true) = Length(AntiIsomorphismFilter(AllSemirings(4)));
true
gap> NrRingsWithOne(2, true) = Length(AntiIsomorphismFilter(AllRingsWithOne(2)));
true
gap> NrRingsWithOne(3, true) = Length(AntiIsomorphismFilter(AllRingsWithOne(3)));
true
gap> NrAiSemiringsWithOneAndZero(2, true) = Length(AntiIsomorphismFilter(AllAiSemiringsWithOneAndZero(2)));
true
gap> NrAiSemiringsWithOneAndZero(3, true) = Length(AntiIsomorphismFilter(AllAiSemiringsWithOneAndZero(3)));
true
gap> NrAiSemiringsWithOneAndZero(4, true) = Length(AntiIsomorphismFilter(AllAiSemiringsWithOneAndZero(4)));
true
gap> NrAiSemiringsWithOneAndZero(5, true) = Length(AntiIsomorphismFilter(AllAiSemiringsWithOneAndZero(5)));
true
gap> NrRings(1, true) = Length(AntiIsomorphismFilter(AllRings(1)));
true
gap> NrRings(2, true) = Length(AntiIsomorphismFilter(AllRings(2)));
true
gap> NrRings(3, true) = Length(AntiIsomorphismFilter(AllRings(3)));
true
gap> NrRings(4, true) = Length(AntiIsomorphismFilter(AllRings(4)));
true
gap> NrSemiringsWithOne(2, true) = Length(AntiIsomorphismFilter(AllSemiringsWithOne(2)));
true
gap> NrSemiringsWithOne(3, true) = Length(AntiIsomorphismFilter(AllSemiringsWithOne(3)));
true
gap> NrSemiringsWithOne(4, true) = Length(AntiIsomorphismFilter(AllSemiringsWithOne(4)));
true
gap> NrSemiringsWithOne(5, true) = Length(AntiIsomorphismFilter(AllSemiringsWithOne(5)));
true
gap> NrSemiringsWithOneAndZero(2, true) = Length(AntiIsomorphismFilter(AllSemiringsWithOneAndZero(2)));
true
gap> NrSemiringsWithOneAndZero(3, true) = Length(AntiIsomorphismFilter(AllSemiringsWithOneAndZero(3)));
true
gap> NrSemiringsWithOneAndZero(4, true) = Length(AntiIsomorphismFilter(AllSemiringsWithOneAndZero(4)));
true
gap> NrSemiringsWithOneAndZero(5, true) = Length(AntiIsomorphismFilter(AllSemiringsWithOneAndZero(5)));
true
gap> SetInfoLevel(InfoSemirings, l1);
gap> SetInfoLevel(InfoSmallsemi, l2);
gap> STOP_TEST("Semirings tests: equivalence", 0);