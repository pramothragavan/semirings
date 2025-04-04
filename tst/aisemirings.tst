gap> START_TEST("AiSemiring tests");
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
gap> NrRings(1);
1
gap> last = Length(AllRings(1));
true
gap> NrRings(2);
1
gap> last = Length(AllRings(2));
true
gap> NrRings(3);
1
gap> last = Length(AllRings(3));
true
gap> NrRings(4);
4
gap> last = Length(AllRings(4));
true
gap> NrRings(5);
1
gap> NrRngs(1);
1
gap> last = Length(AllRngs(1));
true
gap> NrRngs(2);
2
gap> last = Length(AllRngs(2));
true
gap> NrRngs(3);
2
gap> last = Length(AllRngs(3));
true
gap> NrRngs(4);
11
gap> last = Length(AllRngs(4));
true
gap> NrRngs(5);
2
gap> NrSemirings(1);
1
gap> last = Length(AllSemirings(1));
true
gap> NrSemirings(2);
10
gap> last = Length(AllSemirings(2));
true
gap> NrSemirings(3);
132
gap> last = Length(AllSemirings(3));
true
gap> NrSemirings(4);
2341
gap> NrRigs(1);
1
gap> last = Length(AllRigs(1));
true
gap> NrRigs(2);
2
gap> last = Length(AllRigs(2));
true
gap> NrRigs(3);
6
gap> last = Length(AllRigs(3));
true
gap> NrRigs(4);
40
gap> last = Length(AllRigs(4));
true
gap> NrRigs(5);
295
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
gap> NrSemiringsWithOne(1);
1
gap> last = Length(AllSemiringsWithOne(1));
true
gap> NrSemiringsWithOne(2);
4
gap> last = Length(AllSemiringsWithOne(2));
true
gap> NrSemiringsWithOne(3);
22
gap> last = Length(AllSemiringsWithOne(3));
true
gap> NrSemiringsWithOne(4);
169
gap> last = Length(AllSemiringsWithOne(4));
true
gap> NrSemiringsWithOne(5);
1819
gap> SetInfoLevel(InfoSemirings, l);
gap> STOP_TEST("AiSemiring tests", 0);