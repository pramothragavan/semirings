/*
 * aisemirings: Enumerate/count (ai-)semirings
 */

#include <gap_all.h> // GAP headers
#include <stdbool.h>

Obj FuncIsLeftRightDistributive(Obj self, Obj A, Obj M) {

  Int n = LEN_PLIST(A);

  for (Int x = 1; x <= n; x++) {
    for (Int y = 1; y <= n; y++) {
      for (Int z = y; z <= n; z++) {  // instead of z = y + 1? doesn't seem to have an impact, but feels like it should
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

Obj FuncFindAdditiveIdentity(Obj self, Obj table) {
  Int n = LEN_PLIST(table);
  Obj okay;
  for (Int id = 1; id <= n; id++) {
    okay = True;
    for (Int i = 1; i <= n; i++) {
      if (ELM_MAT(table, INTOBJ_INT(id), INTOBJ_INT(i)) != INTOBJ_INT(i) ||
            ELM_MAT(table, INTOBJ_INT(i), INTOBJ_INT(id)) != INTOBJ_INT(i)) {
        okay = False;
        break;
      }
    }
    if (okay == True) {
      return INTOBJ_INT(id);
    }
  }
  return Fail;
}

Obj FuncFindMultiplicativeZero(Obj self, Obj table) {
  Int n = LEN_PLIST(table);
  Obj okay;
  for (Int z = 1; z <= n; z++) {
    okay = True;
    for (Int i = 1; i <= n; i++) {
      if (ELM_MAT(table, INTOBJ_INT(z), INTOBJ_INT(i)) != INTOBJ_INT(z) ||
            ELM_MAT(table, INTOBJ_INT(i), INTOBJ_INT(z)) != INTOBJ_INT(z)) {
        okay = False;
        break;
      }
    }
    if (okay == True) {
      return INTOBJ_INT(z);
    }
  }
  return Fail;
}

// Table of functions to export
static StructGVarFunc GVarFuncs[] = {
    GVAR_FUNC(IsLeftRightDistributive, 2, "A, M"),
    GVAR_FUNC(PermuteMultiplicationTable, 3, "temp, M, p"),
    GVAR_FUNC(FindAdditiveIdentity, 1, "table"),
    GVAR_FUNC(FindMultiplicativeZero, 1, "table"),
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
