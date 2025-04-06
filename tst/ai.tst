gap> START_TEST("Semirings tests: ai");
gap> LoadPackage("aisemirings", false);;
gap> l := InfoLevel(InfoSemirings);;
gap> SetInfoLevel(InfoSemirings, 0);
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
gap> NrAiRigs(1);
1
gap> last = Length(AllAiRigs(1));
true
gap> NrAiRigs(2);
1
gap> last = Length(AllAiRigs(2));
true
gap> NrAiRigs(3);
3
gap> last = Length(AllAiRigs(3));
true
gap> NrAiRigs(4);
20
gap> last = Length(AllAiRigs(4));
true
gap> NrAiRigs(5);
149
gap> SetInfoLevel(InfoSemirings, l);
gap> STOP_TEST("Semirings tests: ai", 0);