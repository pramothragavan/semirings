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

// Table of functions to export
static StructGVarFunc GVarFuncs[] = {
    GVAR_FUNC(IsLeftRightDistributive, 2, "A, M"),
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
