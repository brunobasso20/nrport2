/* NR2003.exe @ 005637e0 FUN_005637e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005637e0(int param_1,undefined4 param_2)

{
  bool bVar1;
  bool bVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  char cVar6;
  undefined4 uVar7;
  int iVar8;
  char cVar9;
  float10 fVar10;
  
  cVar6 = FUN_0055ab10(*(undefined4 *)(param_1 + 0x5b2));
  FUN_005f74c0(param_1 + 0x1530,param_1 + 0x1534,param_1 + 0x1538,*(int *)(param_1 + 0x5ae) + 0x58);
  cVar9 = (char)param_2;
  if (cVar6 == '\0') {
    fVar3 = *(float *)(param_1 + 0x150c) + *(float *)(param_1 + 0x1508);
    bVar1 = NAN(_DAT_006ecff8);
    bVar2 = fVar3 < _DAT_006ecff8;
    *(float *)(param_1 + 0x1508) = fVar3;
    if (bVar2 == (NAN(fVar3) || bVar1)) {
      if (_DAT_006f51f4 < fVar3) {
        *(undefined4 *)(param_1 + 0x1508) = 0x46fa0000;
      }
    }
    else {
      *(undefined4 *)(param_1 + 0x1508) = 0x43960000;
    }
    fVar3 = *(float *)(param_1 + 0x1514) + *(float *)(param_1 + 0x1510);
    bVar1 = NAN(_DAT_006ea454);
    bVar2 = fVar3 < _DAT_006ea454;
    *(float *)(param_1 + 0x1510) = fVar3;
    if (bVar2 == (NAN(fVar3) || bVar1)) {
      if (_DAT_006e97d8 < fVar3) {
        *(undefined4 *)(param_1 + 0x1510) = 0x3f800000;
      }
    }
    else {
      *(undefined4 *)(param_1 + 0x1510) = 0;
    }
    FUN_00564be0(param_1 + 0x1558,*(undefined4 *)(param_1 + 0x5ae));
    FUN_00564df0(param_1,param_2);
    FUN_00565770(param_1);
    *(undefined4 *)(param_1 + 0x151c) = 0x40accccd;
    *(undefined4 *)(param_1 + 0x1520) = 0x42be0000;
    *(undefined4 *)(param_1 + 0x1524) = 0x42b40000;
    *(undefined4 *)(param_1 + 0x1528) = 0x3f1cbc15;
    *(undefined4 *)(param_1 + 0x152c) = 0x415ccccd;
    *(undefined4 *)(param_1 + 0x1504) = 0;
    *(undefined4 *)(param_1 + 0x1500) = 0;
    FUN_005657e0(param_1);
    uVar7 = FUN_004284f0(param_1 + 0x58e);
    uVar7 = FUN_00565830(*(uint *)(param_1 + 0x14fc) & 7,uVar7);
    FUN_00565840(param_1 + 0x1588,param_1 + 0x158c,*(uint *)(param_1 + 0x14fc) & 7,uVar7);
    if (cVar9 == '\0') {
      uVar7 = (&DAT_00883500)[*(int *)(param_1 + 0x5b2)];
LAB_005639a2:
      uVar7 = FUN_00592db0(param_1,uVar7,1);
      FUN_0054b0d0(uVar7);
    }
  }
  else if (cVar9 == '\0') {
    iVar8 = FUN_005c2d20(DAT_00c08194);
    uVar7 = DAT_00c7e75c;
    if (iVar8 != 1) goto LAB_005639a2;
    FUN_00551990(param_1);
  }
  else {
    FUN_00565770(param_1);
    uVar7 = FUN_004284f0(param_1 + 0x58e);
    uVar7 = FUN_00565830(*(uint *)(param_1 + 0x14fc) & 7,uVar7);
    FUN_00565840(param_1 + 0x1588,param_1 + 0x158c,*(uint *)(param_1 + 0x14fc) & 7,uVar7);
  }
  if (*(float *)(param_1 + 0x1518) < *(float *)(param_1 + 0x1508)) {
    *(undefined4 *)(param_1 + 0x1518) = *(undefined4 *)(param_1 + 0x1508);
  }
  fVar4 = _DAT_006e97d8;
  fVar3 = _DAT_006e97d8 - *(float *)(param_1 + 0x1510);
  fVar3 = (*(float *)(param_1 + 0x1508) - _DAT_006f4630) * fVar3 * fVar3 * _DAT_006f5e2c -
          _DAT_006e97d8;
  *(float *)(param_1 + 0x15b0) = fVar3;
  if (fVar4 < fVar3) {
    if (_DAT_006f5e28 < fVar3) {
      *(undefined4 *)(param_1 + 0x15b0) = 0x4079999a;
    }
    fVar10 = (float10)FUN_006c522a();
    fVar10 = (float10)*(float *)(param_1 + 0x15b0) - fVar10 * (float10)_DAT_006f5950;
    *(float *)(param_1 + 0x15b0) = (float)fVar10;
    if (fVar10 < (float10)_DAT_006ea454 == (NAN(fVar10) || NAN((float10)_DAT_006ea454)))
    goto LAB_00563ad4;
  }
  *(undefined4 *)(param_1 + 0x15b0) = 0;
LAB_00563ad4:
  iVar8 = *(int *)(param_1 + 0x5ae);
  fVar3 = *(float *)(iVar8 + 0xc) - DAT_00e0b840;
  fVar4 = *(float *)(iVar8 + 0x10) - DAT_00e0b844;
  fVar5 = *(float *)(iVar8 + 0x14) - DAT_00e0b848;
  *(undefined4 *)(param_1 + 0x59e) = 0x3f800000;
  *(undefined4 *)(param_1 + 0x5a2) = 0x3f800000;
  *(undefined4 *)(param_1 + 0x5a6) = 0x3f800000;
  *(float *)(param_1 + 0x5aa) = SQRT(fVar3 * fVar3 + fVar4 * fVar4 + fVar5 * fVar5);
  if (cVar9 == '\0') {
    iVar8 = FUN_0055a610();
  }
  else {
    iVar8 = FUN_00503470();
  }
  if (*(int *)(iVar8 + 0xc) == param_1) {
    FUN_005afd80(param_1);
  }
  if (DAT_00c53458 == '\0') {
    *(undefined4 *)(param_1 + 0x1196) = 0;
  }
  else {
    fVar3 = *(float *)(param_1 + 0x5aa) * *(float *)(param_1 + 0x5aa) * *(float *)(param_1 + 0x5aa)
            * *(float *)(param_1 + 0x5a2);
    if (_DAT_006f5dc4 < fVar3) {
      fVar3 = _DAT_006f5dc4;
    }
    *(float *)(param_1 + 0x1196) = (_DAT_006e97d8 / _DAT_006f5dc4) * fVar3;
  }
  if (cVar9 == '\0') {
    FUN_00564b80(param_1,cVar6);
  }
  FUN_00563bd0(param_1,param_2);
  return;
}

