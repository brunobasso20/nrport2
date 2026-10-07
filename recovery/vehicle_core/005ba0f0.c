/* Ghidra pseudo-C; NR2003.exe @ 005ba0f0 */

int * __fastcall FUN_005ba0f0(int *param_1)

{
  char cVar1;
  int *piVar2;
  
  cVar1 = FUN_005ba080();
  if (cVar1 != '\0') {
    return param_1 + 0xbc;
  }
                    /* WARNING: Could not recover jumptable at 0x005ba10c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  piVar2 = (int *)(**(code **)(*param_1 + 0x18))();
  return piVar2;
}

