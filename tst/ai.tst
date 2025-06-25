gap> START_TEST("Semirings tests: ai");
gap> LoadPackage("semirings", false);;
gap> l1 := InfoLevel(InfoSemirings);;
gap> SetInfoLevel(InfoSemirings, 0);
gap> l2 := InfoLevel(InfoSmallsemi);;
gap> SetInfoLevel(InfoSmallsemi, 0);
gap> NrAiSemirings(1);
1
gap> last = Length(AllAiSemirings(1));
true
gap> NrAiSemirings(2);
6
gap> last = Length(AllAiSemirings(2));
true
gap> NrAiSemirings(3);
61
gap> last = Length(AllAiSemirings(3));
true
gap> NrAiSemirings(4);
866
gap> last = Length(AllAiSemirings(4));
true
gap> NrAiSemirings(5);
15751
gap> NrAiSemiringsWithOneAndZero(1);
1
gap> last = Length(AllAiSemiringsWithOneAndZero(1));
true
gap> NrAiSemiringsWithOneAndZero(2);
1
gap> last = Length(AllAiSemiringsWithOneAndZero(2));
true
gap> NrAiSemiringsWithOneAndZero(3);
3
gap> last = Length(AllAiSemiringsWithOneAndZero(3));
true
gap> NrAiSemiringsWithOneAndZero(4);
20
gap> last = Length(AllAiSemiringsWithOneAndZero(4));
true
gap> NrAiSemiringsWithOneAndZero(5);
149
gap> SetInfoLevel(InfoSemirings, l1);
gap> SetInfoLevel(InfoSmallsemi, l2);
gap> STOP_TEST("Semirings tests: ai", 0);