/* NR2003.exe @ 005835b0 FUN_005835b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

undefined4
FUN_005835b0(float *param_1,float *param_2,float param_3,float param_4,undefined4 param_5)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  uint uVar5;
  float10 extraout_ST0;
  float10 fVar6;
  double dVar7;
  float fVar8;
  float local_30;
  float local_2c;
  float local_28;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_8;
  float local_4;
  
  iVar4 = taskGetRate();
  fVar8 = _DAT_006e97d8 / (float)iVar4;
  uVar5 = FUN_00583150(fVar8);
  if ((uVar5 & 1) != 0) {
    local_24 = param_3 * *param_2;
    local_20 = param_3 * param_2[1];
    local_1c = param_3 * param_2[2];
    fVar2 = *param_2 - local_24;
    fVar3 = DAT_00e0b840 * _DAT_006ea44c;
    local_8 = DAT_00e0b844 * _DAT_006ea44c;
    local_4 = DAT_00e0b848 * _DAT_006ea44c;
    fVar1 = (param_2[1] - local_20) - local_8;
    iVar4 = FUN_006c5018();
    local_30 = *param_1;
    local_2c = param_1[1];
    local_28 = param_1[2];
    fVar6 = (float10)_DAT_006e97d8 / (float10)(iVar4 + 1);
    dVar7 = rndUniform(0);
    FUN_00583800(&local_30,&local_24,((float)dVar7 * _DAT_006ef640 + _DAT_006f49dc) * param_4,
                 param_5);
    if (0 < iVar4) {
      do {
        local_30 = local_30 + (float)((float10)((fVar2 - fVar3) * -fVar8) * fVar6);
        local_2c = local_2c + (float)((float10)(fVar1 * -fVar8) * fVar6);
        local_28 = local_28 + (float)(extraout_ST0 * fVar6);
        dVar7 = rndUniform(0);
        local_18 = ((float)dVar7 * _DAT_006ea4cc + local_30) - _DAT_006ea508;
        dVar7 = rndUniform(0);
        local_14 = ((float)dVar7 * _DAT_006ea4cc + local_2c) - _DAT_006ea508;
        dVar7 = rndUniform(0);
        local_10 = ((float)dVar7 * _DAT_006ea4cc + local_28) - _DAT_006ea508;
        dVar7 = rndUniform(0);
        FUN_00583800(&local_18,&local_24,((float)dVar7 * _DAT_006ef640 + _DAT_006f49dc) * param_4,
                     param_5);
        iVar4 = iVar4 + -1;
      } while (iVar4 != 0);
    }
  }
  return 1;
}

