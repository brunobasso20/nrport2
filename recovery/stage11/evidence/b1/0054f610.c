/* NR2003.exe @ 0054f610 recovered_0054f610 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall recovered_0054f610(int param_1)

{
  uint **ppuVar1;
  float fVar2;
  uint uVar3;
  uint uVar4;
  undefined4 uVar5;
  int *piVar6;
  double dVar7;
  float fStack_14;
  float fStack_10;
  float fStack_c;
  float fStack_8;
  int iStack_4;
  
  uVar5 = FUN_0055ab00();
  piVar6 = (int *)FUN_00562f70(uVar5);
  iStack_4 = (**(code **)(*piVar6 + 8))();
  ppuVar1 = (uint **)(param_1 + 0x134);
  fVar2 = *(float *)(iStack_4 + 0x3c + *(int *)(param_1 + 0x6c) * 4);
  FUN_005f5890(param_1 + 0x140);
  uVar3 = **ppuVar1;
  uVar4 = **(uint **)(param_1 + 0x13c);
  FUN_005f58a0(param_1 + 0x140);
  fStack_14 = (float)(uVar3 ^ uVar4) * _DAT_006f5954;
  FUN_005f5890(param_1 + 0x278);
  uVar3 = **(uint **)(param_1 + 0x26c);
  uVar4 = **(uint **)(param_1 + 0x274);
  FUN_005f58a0(param_1 + 0x278);
  if (*(float *)(param_1 + 100) < (float)(uVar3 ^ uVar4)) {
    FUN_005f5890(param_1 + 0x278);
    uVar3 = **(uint **)(param_1 + 0x274);
    uVar4 = **(uint **)(param_1 + 0x26c);
    FUN_005f58a0(param_1 + 0x278);
    fStack_c = ((float)(uVar3 ^ uVar4) - *(float *)(param_1 + 100)) *
               (_DAT_006e97d8 / (*(float *)(param_1 + 0x68) - *(float *)(param_1 + 100)));
    if (_DAT_006e97d8 < fStack_c) {
      fStack_c = 1.0;
    }
    FUN_005f5890(param_1 + 0x140);
    FUN_00425e80(&fStack_8,*ppuVar1,*(undefined4 *)(param_1 + 0x13c),4);
    FUN_005f58a0(param_1 + 0x140);
    fStack_c = fStack_c * fStack_c;
    fStack_14 = fStack_c * fStack_8 * _DAT_006f4788 + fStack_14;
    if ((NAN(fVar2) || NAN(_DAT_006ea454)) == (fVar2 == _DAT_006ea454)) {
      FUN_005f5890(param_1 + 0x140);
      fStack_8 = (float)(**(uint **)(param_1 + 0x13c) ^ **ppuVar1);
      FUN_005f58a0(param_1 + 0x140);
      fStack_14 = fStack_c * fStack_8 * _DAT_006f4788 + fStack_14;
    }
    FUN_005f5890(param_1 + 0xac);
    FUN_00425e80(&fStack_8,*(undefined4 *)(param_1 + 0xa0),*(undefined4 *)(param_1 + 0xa8),4);
    FUN_005f58a0(param_1 + 0xac);
    if (_DAT_006ea470 < fStack_8) {
      FUN_005f5890(param_1 + 0x140);
      FUN_00425e80(&fStack_8,*ppuVar1,*(undefined4 *)(param_1 + 0x13c),4);
      FUN_005f58a0(param_1 + 0x140);
      fStack_14 = fStack_c * fStack_8 * _DAT_006f4788 + fStack_14;
    }
  }
  dVar7 = rndUniform(0);
  if (dVar7 < (double)fStack_14 != (NAN(dVar7) || NAN((double)fStack_14))) {
    dVar7 = rndUniform(0);
    fStack_10 = (float)dVar7 * (float)_DAT_006f4770 + fVar2 + _DAT_006ea470;
    if (_DAT_006e97d8 < fStack_10) {
      fStack_10 = 1.0;
    }
    FUN_0054b9f0(*(undefined4 *)(param_1 + 0x6c),fStack_10);
  }
  return;
}

