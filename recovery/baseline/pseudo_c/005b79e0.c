/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b79e0 */

void __thiscall FUN_005b79e0(int param_1_00,int param_1,undefined4 param_2,char param_3)

{
  int iVar1;
  
  if (0 < param_1) {
    iVar1 = *(int *)(param_1_00 + 8);
    FUN_005b7c80(**(int **)(param_1_00 + 0x18) * iVar1 + *(int *)(param_1_00 + 0x14),
                 *(int *)(param_1_00 + 0x14),*(int *)(param_1_00 + 4) * iVar1,param_2,param_2,
                 iVar1 * param_1,iVar1 * param_1);
    iVar1 = *(int *)(param_1_00 + 4);
    param_1 = **(int **)(param_1_00 + 0x18) + param_1;
    if (0 < iVar1) {
      for (; iVar1 <= param_1; param_1 = param_1 - iVar1) {
      }
    }
    **(int **)(param_1_00 + 0x18) = param_1;
    if ((param_3 != '\0') && (*(int *)(param_1_00 + 0xc) != 0)) {
      (*DAT_0103b4cc)(*(int *)(param_1_00 + 0xc));
    }
  }
  return;
}


