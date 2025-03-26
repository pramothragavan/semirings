gap> START_TEST("AiSemiring tests");
gap> LoadPackage("aisemirings", false);;
gap> l1 := InfoLevel(InfoSmallsemi);;
gap> SetInfoLevel(InfoSmallsemi, 0);
gap> l2 := InfoLevel(InfoSemirings);;
gap> SetInfoLevel(InfoSemirings, 0);
gap> NrAiSemirings(2);
6
gap> NrAiSemirings(3);
61
gap> NrAiSemirings(4);
866
gap> NrAiSemirings(5);
15751
gap> NrRings(2);
1
gap> NrRings(3);
1
gap> NrRings(4);
4
gap> NrRings(5);
1
gap> NrRings(6);
1
gap> NrRngs(2);
2
gap> NrRngs(3);
2
gap> NrRngs(4);
11
gap> NrRngs(5);
2
gap> NrRngs(6);
4
gap> SetInfoLevel(InfoSmallsemi, l1);
gap> SetInfoLevel(InfoSemirings, l2);
gap> STOP_TEST("AiSemiring tests", 0);