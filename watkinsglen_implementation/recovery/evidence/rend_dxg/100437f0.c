/* rend_dxg.dll @ 100437f0 FUN_100437f0 */

undefined4 * __thiscall
FUN_100437f0(undefined4 *param_1_00,undefined4 param_1,undefined4 param_2,undefined4 param_3,
            undefined4 param_4,undefined4 param_5,undefined4 param_6,int *param_7,undefined4 param_8
            ,undefined4 param_9,undefined4 param_10,undefined4 param_11,int param_12,int param_13,
            undefined4 param_14,undefined4 param_15,undefined4 param_16,undefined4 param_17,
            undefined4 param_18)

{
  int iVar1;
  bool bVar2;

  FUN_10041640(param_1,param_2,param_3,param_4,param_5,param_6,param_8,param_9,param_10,param_11,
               param_14,param_15,param_16,param_17,0,param_18);
  *param_1_00 = &PTR_LAB_1009a9dc;
  bVar2 = *param_7 == 2;
  *(bool *)(param_1_00 + 0x7a) = bVar2;
  if (bVar2) {
    iVar1 = param_7[0x12];
    param_1_00[0x78] = param_7[0x11];
    param_1_00[0x79] = iVar1;
  }
  else {
    iVar1 = param_7[0xf];
    param_1_00[0x77] = -(float)param_7[0xe];
    param_1_00[0x76] = iVar1;
  }
  if (param_12 == 0) {
    param_1_00[0x70] = 0xbf800000;
    param_1_00[0x71] = 0xbf800000;
  }
  else {
    if (param_12 == 1) {
      param_1_00[0x70] = 0;
      param_1_00[0x71] = 0;
      param_1_00[0x72] = 0x3f800000;
      *(undefined *)((int)param_1_00 + 0x1e9) = 0;
      goto LAB_100438ec;
    }
    if (param_12 != 2) {
      *(undefined *)((int)param_1_00 + 0x1e9) = 0;
      goto LAB_100438ec;
    }
    param_1_00[0x70] = 0x3f800000;
    param_1_00[0x71] = 0x3f800000;
  }
  param_1_00[0x72] = 0;
  *(bool *)((int)param_1_00 + 0x1e9) = bVar2;
LAB_100438ec:
  if (param_13 == 0) {
    param_1_00[0x73] = 0xbf800000;
    param_1_00[0x74] = 0xbf800000;
    *(bool *)((int)param_1_00 + 0x1ea) = bVar2;
    param_1_00[0x75] = 0;
    return param_1_00;
  }
  if (param_13 != 1) {
    if (param_13 != 2) {
      *(undefined *)((int)param_1_00 + 0x1ea) = 0;
      return param_1_00;
    }
    *(bool *)((int)param_1_00 + 0x1ea) = bVar2;
    param_1_00[0x73] = 0x3f800000;
    param_1_00[0x74] = 0x3f800000;
    param_1_00[0x75] = 0;
    return param_1_00;
  }
  param_1_00[0x73] = 0;
  param_1_00[0x74] = 0;
  param_1_00[0x75] = 0x3f800000;
  *(undefined *)((int)param_1_00 + 0x1ea) = 0;
  return param_1_00;
}
