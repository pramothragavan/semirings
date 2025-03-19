#
# aisemirings: Enumerate/count (ai-)semirings
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage("aisemirings", false);;

TestDirectory(DirectoriesPackageLibrary("aisemirings", "tst"),
    rec(testOptions := rec(compareFunction := function(obtained, expected)
      local obtainedLines, expectedLines;
      obtainedLines := SplitString(obtained, "\n");
      expectedLines := SplitString(expected, "\n");

      obtainedLines := Filtered(obtainedLines,
                                line -> Position(line, '%') = fail);
      expectedLines := Filtered(expectedLines,
                                line -> Position(line, '%') = fail);

      return obtainedLines = expectedLines;
    end),
    exitGAP := true));

FORCE_QUIT_GAP(1);  # if we ever get here, there was an error