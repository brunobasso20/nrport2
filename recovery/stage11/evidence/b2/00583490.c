/* NR2003.exe @ 00583490 FUN_00583490 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00583490(undefined4 *param_1)

{
  uint uVar1;
  int iVar2;
  double dVar3;
  undefined4 *local_10;
  float local_c;
  float local_8;
  
  if ((DAT_00750130 & 8) == 0) {
    return 1;
  }
  dVar3 = rndUniform(0);
  if (dVar3 < _DAT_006ea668 != (NAN(dVar3) || NAN(_DAT_006ea668))) {
    return 1;
  }
  dVar3 = rndUniform(0);
  local_c = ((float)dVar3 - (float)_DAT_006ea668) * _DAT_006ea508;
  dVar3 = rndUniform(0);
  local_8 = ((float)dVar3 - (float)_DAT_006ea668) * _DAT_006ea508;
  uVar1 = rndInt(0);
  iVar2 = FUN_00582320(&local_10,1);
  if (iVar2 != 0) {
    local_10[0xb] = *param_1;
    local_10[0xc] = param_1[1];
    local_10[0xd] = param_1[2];
    local_10[0x11] = local_c;
    local_10[0x12] = local_8;
    local_10[0x13] = 0;
    local_10[10] = 8;
    local_10[6] = uVar1 >> 0x1e;
    dVar3 = rndUniform(0);
    local_10[5] = (float)dVar3 * _DAT_006ea494 + _DAT_006ea44c;
    local_10[7] = 0;
    *local_10 = 0x447a0000;
    return 1;
  }
  return 0;
}

