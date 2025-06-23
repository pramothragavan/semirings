#
# semirings: Enumerate semirings
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "semirings",
Subtitle := "Enumerate semirings",
Version := "0.1",
Date := "12/03/2025", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    FirstNames := "James",
    LastName := "Mitchell",
    WWWHome := "https://jdbm.me",
    Email := "jdm3@st-andrews.ac.uk",
    IsAuthor := true,
    IsMaintainer := true,
    PostalAddress := Concatenation(
               "Mathematical Institute\n",
               "North Haugh\n",
               "St Andrews\n",
               "Fife\n",
               "KY16 9SS\n",
               "Scotland" ),
    Place := "St Andrews",
    Institution := "University of St Andrews",
  ),
  rec(
    FirstNames := "Pramoth",
    LastName := "Ragavan",
    WWWHome := "https://pramothragavan.github.io/",
    Email := "pr90@st-andrews.ac.uk",
    IsAuthor := true,
    IsMaintainer := true,
    #PostalAddress := TODO,
    #Place := TODO,
    Institution := "University of St Andrews",
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/pramothragavan/semirings",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://pramothragavan.github.io/semirings/",
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "semirings",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Enumerate semirings",
),

Dependencies := rec(
  GAP := ">= 4.13",
  NeededOtherPackages := [ ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
  if not IsKernelExtensionAvailable("semirings") then
    LogPackageLoadingMessage(PACKAGE_WARNING,
                             "failed to load kernel module of package semirings");
    return false;
  fi;
  return true;
end,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


