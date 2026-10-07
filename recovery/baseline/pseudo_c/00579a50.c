/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00579a50 */

void __thiscall FUN_00579a50(int param_1_00,int param_1)

{
  if (*(char *)(param_1 + 0x58) == '\0') {
    *(int *)(param_1_00 + 8 + *(int *)(param_1_00 + 4) * 4) = param_1;
    *(int *)(param_1_00 + 4) = *(int *)(param_1_00 + 4) + 1;
    *(undefined1 *)(param_1 + 0x58) = 1;
  }
  return;
}


