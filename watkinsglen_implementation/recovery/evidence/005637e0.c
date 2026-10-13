/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005637e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005637e0(int param_1,undefined4 param_2)

{
  bool bVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  char cVar5;
  undefined4 uVar6;
  int iVar7;
  char cVar8;
  float10 fVar9;

  cVar5 = FUN_0055ab10(*(undefined4 *)(param_1 + 0x5b2));
  FUN_005f74c0(param_1 + 0x1530,param_1 + 0x1534,param_1 + 0x1538,*(int *)(param_1 + 0x5ae) + 0x58);
  cVar8 = (char)param_2;
  if (cVar5 == '\0') {
    fVar2 = *(float *)(param_1 + 0x150c) + *(float *)(param_1 + 0x1508);
    bVar1 = _DAT_006ecff8 <= fVar2;
    *(float *)(param_1 + 0x1508) = fVar2;
    if (bVar1) {
      if (_DAT_006f51f4 < fVar2) {
        *(undefined4 *)(param_1 + 0x1508) = 0x46fa0000;
      }
    }
    else {
      *(undefined4 *)(param_1 + 0x1508) = 0x43960000;
    }
    fVar2 = *(float *)(param_1 + 0x1514) + *(float *)(param_1 + 0x1510);
    bVar1 = _DAT_006ea454 <= fVar2;
    *(float *)(param_1 + 0x1510) = fVar2;
    if (bVar1) {
      if (_DAT_006e97d8 < fVar2) {
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
    uVar6 = FUN_004284f0(param_1 + 0x58e);
    uVar6 = FUN_00565830(*(uint *)(param_1 + 0x14fc) & 7,uVar6);
    FUN_00565840(param_1 + 0x1588,param_1 + 0x158c,*(uint *)(param_1 + 0x14fc) & 7,uVar6);
    if (cVar8 == '\0') {
      uVar6 = (&DAT_00883500)[*(int *)(param_1 + 0x5b2)];
LAB_005639a2:
      uVar6 = FUN_00592db0(param_1,uVar6,1);
      FUN_0054b0d0(uVar6);
    }
  }
  else if (cVar8 == '\0') {
    iVar7 = FUN_005c2d20(DAT_00c08194);
    uVar6 = DAT_00c7e75c;
    if (iVar7 != 1) goto LAB_005639a2;
    FUN_00551990(param_1);
  }
  else {
    FUN_00565770(param_1);
    uVar6 = FUN_004284f0(param_1 + 0x58e);
    uVar6 = FUN_00565830(*(uint *)(param_1 + 0x14fc) & 7,uVar6);
    FUN_00565840(param_1 + 0x1588,param_1 + 0x158c,*(uint *)(param_1 + 0x14fc) & 7,uVar6);
  }
  if (*(float *)(param_1 + 0x1518) < *(float *)(param_1 + 0x1508)) {
    *(undefined4 *)(param_1 + 0x1518) = *(undefined4 *)(param_1 + 0x1508);
  }
  fVar3 = _DAT_006e97d8;
  fVar2 = _DAT_006e97d8 - *(float *)(param_1 + 0x1510);
  fVar2 = (*(float *)(param_1 + 0x1508) - _DAT_006f4630) * fVar2 * fVar2 * _DAT_006f5e2c -
          _DAT_006e97d8;
  *(float *)(param_1 + 0x15b0) = fVar2;
  if (fVar3 < fVar2) {
    if (_DAT_006f5e28 < fVar2) {
      *(undefined4 *)(param_1 + 0x15b0) = 0x4079999a;
    }
    fVar9 = (float10)FUN_006c522a();
    fVar9 = (float10)*(float *)(param_1 + 0x15b0) - fVar9 * (float10)_DAT_006f5950;
    *(float *)(param_1 + 0x15b0) = (float)fVar9;
    if ((float10)_DAT_006ea454 <= fVar9) goto LAB_00563ad4;
  }
  *(undefined4 *)(param_1 + 0x15b0) = 0;
LAB_00563ad4:
  iVar7 = *(int *)(param_1 + 0x5ae);
  fVar2 = *(float *)(iVar7 + 0xc) - DAT_00e0b840;
  fVar3 = *(float *)(iVar7 + 0x10) - DAT_00e0b844;
  fVar4 = *(float *)(iVar7 + 0x14) - DAT_00e0b848;
  *(undefined4 *)(param_1 + 0x59e) = 0x3f800000;
  *(undefined4 *)(param_1 + 0x5a2) = 0x3f800000;
  *(undefined4 *)(param_1 + 0x5a6) = 0x3f800000;
  *(float *)(param_1 + 0x5aa) = SQRT(fVar2 * fVar2 + fVar3 * fVar3 + fVar4 * fVar4);
  if (cVar8 == '\0') {
    iVar7 = FUN_0055a610();
  }
  else {
    iVar7 = FUN_00503470();
  }
  if (*(int *)(iVar7 + 0xc) == param_1) {
    FUN_005afd80(param_1);
  }
  if (DAT_00c53458 == '\0') {
    *(undefined4 *)(param_1 + 0x1196) = 0;
  }
  else {
    fVar2 = *(float *)(param_1 + 0x5aa) * *(float *)(param_1 + 0x5aa) * *(float *)(param_1 + 0x5aa)
            * *(float *)(param_1 + 0x5a2);
    if (_DAT_006f5dc4 < fVar2) {
      fVar2 = _DAT_006f5dc4;
    }
    *(float *)(param_1 + 0x1196) = (_DAT_006e97d8 / _DAT_006f5dc4) * fVar2;
  }
  if (cVar8 == '\0') {
    FUN_00564b80(param_1,cVar5);
  }
  FUN_00563bd0(param_1,param_2);
  return;
}
