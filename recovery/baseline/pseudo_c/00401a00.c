/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00401a00 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall FUN_00401a00(int param_1)

{
  int iVar1;
  
  iVar1 = FUN_005099b0();
  if (iVar1 == 7) {
    FUN_00415210();
    iVar1 = FUN_00417fc0();
    if (iVar1 != 7) {
      return (float10)_DAT_0074b080 * (float10)_DAT_006e9810;
    }
  }
  return (float10)*(float *)(*(int *)PTR_DAT_00749378 + 0x18 + *(int *)(param_1 + 0x186e) * 0x1c);
}


