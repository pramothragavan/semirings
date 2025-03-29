gap> START_TEST("AiSemiring tests");
gap> LoadPackage("aisemirings", false);;
gap> l := InfoLevel(InfoSemirings);;
gap> SetInfoLevel(InfoSemirings, 0);
gap> NrAiSemirings(1);
1
gap> NrAiSemirings(2);
6
gap> NrAiSemirings(3);
61
gap> NrAiSemirings(4);
866
gap> NrAiSemirings(5);
15751
gap> NrRings(1);
1
gap> NrRings(2);
1
gap> NrRings(3);
1
gap> NrRings(4);
4
gap> NrRings(5);
1
gap> NrRngs(1);
1
gap> NrRngs(2);
2
gap> NrRngs(3);
2
gap> NrRngs(4);
11
gap> NrRngs(5);
2
gap> NrSemirings(1);
1
gap> NrSemirings(2);
10
gap> NrSemirings(3);
132
gap> NrSemirings(4);
2341
gap> NrRigs(1);
1
gap> NrRigs(2);
2
gap> NrRigs(3);
6
gap> NrRigs(4);
40
gap> NrRigs(5);
295
gap> NrAiRigs(1);
1
gap> NrAiRigs(2);
1
gap> NrAiRigs(3);
3
gap> NrAiRigs(4);
20
gap> NrAiRigs(5);
149
gap> NrSemiringsWithOne(1);
1
gap> NrSemiringsWithOne(2);
4
gap> NrSemiringsWithOne(3);
22
gap> NrSemiringsWithOne(4);
169
gap> NrSemiringsWithOne(5);
1819
gap> SetInfoLevel(InfoSemirings, l);
gap> STOP_TEST("AiSemiring tests", 0);