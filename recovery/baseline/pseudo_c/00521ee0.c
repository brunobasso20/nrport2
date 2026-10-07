/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00521ee0 */

void __thiscall FUN_00521ee0(int param_1_00,char param_1)

{
  int iVar1;
  
  if (*(int *)(param_1_00 + 0x89) != 0) {
    iVar1 = *(int *)(*(int *)(param_1_00 + 0x89) + 0x5b2);
    if (param_1 != '\0') {
      FUN_005f5f80(&DAT_00c08874 + iVar1 * 0x32c);
      FUN_005f5f80(&DAT_00b32eec + *(int *)(*(int *)(param_1_00 + 0x89) + 0x5b2) * 0x32c);
      return;
    }
    FUN_005f5f90(&DAT_00c08874 + iVar1 * 0x32c);
    FUN_005f5f90(&DAT_00b32eec + *(int *)(*(int *)(param_1_00 + 0x89) + 0x5b2) * 0x32c);
  }
  return;
}


