/* NR2003.exe @ 0051a730 FUN_0051a730 */

void __thiscall FUN_0051a730(int param_1_00,undefined4 param_1,int param_2,undefined4 param_3)

{
  int *piVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  int iVar4;
  int *piVar5;
  int *piVar6;
  
  *(undefined4 *)(param_1_00 + 0x56e) = param_1;
  *(int *)(param_1_00 + 0x566) = param_2;
  piVar1 = (int *)(param_1_00 + 0x444);
  *(undefined4 *)(param_1_00 + 0x56a) = *(undefined4 *)(PTR_PTR_DAT_00727280 + param_2 * 4);
  piVar5 = (int *)(*(int *)(PTR_PTR_DAT_00727280 + param_2 * 4) + 0x44);
  piVar6 = piVar1;
  for (iVar4 = 10; iVar4 != 0; iVar4 = iVar4 + -1) {
    *piVar6 = *piVar5;
    piVar5 = piVar5 + 1;
    piVar6 = piVar6 + 1;
  }
  iVar4 = 0;
  if (*piVar1 != -2 && -1 < *piVar1 + 2) {
    puVar3 = (undefined4 *)(param_1_00 + 0x448);
    do {
      puVar2 = (undefined4 *)FUN_00557d60(iVar4 + 0x66);
      iVar4 = iVar4 + 1;
      *puVar3 = *puVar2;
      puVar3 = puVar3 + 1;
    } while (iVar4 < *piVar1 + 2);
  }
  puVar3 = (undefined4 *)FUN_00557d60(0x6e);
  *(undefined4 *)(param_1_00 + 0x468) = *puVar3;
  *(undefined4 *)(param_1_00 + 0x46c) = param_3;
  return;
}

