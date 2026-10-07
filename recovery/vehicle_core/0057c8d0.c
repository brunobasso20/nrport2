/* Ghidra pseudo-C; NR2003.exe @ 0057c8d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_0057c8d0(undefined4 param_1)

{
  int iVar1;
  undefined4 *extraout_ECX;
  
  iVar1 = FUN_0057c8b0(param_1);
  if ((iVar1 != 0) && (*(float *)*extraout_ECX == _DAT_006ea454)) {
    return 1;
  }
  return 0;
}

