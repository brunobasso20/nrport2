/* NR2003.exe @ 005862c0 FUN_005862c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
FUN_005862c0(float *param_1,float *param_2,undefined4 param_3,float param_4,float param_5)

{
  float *pfVar1;
  char *pcVar2;
  ushort uVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  int iVar9;
  float *pfVar10;
  int iVar11;
  int iVar12;
  byte bVar13;
  undefined4 *puVar14;
  double dVar15;
  float local_20;
  float local_c;
  float local_8;
  float local_4;
  
  pfVar10 = param_1;
  fVar4 = SQRT(param_2[2] * param_2[2] + param_2[1] * param_2[1] + *param_2 * *param_2);
  if (fVar4 <= _DAT_006f3fe8) {
    local_20 = 1.0;
  }
  else {
    local_20 = _DAT_006e97d8 / fVar4;
  }
  iVar11 = FUN_006c5018();
  param_1 = (float *)(2 - iVar11);
  iVar11 = FUN_00562f70(param_3);
  if ((*(int *)(iVar11 + 0x596) != 0) && (0 < (int)param_1)) {
    fVar5 = param_5 + _DAT_006ef640;
    bVar13 = (byte)param_3 & 0x7f;
    param_5 = param_5 + _DAT_006e9824;
    do {
      iVar9 = DAT_00d7cb20;
      if (DAT_00d7cb20 < 0x20) {
        (&DAT_00d7cae0)[DAT_00d7cb20] = 1;
        (&DAT_00d7cb00)[iVar9] = 1;
        iVar12 = DAT_00d7cb20;
        do {
          DAT_00d7cb20 = iVar12 + 1;
          if (0x1f < DAT_00d7cb20) break;
          pcVar2 = &DAT_00d7cae1 + iVar12;
          iVar12 = DAT_00d7cb20;
        } while (*pcVar2 != '\0');
        if (iVar9 < 0) goto LAB_005863fa;
        if ((iVar9 < 0x20) && ((&DAT_00d7cae0)[iVar9] != '\0')) {
          (&DAT_00d7cb00)[iVar9] = 1;
          puVar14 = (undefined4 *)(&DAT_00d7b7a0 + iVar9 * 0x9a);
          *(int *)(&DAT_00d7b832 + iVar9 * 0x9a) = iVar9;
        }
        else {
          puVar14 = (undefined4 *)0x0;
          iRam00000092 = iVar9;
        }
      }
      else {
LAB_005863fa:
        puVar14 = (undefined4 *)FUN_005861e0();
      }
      *puVar14 = 1;
      *(int *)((int)puVar14 + 0x96) = DAT_00d7cb28;
      DAT_00d7cb28 = DAT_00d7cb28 + 1;
      uVar3 = *(ushort *)(puVar14 + 0x24);
      *(ushort *)(puVar14 + 0x24) = uVar3 & 0xff80 | (ushort)bVar13;
      *(ushort *)(puVar14 + 0x24) =
           (*(byte *)(iVar11 + 0x58e) & 7) << 0xb ^ (uVar3 & 0xc780 | (ushort)bVar13);
      DAT_00d7cb30 = DAT_00d7cb30 + 1;
      if (0xf < DAT_00d7cb30) {
        DAT_00d7cb30 = 0;
      }
      pfVar1 = (float *)(puVar14 + 1);
      *(ushort *)(puVar14 + 0x24) =
           ((ushort)(DAT_00d7cb30 << 7) ^ *(ushort *)(puVar14 + 0x24)) & 0x780 ^
           *(ushort *)(puVar14 + 0x24);
      *pfVar1 = *pfVar10;
      puVar14[2] = pfVar10[1];
      puVar14[3] = pfVar10[2];
      dVar15 = rndUniform(0);
      *pfVar1 = (_DAT_006ea44c - (float)dVar15) + *pfVar1;
      dVar15 = rndUniform(0);
      puVar14[2] = (_DAT_006ea44c - (float)dVar15) + (float)puVar14[2];
      dVar15 = rndUniform(0);
      puVar14[3] = (_DAT_006ea44c - (float)dVar15) + (float)puVar14[3];
      FUN_005f58d0(puVar14 + 0xd,pfVar1);
      if ((float)puVar14[3] < (float)puVar14[0x19] !=
          (NAN((float)puVar14[3]) || NAN((float)puVar14[0x19]))) {
        puVar14[3] = puVar14[0x19];
      }
      local_c = *param_2;
      local_8 = param_2[1];
      local_4 = param_2[2];
      fVar6 = _DAT_006e97d8 - local_c * local_20;
      fVar7 = _DAT_006e97d8 - local_8 * local_20;
      fVar8 = _DAT_006e97d8 - local_4 * local_20;
      dVar15 = rndUniform(0);
      local_c = ((float)dVar15 - _DAT_006ea44c) * fVar5 * fVar6 * fVar4 + local_c;
      dVar15 = rndUniform(0);
      local_8 = ((float)dVar15 - _DAT_006ea44c) * fVar5 * fVar7 * fVar4 + local_8;
      dVar15 = rndUniform(0);
      local_4 = ((float)dVar15 - _DAT_006ea44c) * fVar5 * fVar8 * fVar4 + local_4;
      FUN_005f6a70(&local_c);
      dVar15 = rndUniform(0);
      fVar6 = (float)dVar15 * fVar4 * _DAT_006ed6c8;
      puVar14[4] = local_c * fVar6;
      puVar14[5] = local_8 * fVar6;
      puVar14[6] = fVar6 * local_4;
      if ((float)puVar14[6] < _DAT_006ea454 != (NAN((float)puVar14[6]) || NAN(_DAT_006ea454))) {
        puVar14[6] = -(float)puVar14[6];
      }
      dVar15 = rndUniform(0);
      puVar14[7] = (float)dVar15 * _DAT_006ee334;
      dVar15 = rndUniform(0);
      puVar14[8] = (float)dVar15 * _DAT_006ee334;
      dVar15 = rndUniform(0);
      puVar14[9] = (float)dVar15 * _DAT_006ee334;
      dVar15 = rndUniform(0);
      puVar14[10] = (float)dVar15 * param_5 * _DAT_006ed67c;
      dVar15 = rndUniform(0);
      puVar14[0xb] = (float)dVar15 * param_5 * _DAT_006ea514;
      dVar15 = rndUniform(0);
      puVar14[0x23] = 0;
      puVar14[0xc] = (float)dVar15 * param_5 * _DAT_006ed67c;
      if (_DAT_006ea454 < param_4) {
        FUN_005859a0(puVar14,DAT_00c074c4 * param_4);
      }
      param_1 = (float *)((int)param_1 + -1);
    } while (param_1 != (float *)0x0);
  }
  return 1;
}

