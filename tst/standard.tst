#@local l1, l2
gap> START_TEST("Semirings tests: standard");
gap> LoadPackage("semirings", false);;
gap> l1 := InfoLevel(InfoSemirings);;
gap> SetInfoLevel(InfoSemirings, 0);
gap> l2 := InfoLevel(InfoSmallsemi);;
gap> SetInfoLevel(InfoSmallsemi, 0);
gap> NrRingsWithOne(1);
1
gap> last = Length(AllRings(1));
true
gap> NrRingsWithOne(2);
1
gap> last = Length(AllRingsWithOne(2));
true
gap> NrRingsWithOne(3);
1
gap> last = Length(AllRingsWithOne(3));
true
gap> NrRingsWithOne(4);
4
gap> last = Length(AllRingsWithOne(4));
true
gap> NrRingsWithOne(5);
1
gap> NrRings(1);
1
gap> last = Length(AllRings(1));
true
gap> NrRings(2);
2
gap> last = Length(AllRings(2));
true
gap> NrRings(3);
2
gap> last = Length(AllRings(3));
true
gap> NrRings(4);
11
gap> last = Length(AllRings(4));
true
gap> NrRings(5);
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
gap> NrSemiringsWithOneAndZero(1);
1
gap> last = Length(AllSemiringsWithOneAndZero(1));
true
gap> NrSemiringsWithOneAndZero(2);
2
gap> last = Length(AllSemiringsWithOneAndZero(2));
true
gap> NrSemiringsWithOneAndZero(3);
6
gap> last = Length(AllSemiringsWithOneAndZero(3));
true
gap> NrSemiringsWithOneAndZero(4);
40
gap> last = Length(AllSemiringsWithOneAndZero(4));
true
gap> NrSemiringsWithOneAndZero(5);
295
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
gap> SetInfoLevel(InfoSemirings, l1);
gap> SetInfoLevel(InfoSmallsemi, l2);
gap> STOP_TEST("Semirings tests: standard", 0);