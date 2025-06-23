#
# semirings: Enumerate semirings
#
# Reading the declaration part of the package.
#
if not LoadKernelExtension("semirings") then
  Error("failed to load kernel module of package semirings");
fi;
ReadPackage("semirings", "gap/semirings.gd");

DeclareInfoClass("InfoSemirings");
SetInfoLevel(InfoSemirings, 1);
SetInfoLevel(InfoSmallsemi, 0);