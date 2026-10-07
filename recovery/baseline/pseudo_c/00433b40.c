/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00433b40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00433b40(int param_1,int param_2,int param_3)

{
  int iVar1;
  undefined *puVar2;
  float10 fVar3;
  float10 fVar4;
  float fVar5;
  int iVar6;
  int iVar7;
  float10 fVar8;
  
  iVar7 = 0;
  puVar2 = (&PTR_DAT_00725ab8)[param_3 + param_2 * 6];
  do {
    iVar1 = param_1 + iVar7 * 0x14;
    *(float *)(param_1 + (iVar7 * 5 + 0x50) * 4) =
         *(float *)(puVar2 + 0x48) * *(float *)(puVar2 + 0x38);
    fVar5 = *(float *)(puVar2 + 0x3c) * _DAT_006ea44c;
    *(float *)(iVar1 + 0x144) = fVar5;
    if (iVar7 == 1) {
      *(float *)(param_1 + 0x158) = -fVar5;
    }
    fVar8 = (float10)FUN_00579e80(0x12,1);
    fVar3 = (float10)_DAT_006ee5e8;
    fVar4 = (float10)_DAT_006ee5e4;
    iVar6 = FUN_0056ed60(iVar7);
    *(float *)(iVar1 + 0x148) =
         -(((float)(fVar4 - fVar3 / fVar8) + *(float *)(puVar2 + 0x5c)) -
          *(float *)(*(int *)(PTR_PTR_00734368 + iVar6 * 4) + 8));
    iVar6 = FUN_0056ed60(iVar7);
    iVar7 = iVar7 + 1;
    *(undefined4 *)(iVar1 + 0x14c) = *(undefined4 *)(*(int *)(PTR_PTR_00734368 + iVar6 * 4) + 8);
  } while (iVar7 < 2);
  for (; iVar7 < 4; iVar7 = iVar7 + 1) {
    iVar1 = param_1 + iVar7 * 0x14;
    *(float *)(param_1 + (iVar7 * 5 + 0x50) * 4) =
         -((_DAT_006e97d8 - *(float *)(puVar2 + 0x48)) * *(float *)(puVar2 + 0x38));
    fVar5 = *(float *)(puVar2 + 0x40) * _DAT_006ea44c;
    *(float *)(iVar1 + 0x144) = fVar5;
    if (iVar7 == 3) {
      *(float *)(param_1 + 0x180) = -fVar5;
    }
    fVar8 = (float10)FUN_00579e80(0x12,1);
    fVar3 = (float10)_DAT_006ee5e8;
    fVar4 = (float10)_DAT_006ea4a4;
    iVar6 = FUN_0056ed60(iVar7);
    *(float *)(iVar1 + 0x148) =
         -(((float)(fVar4 - fVar3 / fVar8) + *(float *)(puVar2 + 0x5c)) -
          *(float *)(*(int *)(PTR_PTR_00734368 + iVar6 * 4) + 8));
    iVar6 = FUN_0056ed60(iVar7);
    *(undefined4 *)(iVar1 + 0x14c) = *(undefined4 *)(*(int *)(PTR_PTR_00734368 + iVar6 * 4) + 8);
  }
  return;
}


