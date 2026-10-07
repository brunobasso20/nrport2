/* Ghidra pseudo-C; NR2003.exe @ 005b7bb0 */

int __thiscall FUN_005b7bb0(int param_1_00,int param_1)

{
  int *piVar1;
  int iVar2;
  
  iVar2 = FUN_005b7c00();
  if (iVar2 <= param_1) {
    return 0;
  }
  piVar1 = *(int **)(param_1_00 + 0x1c);
  if (*(int *)(param_1_00 + 4) <= *piVar1 + param_1) {
    return *(int *)(param_1_00 + 8) * ((param_1 - *(int *)(param_1_00 + 4)) + *piVar1) +
           *(int *)(param_1_00 + 0x14);
  }
  return *(int *)(param_1_00 + 8) * (*piVar1 + param_1) + *(int *)(param_1_00 + 0x14);
}

