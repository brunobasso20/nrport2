/* Ghidra pseudo-C; NR2003.exe @ 0057d1d0 */

void FUN_0057d1d0(undefined4 param_1,undefined4 param_2)

{
  int iVar1;
  
  iVar1 = FUN_0057c8b0(param_2);
  if (iVar1 != 0) {
    FUN_0057ccc0(&PTR_DAT_0074fda8,&PTR_DAT_0074fda8,param_2);
    return;
  }
  iVar1 = FUN_0057c8b0(param_1);
  if (iVar1 != 0) {
    FUN_0057ccc0(&PTR_DAT_0074fda8,&PTR_DAT_0074fda8,param_1);
    FUN_0057d040(param_1,param_2);
    return;
  }
  FUN_0057ccc0(param_1,param_1,param_2);
  return;
}

