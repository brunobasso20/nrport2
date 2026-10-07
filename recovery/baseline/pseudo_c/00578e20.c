/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578e20 */

void __thiscall FUN_00578e20(int param_1_00,code *param_1)

{
  int iVar1;
  int *piVar2;
  
  iVar1 = *(int *)(param_1_00 + 4);
  for (piVar2 = (int *)(param_1_00 + 8); piVar2 != (int *)(param_1_00 + 8 + iVar1 * 4);
      piVar2 = piVar2 + 1) {
    if (*(int *)(*piVar2 + 0xc) != *(int *)(*(int *)(param_1_00 + 0x993c) + 0xc)) {
      (*param_1)(*(int *)(*piVar2 + 0xc));
    }
  }
  return;
}


