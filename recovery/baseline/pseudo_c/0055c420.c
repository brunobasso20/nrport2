/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055c420 */

void FUN_0055c420(ushort *param_1)

{
  int iVar1;
  
  if (*param_1 >> 10 == 0) {
    iVar1 = FUN_00562f70(*(uint *)(param_1 + 0x1e) & 0x7f);
    if (*(char *)(iVar1 + 0x59a) != '\0') {
      FUN_005a0390(param_1,DAT_00c087a4);
      FUN_005a2db0(iVar1,param_1);
      FUN_005a1740(param_1);
      *(undefined1 *)((int)&DAT_00c08138 + (*(uint *)(param_1 + 0x1e) & 0x7f)) = 1;
    }
  }
  else if (*param_1 >> 10 == 1) {
    FUN_005b0e60(&DAT_00c08138,param_1);
    return;
  }
  return;
}


