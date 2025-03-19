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

void FuncPermuteMultiplicationTable(Obj self, Obj temp, Obj M, Obj p) {
  int n = LEN_LIST(M);

  int p_type = TNUM_OBJ(p);
  if (p_type == T_PERM2) {
      int deg_p = DEG_PERM2(p);
      Obj q = STOREDINV_PERM(p);
      if (q == 0) {
          q = INV(p);
          SET_STOREDINV_PERM(p, q);
        }
      int deg_q = DEG_PERM2(q);
      for (int i = 1; i <= n; i++) {
        Obj row = ELM_LIST(temp, i);
        int ii = IMAGE(i - 1, CONST_ADDR_PERM2(q), deg_q) + 1;
    
        for (int j = 1; j <= n; j++) {
          int home = Int_ObjInt(ELM_LIST(ELM_LIST(M, ii), IMAGE(j - 1, CONST_ADDR_PERM2(q), deg_q) + 1));
          int new_val = IMAGE(home - 1, CONST_ADDR_PERM2(p), deg_p) + 1;
          ASS_LIST(row, j, INTOBJ_INT(new_val));
        }
      }
    } else {
      int deg_p = DEG_PERM4(p);
      Obj q = STOREDINV_PERM(p);
      if (q == 0) {
          q = INV(p);
          SET_STOREDINV_PERM(p, q);
        }
      int deg_q = DEG_PERM4(q);
      for (int i = 1; i <= n; i++) {
        Obj row = ELM_LIST(temp, i);
        int ii = IMAGE(i - 1, CONST_ADDR_PERM4(q), deg_q) + 1;
    
        for (int j = 1; j <= n; j++) {
          int home = Int_ObjInt(ELM_LIST(ELM_LIST(M, ii), IMAGE(j - 1, CONST_ADDR_PERM4(q), deg_q) + 1));
          int new_val = IMAGE(home - 1, CONST_ADDR_PERM4(p), deg_p) + 1;
          ASS_LIST(row, j, INTOBJ_INT(new_val));
        }
      }
    }
  CHANGED_BAG(temp);
}

// Table of functions to export
static StructGVarFunc GVarFuncs[] = {
    GVAR_FUNC(IsLeftRightDistributive, 2, "A, M"),
    GVAR_FUNC(PermuteMultiplicationTable, 3, "temp, M, p"),
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
