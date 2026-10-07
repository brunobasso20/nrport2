/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005568b0 */

undefined4 FUN_005568b0(int param_1)

{
  int iVar1;
  
  iVar1 = thunk_FUN_004efd80();
  if (iVar1 == 2) {
    return *(undefined4 *)(&DAT_0074cff0 + param_1 * 4);
  }
  return *(undefined4 *)(&DAT_0074cd58 + param_1 * 4);
}


