/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0057c900 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_0057c900(undefined4 param_1)

{
  int iVar1;
  undefined4 *extraout_ECX;
  
  iVar1 = FUN_0057c8b0(param_1);
  if ((iVar1 != 0) && (*(float *)*extraout_ECX == _DAT_006e97d8)) {
    return 1;
  }
  return 0;
}


