/* NR2003.exe @ 00510100 FUN_00510100 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00510100(int param_1,int param_2,undefined4 param_3,undefined4 param_4,int param_5)

{
  _DAT_00bad900 = *(float *)(param_2 + 0x10) * _DAT_006ea67c;
  _DAT_00bad904 = *(float *)(param_2 + 0x14) * _DAT_006ea67c;
  _DAT_00bad908 = *(float *)(param_2 + 0x18) * _DAT_006ea67c;
  _DAT_00bad90c = *(float *)(param_2 + 0x1c) * _DAT_006ea67c;
  _DAT_00ba71c4 = *(undefined4 *)(param_2 + 0x20);
  _DAT_00ba71c8 = *(undefined4 *)(param_2 + 0x24);
  _DAT_00ba71cc = *(undefined4 *)(param_2 + 0x28);
  _DAT_00ba71d0 = *(undefined4 *)(param_2 + 0x2c);
  _DAT_00ba72ec = 0;
  DAT_00bb3f5c = 0;
  FUN_005101c0(param_1,0,0,0,0,param_3,param_4);
  for (; DAT_00bb3f5c < param_5; DAT_00bb3f5c = DAT_00bb3f5c + 1) {
    *(undefined4 *)(param_1 + DAT_00bb3f5c * 8) = 0;
  }
  return;
}
