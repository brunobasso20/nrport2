/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0057da40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0057da40(undefined4 param_1,undefined4 *param_2)

{
  undefined4 *puVar1;
  int iVar2;
  
  puVar1 = param_2;
  if (*(float *)*param_2 == _DAT_006ea454) {
    param_2 = (undefined4 *)0x3f800000;
  }
  else {
    param_2 = (undefined4 *)(_DAT_006e97d8 / *(float *)*param_2);
  }
  iVar2 = FUN_0057c890(puVar1);
  if (iVar2 != 0) {
    FUN_0057c990(param_1,param_2);
    FUN_005b9b30(param_1,puVar1);
    return;
  }
  FUN_0057ca60();
  return;
}


