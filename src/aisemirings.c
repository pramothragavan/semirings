/*
 * aisemirings: Enumerate/count (ai-)semirings
 */

#include <gap_all.h>    // GAP headers


Obj FuncTestCommand(Obj self)
{
    return INTOBJ_INT(42);
}

Obj FuncTestCommandWithParams(Obj self, Obj param, Obj param2)
{
    /* simply return the first parameter */
    return param;
}

Obj FuncIsLeftRightDistributive(Obj self, Obj A, Obj M)
{   
    unsigned int n, x, y, z;
    if LEN_PLIST(A) <> LEN_PLIST(M) then
        return False;
    
    n = LEN_PLIST(A);

    for (x = 0, x < n, x++)
    {
        for (y = 0, y < n, y++)
        {
            for (z = y + 1, z < n, z++)
            {
                
            }
        }
    }
    
}
// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
    GVAR_FUNC(TestCommand, 0, ""),
    GVAR_FUNC(TestCommandWithParams, 2, "param, param2"),
    GVAR_FUNC(IsLeftRightDistributive, 2, "A, M"),
    { 0 } /* Finish with an empty entry */
};

/****************************************************************************
**
*F  InitKernel( <module> ) . . . . . . . .  initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions */
    InitHdlrFuncsFromTable( GVarFuncs );

    /* return success */
    return 0;
}

/****************************************************************************
**
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

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

StructInitInfo *Init__Dynamic( void )
{
    return &module;
}
