/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00583800 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00583800(undefined4 *param_1,undefined4 *param_2,undefined4 param_3,int param_4)

{
  int iVar1;
  float10 fVar2;
  double dVar3;
  undefined4 *local_4;
  
  iVar1 = FUN_00582320(&local_4,1);
  if (iVar1 != 0) {
    local_4[0xb] = *param_1;
    local_4[0xc] = param_1[1];
    local_4[0xd] = param_1[2];
    if (param_4 == 2) {
      local_4[8] = 0x3fc00000;
      local_4[9] = 0x40200000;
    }
    else if (param_4 == 0x10) {
      local_4[8] = 0x40200000;
      local_4[9] = 0x40400000;
      dVar3 = rndUniform(0);
      if (dVar3 < _DAT_006ef720) {
        param_4 = 1;
      }
    }
    else {
      local_4[8] = 0x40400000;
      local_4[9] = 0x40800000;
    }
    local_4[10] = param_4;
    local_4[0x11] = *param_2;
    local_4[0x12] = param_2[1];
    local_4[0x13] = param_2[2];
    local_4[2] = param_3;
    fVar2 = (float10)FUN_006c5c40();
    local_4[3] = (float)fVar2;
    dVar3 = rndUniform(0);
    local_4[5] = (float)dVar3 * _DAT_006ea470 + _DAT_006ea44c;
    fVar2 = (float10)FUN_006c5c40();
    local_4[4] = (float)(((float10)_DAT_006e97d8 - fVar2) * (float10)_DAT_006f3814);
    local_4[7] = 0;
    *local_4 = 0x447a0000;
    FUN_00583930(local_4);
    return 1;
  }
  return 0;
}


