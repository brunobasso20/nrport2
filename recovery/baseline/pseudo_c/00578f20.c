/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578f20 */

void __thiscall FUN_00578f20(int param_1_00,int param_1)

{
  int iVar1;
  
  iVar1 = *(int *)(param_1_00 + 0x9870 + param_1 * 4);
  if (iVar1 != 0) {
    *(undefined1 *)(iVar1 + 0x5a) = 0;
    iVar1 = *(int *)(param_1_00 + 0x9870 + param_1 * 4);
    if (((*(int *)(iVar1 + 0x54) != 0) && (*(char *)(iVar1 + 0x59) == '\0')) &&
       (*(char *)(iVar1 + 0x5a) == '\0')) {
      **(undefined4 **)(iVar1 + 0x54) = *(undefined4 *)(iVar1 + 0x50);
      if (*(int *)(iVar1 + 0x50) != 0) {
        *(undefined4 *)(*(int *)(iVar1 + 0x50) + 0x54) = *(undefined4 *)(iVar1 + 0x54);
      }
      *(undefined4 *)(iVar1 + 0x50) = 0;
      *(undefined4 *)(iVar1 + 0x54) = 0;
    }
  }
  return;
}


