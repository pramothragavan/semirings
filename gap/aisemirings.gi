#
# aisemirings: Enumerate/count (ai-)semirings
#
# Implementations
#

# A = the additive semigroup, M the multiplicative
# BindGlobal("IsLeftRightDistributive",
# function(A, M)
#   local n, x, y, z;

#   if Size(A) <> Size(M) then
#     return false;
#   fi;

#   n  := Size(A);
#   x  := 0;

#   while x < n do
#     x := x + 1;
#     y := 0;
#     while y < n do
#       y := y + 1;
#       z := y;
#       while z < n do
#         z := z + 1;
#         if M[x, A[y, z]] <> A[M[x, y], M[x, z]] then
#           return false;
#         elif M[A[y, z], x] <> A[M[y, x], M[z, x]] then
#           return false;
#         fi;
#       od;
#     od;
#   od;
#   return true;
# end);

BindGlobal("PermuteMultiplicationTable",
function(M, sigma)
  local n, permuted, i, j, invSigma, sigmaImages, invSigmaImages;

  n              := Length(M);
  invSigma       := sigma ^ -1;
  sigmaImages    := List([1 .. n], i -> i ^ sigma);
  invSigmaImages := List([1 .. n], i -> i ^ invSigma);
  permuted       := List([1 .. n], i -> [1 .. n]);

  for i in [1 .. n] do
    for j in [1 .. n] do
      permuted[i][j] := sigmaImages[(M[invSigmaImages[i]][invSigmaImages[j]])];
    od;
  od;

  return permuted;
end);

BindGlobal("IsomorphismFilter",
function(S1, S2)
  local M1, M2, sigma, G;

  M1 := S1[2];
  M2 := S2[2];
  if S1[1] <> S2[1] then
    return false;
  fi;

  G  := S1[3];
  for sigma in G do
    if OnMultiplicationTable(M1, sigma) = M2 then
      return true;
    fi;
  od;
  return false;
end);

BindGlobal("EquivalenceFilter",
function(S1, S2)
  local M1, T1;

  if IsomorphismFilter(S1, S2) then
    return true;
  fi;
  M1 := S1[2];
  T1 := TransposedMat(M1);
  if T1 <> M1 then
    S1[2] := T1;
    return IsomorphismFilter(S1, S2);
  fi;
  return false;
end);

# reduce whole orbit to one representative
BindGlobal("CanonicalTwist",
function(M, autA)
  local sigma, min, temp;
  min := M;
  for sigma in autA do
    temp := OnMultiplicationTable(M, sigma);
    if temp < min then
      min := temp;
    fi;
  od;

  return min;
end);

# Function to enumerate ai-semirings using double cosets
BindGlobal("Finder",
function(allA, allM, autMs, map, shift)
  local A, AA, autA, list, M, autM, reps, sigma, M_sigma, j, i,
  temp, doubleCosetCache, value, count, gens, total;
  FLOAT.DIG         := 2;
  FLOAT.VIEW_DIG    := 4;
  FLOAT.DECIMAL_DIG := 4;

  # list  := [];
  i     := 0;
  count := 0;

  for A in allA do
    AA   := MultiplicationTable(A);
    autA := AutomorphismGroup(A);
    autA := Image(IsomorphismPermGroup(autA));

    j                := 0;
    # temp             := [];
    doubleCosetCache := HashMap();

    for M in allM do
      j    := j + 1;
      PrintFormatted("At {}%, found {} so far\r\c",
                Float((i * Length(allM) + j) * 100 /
                (Length(allA) * Length(allM))),
                count);

      if j <= Length(allM) - shift then
        autM := autMs[map[j]];
      else
        autM := autMs[map[j - shift]];
      fi;

      M    := MultiplicationTable(M);
      gens := GeneratorsSmallest(autM);

      value := doubleCosetCache[gens];
      if value <> fail then
        reps := value;
      else
        # Compute double coset reps: Aut(A)\S_n/Aut(M)
        reps := DoubleCosetRepsAndSizes(SymmetricGroup(Size(A)),
                                        autM, autA);
        reps                   := List(reps, x -> x[1]);
        doubleCosetCache[gens] := reps;
      fi;

      for sigma in reps do
        M_sigma := OnMultiplicationTable(M, sigma);
        if IsLeftRightDistributive(AA, M_sigma) then
          # AddSet(temp, M_sigma);
          count := count + 1;
        fi;
      od;
    od;
    i    := i + 1;
    # temp := List(temp, x -> [AA, x]);
    # UniteSet(list, temp);
  od;
    PrintFormatted("\nFound {} candidates!\n", count);
  return count;
end);

