/* NR2003.exe @ 00583250 FUN_00583250 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

undefined4 FUN_00583250(float *param_1,float *param_2,undefined4 param_3,int param_4)

{
  float *pfVar1;
  float *pfVar2;
  float fVar3;
  float *pfVar4;
  int iVar5;
  int iVar6;
  double dVar7;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  if ((DAT_00750130 & 0x20) != 0) {
    iVar5 = FUN_006c5018();
    param_4 = taskGetRate();
    param_4 = param_4 * iVar5;
    fVar3 = _DAT_006e97d8 / (float)param_4;
    iVar6 = taskGetRate();
    local_24 = *param_1;
    local_20 = param_1[1];
    local_1c = param_1[2];
    local_4 = _DAT_006e97d8 / (float)iVar6;
    fVar3 = -fVar3;
    local_18 = fVar3 * *param_2;
    local_14 = fVar3 * param_2[1];
    local_10 = fVar3 * param_2[2];
    local_c = local_4 * *param_2;
    local_8 = local_4 * param_2[1];
    local_4 = local_4 * param_2[2];
    param_4 = iVar5;
    if (0 < iVar5) {
      do {
        iVar5 = FUN_00582320(&param_1,1);
        pfVar4 = param_1;
        if (iVar5 != 0) {
          param_1[0xb] = local_24;
          param_1[0xc] = local_20;
          param_1[0xd] = local_1c;
          param_2 = &local_18;
          local_24 = local_24 + local_18;
          local_20 = local_20 + local_14;
          local_1c = local_1c + local_10;
          dVar7 = rndUniform(0);
          pfVar4[0xb] = ((float)dVar7 - (float)_DAT_006ea668) * (float)_DAT_006efe40 + pfVar4[0xb];
          dVar7 = rndUniform(0);
          pfVar4[0xc] = ((float)dVar7 - (float)_DAT_006ea668) * (float)_DAT_006efe40 + pfVar4[0xc];
          dVar7 = rndUniform(0);
          pfVar1 = pfVar4 + 0x11;
          pfVar4[0xd] = ((float)dVar7 - (float)_DAT_006ea668) * (float)_DAT_006efe40 + pfVar4[0xd];
          dVar7 = rndUniform(0);
          *pfVar1 = ((float)dVar7 - (float)_DAT_006ea668) * _DAT_006ea4cc;
          dVar7 = rndUniform(0);
          pfVar4[0x12] = ((float)dVar7 - (float)_DAT_006ea668) * _DAT_006ea4cc;
          dVar7 = rndUniform(0);
          pfVar4[0x13] = ((float)dVar7 - (float)_DAT_006ea668) * _DAT_006ea4cc;
          dVar7 = rndUniform(0);
          fVar3 = (float)dVar7 * _DAT_006ee368;
          pfVar2 = pfVar4 + 0xe;
          *pfVar2 = local_c * fVar3;
          pfVar4[0xf] = local_8 * fVar3;
          pfVar4[0x10] = local_4 * fVar3;
          *pfVar2 = *pfVar2 + *pfVar1;
          pfVar4[0xf] = pfVar4[0xf] + pfVar4[0x12];
          pfVar4[0x10] = pfVar4[0x10] + pfVar4[0x13];
          pfVar4[10] = 4.484155e-44;
          pfVar4[7] = 0.0;
          *pfVar4 = 1000.0;
          param_2 = pfVar1;
        }
        param_4 = param_4 + -1;
      } while (param_4 != 0);
    }
  }
  return 1;
}

