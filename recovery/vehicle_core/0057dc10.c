/* Ghidra pseudo-C; NR2003.exe @ 0057dc10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0057dc10(undefined4 param_1,undefined4 *param_2)

{
  undefined4 *puVar1;
  int iVar2;
  
  puVar1 = param_2;
  param_2 = *(undefined4 **)*param_2;
  if (_DAT_006ea454 < (float)param_2) {
    param_2 = (undefined4 *)0x0;
  }
  iVar2 = FUN_0057c890(puVar1);
  if (iVar2 != 0) {
    FUN_0057c990(param_1,param_2);
    FUN_005b9bb0(param_1,puVar1);
    return;
  }
  FUN_0057ca60();
  return;
}

