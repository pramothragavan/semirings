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
#!
#! @Section Definitions and Preliminaries
#! There are various definitions of semirings in the literature, and
#! we make use of the following convention.
#! A semiring is a set $S$ with two binary operations, addition and
#! multiplication, such that:
#! * The **additive reduct** \((S, +)\), which we denote by \(A\), is a commutative semigroup.
#! * The **multiplicative reduct** \((S, \cdot)\), which we denote by \(M\), is a semigroup.
#! * Multiplication distributes over addition, i.e. for all \(a, b, c \in S\),
#! \[a \cdot (b + c) = (a \cdot b) + (a \cdot c) \quad \text{and} \quad (b + c) \cdot a = (b \cdot a) + (c \cdot a).
#! \]
#! It is sometimes useful to consider a semiring $S$ as the pair $(A, M)$. 
#!
#! We will also make use of the prefix 'ai' to mean 'additively idempotent'.
#! For instance, an **ai-semiring** $S$ is a semiring with the additional property that
#! \[a + a = a \quad \text{for all } a \in S.\]
#!
#! We make use of the convention that rings do not necessarily have a
#! multiplicative identity. 
#!
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
#! Semirings and various related algebraic structures of small order can be
#! enumerated using the <B>Semirings</B> package. By small order, we mean at
#! most 8, but in many cases even 8 is computationally unfeasible under the
#! current implementation. Each structure type has an
#! associated pair of functions: `All&lt;Structure&gt;` for enumeration and
#! `Nr&lt;Structure&gt;` for counting. Here, `&lt;Structure&gt;` can be one of:
#! `AiSemirings`, `RingsWithOne`, `Rings`, `Semirings`,
#! `SemiringsWithOneAndZero`, `AiSemiringsWithOneAndZero`,
#! `SemiringsWithZero`, `AiSemiringsWithZero`, `AiSemiringsWithOne`, or
#! `SemiringsWithOne`.
#!
#! For a given `&lt;Structure&gt;`, the `All&lt;Structure&gt;` function
#! returns a list of all structures of that type (up to isomorphism or
#! equivalence), each represented as a pair of Cayley tables. For instance,
#! `AllSemirings(n)` returns a list of pairs `[A, M]`, where `A` and `M`
#! are $n\times n$ Cayley tables as described in
#! <Ref BookName="Semirings" Sect="Definitions and Preliminaries"/>.
#! The corresponding `Nr&lt;Structure&gt;` function returns the number of such
#! structures without storing them, and so is both faster and more memory
#! efficient.

#! @Section Functions for counting and enumerating structures
#! @BeginGroup AllStructures
#! @Returns a list of pairs of Cayley tables
#! @Description These functions return a list of pairs of Cayley tables of
#! order <A>n</A>. The optional argument <A>U2E</A> is a boolean that
#! determines whether the structures are considered up to isomorphism
#! (false, default) or equivalence (true).
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllSemirings");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllSemiringsWithOne");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllSemiringsWithZero");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllSemiringsWithOneAndZero");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllAiSemirings");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllAiSemiringsWithZero");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllAiSemiringsWithOne");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllAiSemiringsWithOneAndZero");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllRings");
#! @Arguments n, [U2E]
DeclareGlobalFunction("AllRingsWithOne");
#! @EndGroup
#!
#! @BeginGroup NrStructures
#! @Arguments n, [U2E]
#! @Returns the number of structures of order <A>n</A>
#! @Description These functions return the number of structures of order
#! <A>n</A>. The optional argument <A>U2E</A> is a boolean that
#! determines whether the structures are counted up to isomorphism
#! (false, default) or equivalence (true).
DeclareGlobalFunction("NrSemirings");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrSemiringsWithOne");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrSemiringsWithZero");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrSemiringsWithOneAndZero");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrAiSemirings");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrAiSemiringsWithOne");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrAiSemiringsWithZero");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrAiSemiringsWithOneAndZero");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrRings");
#! @Arguments n, [U2E]
DeclareGlobalFunction("NrRingsWithOne");
#! @EndGroup
#!
#! @BeginGroup AllSemiringsWith
#! @Arguments n, structA, structM, [U2E]
#! @Description These functions allow you to enumerate/count the number
#! of semirings of order <A>n</A> respectively, while specifying
#! constraints on the additive and multiplicative reducts of the semiring.
#!
#! <A>structA</A> and <A>structM</A> should be lists of even length, where
#! * the odd entries <A>structA[2i - 1]</A> and <A>structM[2i - 1]</A> are functions
#! * the even entries <A>structA[2i]</A> and <A>structM[2i]</A> should be values that can be returned by the functions <A>structA[2i - 1]</A> and <A>structM[2i - 1]</A> respectively.
#! The optional argument <A>U2E</A> is a boolean that
#! determines whether the structures are considered up to isomorphism
#! (false, default) or equivalence (true).
#!
#! It is not necessary to specify additive commutativity in <A>structA</A>.
#! This is always assumed as it forms part of the definition of a semiring.
#!
#! For instance, <C>AllSemiringsWithX(n, [IsBand, true], [])</C> is
#! equivalent to <C>AllAiSemirings(n)</C>.
DeclareGlobalFunction("AllSemiringsWithX");
#! @Arguments n, structA, structM, [U2E]
DeclareGlobalFunction("NrSemiringsWithX");
#! @EndGroup
#!
#! @Section Miscellaneous
#! @Description is the info class
#! (see <Ref BookName="ref" Sect="Info Functions"/>) of
#! <B>Semirings</B>. The info level is initially set to 1 which
#! triggers progress messages whenever any function in Section
#! <Ref BookName="semirings"
#!     Sect="Functions for counting and enumerating structures"/> is called.
DeclareInfoClass("InfoSemirings");
SetInfoLevel(InfoSemirings, 1);

#! @Chapter Parallel Approaches
#! Given the computationally intensive nature of the enumeration
#! and counting of semirings, the package provides a means of pseudo-parallelisation.
#! 