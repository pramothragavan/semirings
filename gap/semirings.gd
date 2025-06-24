#
# semirings: Enumerate semirings
#
#! @Chapter Introduction
#!
#!The semirings package provides tools for enumerating semirings and related algebraic structures of small orders. 
#!The package allows users to count and generate semirings up to isomorphism or equivalence using a rudimentary algorithm
#!and the library of small semigroups provided by smallsemi. It supports a variety of structures and offers extensibility to custom constraints.
#!This package fills a gap in the literature by providing the first known counts (in many cases) of semirings and their variants up to equivalence.
#!
#! @Chapter Functionality
#!
#!
#! @Section Example Methods
#!
#! This section will describe the example
#! methods of aisemirings

#! @Description
#!   Insert documentation for your function here
DeclareGlobalFunction("AllAiSemirings");
DeclareGlobalFunction("AllRingsWithOne");
DeclareGlobalFunction("AllRings");
DeclareGlobalFunction("AllSemirings");
DeclareGlobalFunction("AllSemiringsWithOneAndZero");
DeclareGlobalFunction("AllAiSemiringsWithOneAndZero");
DeclareGlobalFunction("AllSemiringsWithZero");
DeclareGlobalFunction("AllAiSemiringsWithZero");
DeclareGlobalFunction("AllAiSemiringsWithOne");
DeclareGlobalFunction("AllSemiringsWithOne");

DeclareGlobalFunction("NrAiSemirings");
DeclareGlobalFunction("NrRingsWithOne");
DeclareGlobalFunction("NrRings");
DeclareGlobalFunction("NrSemirings");
DeclareGlobalFunction("NrSemiringsWithOneAndZero");
DeclareGlobalFunction("NrAiSemiringsWithOneAndZero");
DeclareGlobalFunction("NrSemiringsWithZero");
DeclareGlobalFunction("NrAiSemiringsWithZero");
DeclareGlobalFunction("NrAiSemiringsWithOne");
DeclareGlobalFunction("NrSemiringsWithOne");