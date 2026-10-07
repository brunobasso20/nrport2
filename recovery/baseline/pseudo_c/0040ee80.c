/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040ee80 */

void __fastcall FUN_0040ee80(int param_1)

{
  int *piVar1;
  
  if (*(char *)(param_1 + 0x8d) != '\0') {
    piVar1 = (int *)FUN_00538b40();
    (**(code **)(*piVar1 + 0x38))(param_1 + 0x10d);
    return;
  }
  (**(code **)(*DAT_00bdb9d8 + 0x1c))
            (*(undefined4 *)(*(int *)(param_1 + 0x89) + 0x5b2),param_1 + 0x10d);
  return;
}


