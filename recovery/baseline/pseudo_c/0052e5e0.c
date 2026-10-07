/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052e5e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __fastcall FUN_0052e5e0(int param_1)

{
  float fVar1;
  uint uVar2;
  uint uVar3;
  double dVar4;
  float *pfVar5;
  int *piVar6;
  int iVar7;
  uint *puVar8;
  uint *puVar9;
  int iVar10;
  float10 fVar11;
  undefined4 uVar12;
  float local_8 [2];
  
  fVar1 = *(float *)(param_1 + 0x54c);
  FUN_005f5890(param_1 + 0x524);
  puVar9 = *(uint **)(param_1 + 0x520);
  puVar8 = *(uint **)(param_1 + 0x518);
  iVar10 = 2;
  pfVar5 = local_8;
  do {
    uVar2 = *puVar8;
    uVar3 = *puVar9;
    puVar8 = puVar8 + 1;
    puVar9 = puVar9 + 1;
    iVar10 = iVar10 + -1;
    *pfVar5 = (float)(uVar2 ^ uVar3);
    pfVar5 = pfVar5 + 1;
  } while (iVar10 != 0);
  FUN_005f58a0(param_1 + 0x524);
  dVar4 = (double)CONCAT44(local_8[1],local_8[0]);
  local_8[0] = (float)dVar4;
  if (dVar4 <= (double)fVar1 * (double)_DAT_006ea62c) {
    iVar10 = FUN_005099b0();
    if (iVar10 == 7) {
      uVar12 = *(undefined4 *)(param_1 + 0x5b2);
      piVar6 = (int *)FUN_00538ab0();
      (**(code **)(*piVar6 + 0x30))(uVar12);
      iVar10 = FUN_005443c0(uVar12);
      iVar7 = FUN_00509a00();
      iVar10 = (iVar7 - iVar10) + -1;
    }
    else {
      iVar10 = *(int *)(param_1 + 0x1b06) - *(int *)(param_1 + 0x1a7a);
      if (iVar10 < 0) {
        return 0;
      }
    }
    if (3 < iVar10) {
      return 1;
    }
    if (0 < iVar10) {
      iVar7 = FUN_005099b0();
      if ((iVar7 == 7) && (*(float *)(param_1 + 0x186a) < _DAT_006ecfc8)) {
        return 0;
      }
      fVar11 = (float10)FUN_00516e1a();
      if ((float10)local_8[0] /
          (((float10)(iVar10 + 1) - (float10)*(float *)(param_1 + 0x186a) / fVar11) * (float10)fVar1
          ) < (float10)_DAT_006e97d8) {
        return 1;
      }
    }
  }
  return 0;
}


