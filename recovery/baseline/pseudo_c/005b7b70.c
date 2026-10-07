/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b7b70 */

void __fastcall FUN_005b7b70(int param_1)

{
  **(undefined1 **)(param_1 + 0x20) = 1;
  if (*(int *)(param_1 + 0x10) != 0) {
    (*DAT_0103b4c8)(*(int *)(param_1 + 0x10));
  }
  return;
}


