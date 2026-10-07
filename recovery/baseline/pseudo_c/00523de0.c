/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00523de0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00523de0(uint *param_1,int param_2,uint *param_3,float param_4,float param_5,float param_6,
                 float param_7,float param_8,uint param_9,uint param_10)

{
  uint uVar1;
  float fVar2;
  uint uVar3;
  
  *param_1 = 0;
  if ((param_2 != 0) && (param_3 != (uint *)0x0)) {
    uVar1 = *(uint *)(param_2 + 8);
    uVar3 = 1 << ((byte)param_10 & 0x1f);
    *param_1 = 1;
    if ((uVar1 >> 0x14 & uVar3) != 0) {
      *param_1 = 3;
    }
    if ((*(uint *)(param_2 + 4) & 0x10000000) != 0) {
      *param_1 = *param_1 | 4;
    }
    param_1[1] = *param_3;
    param_1[2] = param_3[1];
    param_1[3] = param_3[2];
    param_1[4] = (uint)param_4;
    param_1[5] = param_3[9];
    param_1[6] = param_3[10];
    param_1[7] = param_3[0xb];
    param_1[8] = (uint)param_8;
    param_1[9] = param_9;
    uVar1 = *(uint *)(param_2 + 8);
    param_1[0xc] = param_10;
    param_1[0xb] = uVar1 & 0xff;
    param_1[10] = 0;
    if ((uVar3 & *(uint *)(param_2 + 0xc) & 0xfff) != 0) {
      param_1[10] = 1;
    }
    if ((*(uint *)(param_2 + 0xc) >> 0xc & uVar3 & 0xfff) != 0) {
      param_1[10] = param_1[10] | 2;
    }
    if (_DAT_006ea454 < param_8) {
      fVar2 = _DAT_006e97d8 - param_8;
      param_1[1] = (uint)(param_5 * param_8 + fVar2 * (float)param_1[1]);
      param_1[2] = (uint)(param_6 * param_8 + fVar2 * (float)param_1[2]);
      for (; param_7 < param_4 - _DAT_006f4a4c; param_7 = param_7 + _DAT_006ee484) {
      }
      for (; param_4 + _DAT_006f4a4c < param_7; param_7 = param_7 - _DAT_006ee484) {
      }
      param_1[4] = (uint)(param_7 * param_8 + fVar2 * param_4);
    }
  }
  return;
}


