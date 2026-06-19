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
Version := "1.0.0",
Date := "19/06/2026", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
  LastName       := "Edwards",
  FirstNames     := "Joseph",
  IsAuthor       := true,
  IsMaintainer   := true,
  Email          := "jde1@st-andrews.ac.uk",
  GithubUsername := "Joseph-Edwards",
  PostalAddress := Concatenation(
              "Mathematical Institute\n",
              "North Haugh\n",
              "St Andrews\n",
              "Fife\n",
              "KY16 9SS\n",
              "Scotland" ),
  Place          := "St Andrews",
  Institution    := "University of St Andrews",
  WWWHome        := "https://joseph-edwards.github.io/"),
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
    Email := "pramoth.ragavan@gmail.com",
    IsAuthor := true,
    IsMaintainer := true,
    #PostalAddress := TODO,
    #Place := TODO,
    Institution := "University of St Andrews",
  )
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
  NeededOtherPackages := [["semigroups", ">= 5.5"],
                          ["smallsemi", ">= 0.7.2"]],
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


