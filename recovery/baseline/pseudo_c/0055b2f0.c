/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055b2f0 */

void FUN_0055b2f0(int param_1)

{
  int iVar1;
  
  iVar1 = FUN_00562f70(*(byte *)(param_1 + 7) & 0x7f);
  if (*(char *)(iVar1 + 0x59a) != '\0') {
    FUN_005a0590(param_1,DAT_00c087a4);
    FUN_005a2fd0(iVar1,param_1);
    FUN_005a1810(param_1);
  }
  return;
}


