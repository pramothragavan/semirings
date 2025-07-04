#
# semirings: Enumerate semirings
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", "2018.02.14") then
    Error("AutoDoc version 2018.02.14 or newer is required.");
fi;

LoadPackage( "AutoDoc" );
AutoDoc( rec( scaffold := true,
              autodoc := true ,
              extrefs  := [ "ref", "smallsemi" ])
);
QUIT;