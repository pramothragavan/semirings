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

typedef union {
  const UInt2 *ptr2;
  const UInt4 *ptr4;
} PermAddr;

static inline int GetImage(int element, const PermAddr addr, int deg, int type) {
  return (type == T_PERM2) ?
      IMAGE(element - 1, addr.ptr2, deg) + 1 :
      IMAGE(element - 1, addr.ptr4, deg) + 1;
}

void FuncPermuteMultiplicationTable(Obj self, Obj temp, Obj M, Obj p) {
  int n = LEN_LIST(M);
  int deg_p, deg_q;
  PermAddr addr_p, addr_q;
  int p_type, q_type;
  
  p_type = TNUM_OBJ(p);
  if (p_type == T_PERM2) {
      addr_p.ptr2 = CONST_ADDR_PERM2(p);
      deg_p = DEG_PERM2(p);
  } else {
      addr_p.ptr4 = CONST_ADDR_PERM4(p);
      deg_p = DEG_PERM4(p);
  }
  
  Obj q = STOREDINV_PERM(p);
  if (q == 0) {
      q = INV(p);
      SET_STOREDINV_PERM(p, q);
  }

  q_type = TNUM_OBJ(q);
  if (q_type == T_PERM2) {
      addr_q.ptr2 = CONST_ADDR_PERM2(q);
      deg_q = DEG_PERM2(q);
  } else {
      addr_q.ptr4 = CONST_ADDR_PERM4(q);
      deg_q = DEG_PERM4(q);
  }

  for (int i = 1; i <= n; i++) {
    Obj row = ELM_LIST(temp, i);
    int ii = GetImage(i, addr_q, deg_q, q_type);

    for (int j = 1; j <= n; j++) {
      int home = Int_ObjInt(ELM_LIST(ELM_LIST(M, ii), GetImage(j, addr_q, deg_q, q_type)));
      int new_val = GetImage(home, addr_p, deg_p, p_type);

      ASS_LIST(row, j, INTOBJ_INT(new_val));
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
