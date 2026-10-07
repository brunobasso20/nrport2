/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578ec0 */

void __thiscall FUN_00578ec0(int param_1_00,int param_1)

{
  int *piVar1;
  int iVar2;
  int iVar3;
  
  iVar2 = *(int *)(param_1_00 + 0x9870 + param_1 * 4);
  if (iVar2 != 0) {
    if (*(int *)(iVar2 + 0x54) == 0) {
      piVar1 = (int *)(param_1_00 + 0x9930);
      if (*piVar1 != 0) {
        *(int *)(*piVar1 + 0x54) = iVar2 + 0x50;
      }
      iVar3 = *piVar1;
      *(int **)(iVar2 + 0x54) = piVar1;
      *(int *)(iVar2 + 0x50) = iVar3;
      *piVar1 = iVar2;
    }
    *(undefined1 *)(*(int *)(param_1_00 + 0x9870 + param_1 * 4) + 0x5a) = 1;
    return;
  }
  FUN_0055ab10(param_1);
  return;
}


