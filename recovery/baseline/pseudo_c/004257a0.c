/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004257a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004257a0(int param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  int *piVar5;
  int iVar6;
  float *pfVar7;
  float *pfVar8;
  float *pfVar9;
  undefined4 local_8;
  
  iVar4 = param_1;
  piVar5 = (int *)FUN_00557d70(0x2b);
  iVar6 = *piVar5;
  piVar5 = (int *)FUN_00557d70(0x2c);
  param_1 = *piVar5;
  if (iVar6 == 0) {
    local_8 = 0.0;
  }
  else {
    local_8 = -((((float)(iVar6 + 0xd) * _DAT_006ee398 - _DAT_006e97d8) * _DAT_006ee394 +
                _DAT_006ee358) * _DAT_006ed7bc);
  }
  if (param_1 != 0) {
    param_1 = param_1 + 9;
  }
  fVar1 = (float)param_1 * _DAT_006ee390;
  fVar1 = _DAT_006ee364 -
          fVar1 * fVar1 * fVar1 * fVar1 * _DAT_006ee38c * _DAT_006ed7bc * _DAT_006ee388;
  iVar6 = FUN_00432cf0(iVar4 + 0xef1);
  pfVar7 = (float *)FUN_00557d60(99);
  *pfVar7 = local_8;
  pfVar7 = (float *)FUN_00557d60(0x15);
  pfVar8 = (float *)FUN_00557d60(99);
  pfVar9 = (float *)FUN_00557d60(0x14);
  fVar2 = *(float *)(iVar6 + 0x3c) * *(float *)(iVar6 + 0x3c) *
          (*pfVar8 + *pfVar8 + *pfVar9 + *pfVar7) * _DAT_006ea50c;
  pfVar7 = (float *)FUN_00557d60(100);
  *pfVar7 = fVar1;
  pfVar7 = (float *)FUN_00557d60(0x17);
  pfVar8 = (float *)FUN_00557d60(100);
  pfVar9 = (float *)FUN_00557d60(0x16);
  fVar3 = (*pfVar7 + *pfVar9) * _DAT_006ee384;
  fVar1 = *pfVar8;
  pfVar7 = (float *)FUN_00557d60(0x5d);
  *pfVar7 = (fVar2 * _DAT_006ed00c) / (fVar3 + fVar1 + fVar2);
  return;
}


