/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00585e30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
FUN_00585e30(undefined4 *param_1,float *param_2,undefined4 param_3,ushort param_4,float param_5)

{
  char *pcVar1;
  float fVar2;
  ushort uVar3;
  ushort uVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  float *pfVar11;
  undefined4 *puVar12;
  double dVar13;
  float local_1c;
  float local_18;
  undefined4 local_14;
  undefined4 local_10;
  float local_c;
  float local_8;
  float local_4;
  
  fVar2 = SQRT(param_2[2] * param_2[2] + param_2[1] * param_2[1] + *param_2 * *param_2);
  if (fVar2 <= _DAT_006f3fe8) {
    local_1c = 1.0;
  }
  else {
    local_1c = _DAT_006e97d8 / fVar2;
  }
  iVar9 = FUN_00562f70(param_3);
  if (*(int *)(iVar9 + 0x596) == 0) {
    return 1;
  }
  FUN_005f74c0(&local_18,&local_14,&local_10,*(int *)(iVar9 + 0x5ae) + 0x58);
  iVar8 = DAT_00d7cb20;
  if (DAT_00d7cb20 < 0x20) {
    (&DAT_00d7cae0)[DAT_00d7cb20] = 1;
    (&DAT_00d7cb00)[iVar8] = 1;
    iVar10 = DAT_00d7cb20;
    do {
      DAT_00d7cb20 = iVar10 + 1;
      if (0x1f < DAT_00d7cb20) break;
      pcVar1 = &DAT_00d7cae1 + iVar10;
      iVar10 = DAT_00d7cb20;
    } while (*pcVar1 != '\0');
    if (-1 < iVar8) {
      if ((iVar8 < 0x20) && ((&DAT_00d7cae0)[iVar8] != '\0')) {
        (&DAT_00d7cb00)[iVar8] = 1;
        puVar12 = (undefined4 *)(&DAT_00d7b7a0 + iVar8 * 0x9a);
        *(int *)(&DAT_00d7b832 + iVar8 * 0x9a) = iVar8;
      }
      else {
        puVar12 = (undefined4 *)0x0;
        iRam00000092 = iVar8;
      }
      goto LAB_00585f40;
    }
  }
  puVar12 = (undefined4 *)FUN_005861e0();
LAB_00585f40:
  *puVar12 = 2;
  *(int *)((int)puVar12 + 0x96) = DAT_00d7cb28;
  DAT_00d7cb28 = DAT_00d7cb28 + 1;
  uVar3 = *(ushort *)(puVar12 + 0x24);
  uVar4 = (ushort)param_3 & 0x7f;
  *(ushort *)(puVar12 + 0x24) = uVar4 | uVar3 & 0xff80;
  *(ushort *)(puVar12 + 0x24) =
       (param_4 & 0xf) << 7 ^
       ((*(byte *)(iVar9 + 0x58e) & 7) << 0xb ^ (uVar4 | uVar3 & 0xc780)) & 0xf87f;
  puVar12[1] = *param_1;
  puVar12[2] = param_1[1];
  puVar12[3] = param_1[2];
  FUN_005f58d0(puVar12 + 0xd,puVar12 + 1);
  if ((float)puVar12[3] < (float)puVar12[0x19]) {
    puVar12[3] = puVar12[0x19];
  }
  local_c = *param_2;
  local_8 = param_2[1];
  local_4 = param_2[2];
  fVar5 = _DAT_006e97d8 - local_c * local_1c;
  fVar6 = _DAT_006e97d8 - local_8 * local_1c;
  fVar7 = _DAT_006e97d8 - local_4 * local_1c;
  dVar13 = rndUniform(0);
  local_c = ((float)dVar13 - _DAT_006ea44c) * fVar5 * fVar2 * _DAT_006f6868 + local_c;
  dVar13 = rndUniform(0);
  local_8 = ((float)dVar13 - _DAT_006ea44c) * fVar6 * fVar2 * _DAT_006f6868 + local_8;
  dVar13 = rndUniform(0);
  local_4 = ((float)dVar13 - _DAT_006ea44c) * fVar7 * fVar2 * _DAT_006f6868 + local_4;
  FUN_005f6a70(&local_c);
  dVar13 = rndUniform(0);
  fVar2 = (float)dVar13 * fVar2 * _DAT_006ed6c8;
  puVar12[4] = local_c * fVar2;
  puVar12[5] = local_8 * fVar2;
  puVar12[6] = fVar2 * local_4;
  if ((float)puVar12[6] < _DAT_006ea454) {
    puVar12[6] = -(float)puVar12[6];
  }
  pfVar11 = (float *)(puVar12 + 7);
  *pfVar11 = local_18;
  puVar12[8] = local_14;
  puVar12[9] = local_10;
  iVar9 = 3;
  do {
    fVar2 = *pfVar11;
    if (_DAT_006f5e58 < fVar2) {
      do {
        fVar2 = fVar2 - _DAT_006f5e58;
      } while (_DAT_006f5e58 < fVar2);
      *pfVar11 = fVar2;
    }
    fVar2 = *pfVar11;
    if (fVar2 < _DAT_006ea454) {
      do {
        fVar2 = fVar2 + _DAT_006f5e58;
      } while (fVar2 < _DAT_006ea454);
      *pfVar11 = fVar2;
    }
    pfVar11 = pfVar11 + 1;
    iVar9 = iVar9 + -1;
  } while (iVar9 != 0);
  dVar13 = rndUniform(0);
  puVar12[10] = (float)dVar13 * _DAT_006ee5e0;
  dVar13 = rndUniform(0);
  puVar12[0xb] = (float)dVar13 * _DAT_006f3e2c;
  dVar13 = rndUniform(0);
  fVar2 = (float)dVar13 * _DAT_006ee5e0;
  puVar12[0x23] = 0;
  puVar12[0xc] = fVar2;
  if (_DAT_006ea454 < param_5) {
    FUN_005859a0(puVar12,DAT_00c074c4 * param_5);
  }
  return 1;
}


