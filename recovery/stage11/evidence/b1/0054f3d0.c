/* NR2003.exe @ 0054f3d0 recovered_0054f3d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall recovered_0054f3d0(int param_1,float param_2,float param_3)

{
  float fVar1;
  float fVar2;
  uint uVar3;
  undefined4 uVar4;
  uint *puVar5;
  uint **ppuVar6;
  float fStack_4;
  
  fVar1 = *(float *)(param_1 + 0x48);
  fVar2 = (*(float *)(param_1 + 0x68) - *(float *)(param_1 + 100)) * _DAT_006ea50c +
          *(float *)(param_1 + 100);
  FUN_005f5890(param_1 + 0x278);
  fStack_4 = (float)(**(uint **)(param_1 + 0x26c) ^ **(uint **)(param_1 + 0x274));
  FUN_005f58a0(param_1 + 0x278);
  if (fVar2 < fStack_4) {
    FUN_005f5890(param_1 + 0x278);
    fStack_4 = (float)(**(uint **)(param_1 + 0x26c) ^ **(uint **)(param_1 + 0x274));
    FUN_005f58a0(param_1 + 0x278);
    fVar2 = (fStack_4 - fVar2) * *(float *)(param_1 + 0x4c);
    fVar2 = fVar2 * fVar2;
    fVar1 = fVar2 * fVar2 + fVar1;
  }
  param_3 = fVar1 * param_2 * param_3;
  if (_DAT_006ea454 < param_3) {
    ppuVar6 = (uint **)(param_1 + 0xa0);
    FUN_005f5890(param_1 + 0xac);
    FUN_00425e80(&param_2,*ppuVar6,*(undefined4 *)(param_1 + 0xa8),4);
    FUN_005f58a0(param_1 + 0xac);
    fStack_4 = param_2 + param_3;
    FUN_0051c3f0(&fStack_4);
    FUN_005f5890(param_1 + 0xac);
    param_2 = (float)(**ppuVar6 ^ **(uint **)(param_1 + 0xa8));
    FUN_005f58a0(param_1 + 0xac);
    if (_DAT_006e97d8 < param_2) {
      param_3 = 1.0;
      FUN_005f5890(param_1 + 0xac);
      param_2 = (float)(**(uint **)(param_1 + 0xa4) ^ DAT_00f72118);
      if (param_2 != (float)**ppuVar6) {
        do {
          DAT_00f7212c = FUN_005cfcfc();
        } while (DAT_00f7212c == 0);
      }
      uVar3 = FUN_005cfcfc();
      if ((uVar3 & 0x3f) == 0) {
        FUN_004f68c0(*(undefined4 *)(param_1 + 0xa8),4);
      }
      FUN_00425e80(*ppuVar6,&param_3,*(undefined4 *)(param_1 + 0xa8),4);
      FUN_00425e80(*(undefined4 *)(param_1 + 0xa4),&DAT_00f72118,*ppuVar6,4);
      uVar3 = FUN_005cfcfc();
      if ((uVar3 & 0x3ff) == 0) {
        uVar4 = FUN_0051c5d0(*(undefined4 *)(param_1 + 0xa8));
        *(undefined4 *)(param_1 + 0xa8) = uVar4;
      }
      uVar3 = FUN_005cfcfc();
      if ((uVar3 & 0x1ff) == 0) {
        puVar5 = (uint *)FUN_0051c5d0(*ppuVar6);
        *ppuVar6 = puVar5;
      }
      uVar3 = FUN_005cfcfc();
      if ((uVar3 & 0x7ff) == 0) {
        uVar4 = FUN_0051c5d0(*(undefined4 *)(param_1 + 0xa4));
        *(undefined4 *)(param_1 + 0xa4) = uVar4;
      }
      FUN_005f58a0(param_1 + 0xac);
    }
  }
  return;
}

