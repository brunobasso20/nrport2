/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f6a80 */

void __thiscall FUN_004f6a80(int *param_1_00,int param_1,int param_2,int param_3)

{
  int *piVar1;
  undefined4 *puVar2;
  int iVar3;
  undefined4 *puVar4;
  int iVar5;
  
  param_2 = param_2 + param_3 * -0xc;
  *param_1_00 = 4;
  param_1_00[1] = 0;
  param_1_00[2] = 0;
  if (0 < param_2) {
    iVar5 = 0;
    param_1_00[2] = param_1;
    puVar4 = (undefined4 *)(param_1 + param_3 * 0xc);
    param_1_00[1] = param_3;
    if (0 < param_3) {
      iVar3 = 0;
      do {
        iVar5 = iVar5 + 1;
        *(undefined4 *)(iVar3 + param_1_00[2]) = 0xffffffff;
        *(undefined4 *)(param_1_00[2] + 8 + iVar3) = 0;
        *(undefined4 *)(param_1_00[2] + 4 + iVar3) = 0;
        iVar3 = iVar3 + 0xc;
      } while (iVar5 < param_1_00[1]);
    }
    puVar2 = (undefined4 *)((param_2 / *param_1_00) * *param_1_00 + (int)puVar4);
    iVar5 = 0;
    while (puVar4 < puVar2) {
      iVar3 = iVar5 * 0xc;
      *puVar4 = *(undefined4 *)(param_1_00[2] + 8 + iVar3);
      *(undefined4 **)(param_1_00[2] + 8 + iVar3) = puVar4;
      piVar1 = (int *)(param_1_00[2] + 4 + iVar3);
      *piVar1 = *piVar1 + 1;
      puVar4 = (undefined4 *)((int)puVar4 + *param_1_00);
      iVar5 = iVar5 + 1;
      if (iVar5 == param_1_00[1]) {
        iVar5 = 0;
      }
    }
  }
  return;
}


