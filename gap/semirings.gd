#
# Semirings: Enumerate semirings
#
#! @Chapter Introduction
#!
#! The <B>Semirings</B> package provides tools for enumerating semirings and
#! related algebraic structures of small orders.
#! The package allows users to count and generate semirings up to isomorphism
#! or equivalence using a rudimentary algorithm
#! and the library of small semigroups provided by <B>Smallsemi</B>. It supports
#! a variety of structures and offers extensibility to custom constraints.
#! This package fills a gap in the literature by providing the first known
#! counts (in many cases) of semirings and their variants up to equivalence.
#! In the remainder of this chapter, we discuss installation of the package.
#! @Section Requirements
#! This software is designed for use with <B>GAP</B> version 4.5 or later.
#! It also requires the <B>Smallsemi</B> package (version 0.7.2) and the
#! <B>Semigroups</B> package (version 5.5.1 or higher) to function correctly.
#!
#! @Subsection RAM
#! Due to its dependence on <B>Smallsemi</B>, <B>Semirings</B> can use large
#! amounts of RAM. For more information on how <B>GAP</B> uses memory, see
#! <Ref BookName="ref" Sect="Command Line Options"
#!      Text=" GAP command-line options"/>.
#! In the case that the user runs into memory issues, see
#! <Ref BookName="Smallsemi" Sect="Memory Issues"
#!      Text="Smallsemi: Memory Issues"/>.
#! @Section Installation
#! @Subsection Download and Extract Semirings
#! The installation follows standard <B>GAP</B> rules as outlined in
#! the following two steps; see
#! <Ref BookName="ref" Sect="Installing a GAP Package"
#!      Text="Reference: Installing a GAP Package"/> for further details.
#! * Ensure that Semigroups version 4.5 or later is available.
#! * Ensure that Smallsemi version 0.7.2 or later is available.
#! * Download an archive of the package from []
#! * Move the archive inside a <F>pkg</F> directory. This can be either the
#! main <F>pkg</F> directory in your <B>GAP</B> installation or your personal
#! <F>pkg</F> directory.
#! * Unzip and untar the file, this should create a directory called
#! <F>semirings</F> inside the <F>pkg</F> directory.
#! * Inside the <F>pkg/semirings</F> directory, in your terminal type
#! @BeginCode Compile
#! configure && make
#! @EndCode
#! @InsertCode Compile
#! @Subsection Loading
#! To use the package, start a <B>GAP</B> session and type
#! `LoadPackage("semirings");` at the <B>GAP</B> prompt. You should see
#! the following:
#! @BeginExample LoadPackage
#! gap> LoadPackage("semirings");
#! -----------------------------------------------------------------------------
#! Loading semirings 0.1 (Enumerate semirings)
#! by James Mitchell (https://jdbm.me) and
#!    Pramoth Ragavan (https://pramothragavan.github.io/).
#! Homepage: https://pramothragavan.github.io/semirings/
#! Report issues at https://github.com/pramothragavan/semirings/issues
#! -----------------------------------------------------------------------------
#! true
#! @EndExample
#! You might want to start <B>GAP</B> with a specified amount of memory; see 
#! <Ref BookName="Smallsemi" Sect="Memory Issues"
#!      Text="Smallsemi: Memory Issues"/>.
#! @Subsection Testing
#! You should verify the success of the installation by running the test file.
#! This is done by the following command and should return a similar output:
#! @BeginExample Test
#! gap> ReadPackage("semirings", "tst/testall.g");
#! Architecture: aarch64-apple-darwin23-default64-kv9
#!
#! testing: /semirings/tst/ai.tst
#!     3730 ms (997 ms GC) and 383MB allocated for ai.tst
#! testing: /semirings/tst/equivalence.tst
#!    54127 ms (5006 ms GC) and 20.0GB allocated for equivalence.tst
#! testing: /semirings/tst/standard.tst
#!     6197 ms (2139 ms GC) and 441MB allocated for standard.tst
#! -----------------------------------
#! total     64054 ms (8142 ms GC) and 20.8GB allocated
#!               0 failures in 3 files
#!
#! I  No errors detected while testing
#! @EndExample

#! @Chapter Functionality
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