InstallGlobalFunction(AllAiSemirings,
function(n)
  local allA, allM, NSD, anti, autMs, autM_NSD, SD, autM_SD,
  uniqueAutMs, map, shift;
  allA := AllSmallSemigroups(n, IsBand, true, IsCommutative, true);
  PrintFormatted("Found {} candidates for A!\n", Length(allA));

  Print("Finding non-self-dual semigroups...\n");
  NSD      := AllSmallSemigroups(n, IsSelfDualSemigroup, false);
  shift    := Length(NSD);

  Print("Finding corresponding dual semigroups...\n");
  anti   := List(NSD, DualSemigroup);

  Print("Finding automorphism groups...\n");
  autM_NSD := List(NSD,
                  x -> Image(IsomorphismPermGroup(AutomorphismGroup(x))));

  Print("Adding in self-dual semigroups...\n");
  SD   := AllSmallSemigroups(n, IsSelfDualSemigroup, true);
  allM := Concatenation(SD, NSD, anti);
  PrintFormatted("Added in anti-iso! Found {} candidates for M!\n",
                  Length(allM));

  Print("Finding automorphism groups for self-dual semigroups...\n");
  autM_SD := List(SD, x -> Image(IsomorphismPermGroup(AutomorphismGroup(x))));
  autMs   := Concatenation(autM_SD, autM_NSD);

  uniqueAutMs := Set(autMs);
  uniqueAutMs := Unique(autMs);
  map         := List(autMs, g -> Position(uniqueAutMs, g));

  Unbind(NSD);
  Unbind(anti);
  Unbind(autM_NSD);
  Unbind(SD);
  Unbind(autM_SD);
  Unbind(autMs);
  CollectGarbage(true);

  Print("Finding ai-semirings...\n");
  return Finder(allA, allM, uniqueAutMs, map, shift);
 end);

 ######## ENUMERATOR VERSION ##############

# InstallGlobalFunction(AllAiSemirings,
# function(n)
#   local allA, allM, NSD, autMs, autM_NSD, SD, autM_SD, uniqueAutMs, map, shift;

#   allA := AllSmallSemigroups(n, IsBand, true, IsCommutative, true);
#   PrintFormatted("Found {} candidates for A!\n", Length(allA));

#   Print("Finding non-self-dual semigroups and their automorphism groups...\n");
#   NSD      := EnumeratorOfSmallSemigroups(n, IsSelfDualSemigroup, false);
#   shift    := Length(NSD);
#   autM_NSD := List(NSD,
#                    x -> Image(IsomorphismPermGroup(AutomorphismGroup(x))));

#   Print("Adding in self-dual semigroups and their automorphism groups...\n");
#   SD      := EnumeratorOfSmallSemigroups(n, IsSelfDualSemigroup, true);
#   autM_SD := List(SD, x -> Image(IsomorphismPermGroup(AutomorphismGroup(x))));

#   allM := EnumeratorByFunctions(SmallSemigroupEnumeratorFamily,
#     rec(
#       ElementNumber := function(enum, pos)
#         if pos <= Length(SD) then
#           return SD[pos];
#         elif pos <= Length(SD) + Length(NSD) then
#           return NSD[pos - Length(SD)];
#         else
#           return DualSemigroup(NSD[pos - Length(SD) - Length(NSD)]);
#         fi;
#       end,

#       NumberElement := function(enum, elm)
#         if elm in SD then
#           return Position(SD, elm);
#         elif elm in NSD then
#           return Length(SD) + Position(NSD, elm);
#         elif DualSemigroup(elm) in NSD then
#           return Length(SD) + Length(NSD) + Position(NSD, DualSemigroup(elm));
#         fi;

#         return fail;
#       end,

#       Length := function(enum) return Length(SD) + 2 * Length(NSD);
#     end));

#   PrintFormatted("Found {} candidates for M!\n",
#                   Length(allM));

#   Print("Storing only unique automorphism groups and unbinding variables...\n");
#   autMs       := Concatenation(autM_SD, autM_NSD);
#   uniqueAutMs := Unique(autMs);
#   map         := List(autMs, g -> Position(uniqueAutMs, g));

#   Unbind(autM_NSD);
#   Unbind(autM_SD);
#   Unbind(autMs);
#   CollectGarbage(true);

#   Print("Finding ai-semirings...\n");
#   return Finder(allA, allM, uniqueAutMs, map, shift);
# end);

# AllRingsWithOne := function(n)
#   local allA, allM;

#   allA := AllSmallSemigroups(n, IsGroupAsSemigroup, true, IsCommutative, true);
#   allM := AllSmallSemigroups(n, IsMonoidAsSemigroup, true);
#   allM := UpToIsomorphism(allM);
#   return Finder(allA, allM);
# end;

# AllRings := function(n)
#   local allA, allM;
#   allA := AllSmallSemigroups(n, IsGroupAsSemigroup, true, IsCommutative, true);
#   allM := AllSmallSemigroups(n);
#   allM := UpToIsomorphism(allM);
#   return Finder(allA, allM);
# end;