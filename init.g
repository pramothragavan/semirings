#
# aisemirings: Enumerate/count (ai-)semirings
#
# Reading the declaration part of the package.
#
if not LoadKernelExtension("aisemirings") then
  Error("failed to load kernel module of package aisemirings");
fi;
ReadPackage("aisemirings", "gap/aisemirings.gd");

DeclareInfoClass("InfoSemirings");
SetInfoLevel(InfoSemirings, 1);