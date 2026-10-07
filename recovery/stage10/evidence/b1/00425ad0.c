/* NR2003.exe @ 00425ad0 FUN_00425ad0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00425ad0(float param_1)

{
  int iVar1;
  int iVar2;
  float *pfVar3;
  float *pfVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  int iVar7;
  int iVar8;
  
  iVar1 = (int)param_1;
  iVar2 = FUN_00432cf0((int)param_1 + 0xef1);
  param_1 = _DAT_00871a38 * _DAT_006ed7ac * _DAT_006ea67c * *(float *)(iVar2 + 0x1c0);
  if (param_1 <= _DAT_006ea454) {
    param_1 = 0.0;
  }
  else {
    param_1 = _DAT_006e97d8 / param_1;
  }
  pfVar3 = (float *)FUN_00557d60(0x5b);
  *pfVar3 = param_1;
  pfVar3 = (float *)FUN_00557d60(0x5c);
  pfVar4 = (float *)FUN_00557d60(0x31);
  iVar7 = 0;
  *pfVar3 = _DAT_006ed7ac * *pfVar4;
  iVar8 = 0x4c;
  do {
    puVar5 = (undefined4 *)FUN_00557d60(iVar8 + -1);
    *puVar5 = 0x4393afa5;
    puVar5 = (undefined4 *)FUN_00557d60(iVar8);
    *puVar5 = 0x4393afa5;
    puVar5 = (undefined4 *)FUN_00557d60(iVar8 + 1);
    *puVar5 = 0x4393afa5;
    puVar5 = (undefined4 *)FUN_00557d60(iVar7 + 0x47);
    puVar6 = (undefined4 *)FUN_00557d60(iVar7);
    *puVar5 = *puVar6;
    puVar5 = (undefined4 *)FUN_00557d60(iVar7 + 0x57);
    iVar8 = iVar8 + 3;
    iVar7 = iVar7 + 1;
    *puVar5 = 0;
  } while (iVar8 < 0x58);
  pfVar3 = (float *)FUN_00557d60(0x31);
  pfVar4 = (float *)FUN_00557d60(0x62);
  *pfVar4 = (*(float *)(iVar2 + 8) + *pfVar3 + _DAT_006ed7c8) * _DAT_006ed7a4;
  FUN_00425690(iVar1);
  FUN_004257a0(iVar1);
  FUN_00425900(iVar1);
  FUN_00425a30(iVar1);
  FUN_00424860(iVar1);
  return;
}

