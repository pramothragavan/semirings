/*
 * aisemirings: Enumerate/count (ai-)semirings
 */

#include <gap_all.h> // GAP headers

Obj FuncIsLeftRightDistributive(Obj self, Obj A, Obj M) {

  Int n = LEN_PLIST(A);

  for (Int x = 1; x <= n; x++) {
    for (Int y = 1; y <= n; y++) {
      for (Int z = y + 1; z <= n; z++) {
        if (ELM_MAT(M, INTOBJ_INT(x),
                    ELM_MAT(A, INTOBJ_INT(y), INTOBJ_INT(z))) !=
            ELM_MAT(A, ELM_MAT(M, INTOBJ_INT(x), INTOBJ_INT(y)),
                    ELM_MAT(M, INTOBJ_INT(x), INTOBJ_INT(z)))) {
          return False;
        }
        if (ELM_MAT(M, ELM_MAT(A, INTOBJ_INT(y), INTOBJ_INT(z)),
                    INTOBJ_INT(x)) !=
            ELM_MAT(A, ELM_MAT(M, INTOBJ_INT(z), INTOBJ_INT(x)),
                    ELM_MAT(M, INTOBJ_INT(y), INTOBJ_INT(x)))) {
          return False;
        }
      }
    }
  }
  return True;
}

Obj FuncPermuteMultiplicationTable(Obj self, Obj M, Obj sigma) {
  int n = LEN_LIST(M);

  int deg = DEG_PERM2(sigma);
  UInt2 *permArr = ADDR_PERM2(sigma);

  Obj invSigma = STOREDINV_PERM(sigma);
  if (invSigma == 0) {
    invSigma = INV(sigma);
    SET_STOREDINV_PERM(sigma, invSigma);
  }

  UInt2 *invPermArr = ADDR_PERM2(invSigma);

  Obj permuted = NEW_PLIST(T_PLIST, n);
  SET_LEN_PLIST(permuted, n);

  for (int i = 1; i <= n; i++) {
    Obj row = NEW_PLIST(T_PLIST, n);
    SET_LEN_PLIST(row, n);
    SET_ELM_PLIST(permuted, i, row);
  }

  for (int i = 1; i <= n; i++) {
    /* Compute invSigma image of i: i^invSigma = IMAGE(i-1, invPermArr, deg)+1
     */
    int invSigmaI = IMAGE(i - 1, invPermArr, deg) + 1;
    Obj rowM = ELM_LIST(M, invSigmaI); /* Get row of M at index i^invSigma */
    for (int j = 1; j <= n; j++) {
      int invSigmaJ = IMAGE(j - 1, invPermArr, deg) + 1;
      int mVal = Int_ObjInt(
          ELM_LIST(rowM, invSigmaJ)); /* Get M[invSigmaI][invSigmaJ] */

      Obj sigmaImage = INTOBJ_INT(IMAGE(mVal - 1, permArr, deg) + 1);

      Obj rowPerm = ELM_LIST(permuted, i);
      SET_ELM_PLIST(rowPerm, j, sigmaImage);
    }
  }
  return permuted;
}

// Table of functions to export
static StructGVarFunc GVarFuncs[] = {
    GVAR_FUNC(IsLeftRightDistributive, 2, "A, M"),
    GVAR_FUNC(PermuteMultiplicationTable, 2, "M, sigma"),
    {0} /* Finish with an empty entry */
};

/****************************************************************************
**
*F  InitKernel( <module> ) . . . . . . . .  initialise kernel data structures
*/
static Int InitKernel(StructInitInfo *module) {
  /* init filters and functions */
  InitHdlrFuncsFromTable(GVarFuncs);

  /* return success */
  return 0;
}

/****************************************************************************
**
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary(StructInitInfo *module) {
  /* init filters and functions */
  InitGVarFuncsFromTable(GVarFuncs);

  /* return success */
  return 0;
}

/****************************************************************************
**
*F  Init__Dynamic() . . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
    .type = MODULE_DYNAMIC,
    .name = "aisemirings",
    .initKernel = InitKernel,
    .initLibrary = InitLibrary,
};

StructInitInfo *Init__Dynamic(void) { return &module; }
