/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577cb0 */

void __fastcall FUN_00577cb0(int param_1)

{
  int iVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  
  if (*(int *)(param_1 + 8) != 0) {
    fVar2 = *(float *)(*(int *)(param_1 + 0x38) + 0x24) -
            *(float *)(*(int *)(param_1 + 0x38) + 0x14);
    fVar3 = *(float *)(*(int *)(param_1 + 0x28) + 0x24) -
            *(float *)(*(int *)(param_1 + 0x28) + 0x14);
    fVar4 = *(float *)(*(int *)(param_1 + 0x2c) + 0x24) -
            *(float *)(*(int *)(param_1 + 0x2c) + 0x14);
    fVar5 = *(float *)(*(int *)(param_1 + 0x30) + 0x24) -
            *(float *)(*(int *)(param_1 + 0x30) + 0x14);
    fVar6 = *(float *)(*(int *)(param_1 + 0x34) + 0x24) -
            *(float *)(*(int *)(param_1 + 0x34) + 0x14);
    if (fVar3 < fVar2) {
      fVar2 = fVar3;
    }
    if (fVar4 < fVar2) {
      fVar2 = fVar4;
    }
    if (fVar6 < fVar5) {
      fVar5 = fVar6;
    }
    iVar1 = *(int *)(*(int *)(param_1 + 8) + 0x10);
    if (iVar1 != 0) {
      *(float *)(iVar1 + 0x14) = fVar2 * *(float *)(iVar1 + 8) + *(float *)(iVar1 + 0x14);
      iVar1 = *(int *)(iVar1 + 0x18);
      *(float *)(iVar1 + 0x14) = fVar5 * *(float *)(iVar1 + 8) + *(float *)(iVar1 + 0x14);
      iVar1 = *(int *)(*(int *)(*(int *)(*(int *)(*(int *)(*(int *)(*(int *)(iVar1 + 0x18) + 0x18) +
                                                          0x18) + 0x18) + 0x18) + 0x18) + 0x18);
      *(float *)(iVar1 + 0x14) = *(float *)(iVar1 + 8) * fVar2 + *(float *)(iVar1 + 0x14);
      iVar1 = *(int *)(iVar1 + 0x18);
      *(float *)(iVar1 + 0x14) = *(float *)(iVar1 + 8) * fVar2 + *(float *)(iVar1 + 0x14);
      return;
    }
  }
  return;
}


