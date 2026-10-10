/* NR2003.exe @ 005a0390 FUN_005a0390 */

void __thiscall FUN_005a0390(int *param_1_00,int param_1,float param_3)

{
  int iVar1;
  uint uVar2;
  int *piVar3;
  int *piVar4;
  int local_98 [3];
  float fStack_8c;
  float fStack_88;
  float fStack_84;
  int iStack_c;
  int iStack_8;
  int iStack_4;
  
  FUN_005a2d70(local_98,param_1);
  param_1_00[0x31] = 0;
  param_1_00[0x32] = 0;
  param_1_00[0x2d] = 0;
  param_1_00[0x2e] = 0;
  param_1_00[0x2f] = 0;
  if (param_1_00[0xca] != (int)*(uint *)(param_1 + 0x3c) >> 0x1f) {
    (**(code **)(*param_1_00 + 4))(*(uint *)(param_1 + 0x3c) & 0x7f);
    FUN_0059fa90();
  }
  if ((*(byte *)(param_1_00 + 0xc9) & 1) != 0) {
    iVar1 = FUN_005ceb90(*(ushort *)(param_1 + 2) & 0x3ff,param_1_00[0xc5]);
    param_1_00[200] = iVar1;
    if ((iVar1 < 1) || (0x24 < iVar1)) {
      if (iVar1 < -0x24) {
        FUN_0059fa90();
      }
      else if (iVar1 < 1) {
        return;
      }
    }
    else if ((*(byte *)(param_1_00 + 0xc9) & 2) != 0) {
      param_1_00[0x2d] = (int)(fStack_8c - (float)param_1_00[0x27]);
      param_1_00[0x2e] = (int)(fStack_88 - (float)param_1_00[0x28]);
      param_1_00[0x2f] = (int)(fStack_84 - (float)param_1_00[0x29]);
      param_3 = param_3 / (float)param_1_00[200];
      param_1_00[0x2d] = (int)(param_3 * (float)param_1_00[0x2d]);
      param_1_00[0x2e] = (int)(param_3 * (float)param_1_00[0x2e]);
      param_1_00[0x2f] = (int)(param_3 * (float)param_1_00[0x2f]);
    }
  }
  param_1_00[0x29] = (int)fStack_84;
  param_1_00[0x27] = (int)fStack_8c;
  param_1_00[0x28] = (int)fStack_88;
  param_1_00[0x2c] = iStack_4;
  param_1_00[0x2a] = iStack_c;
  param_1_00[0x2b] = iStack_8;
  piVar3 = local_98;
  piVar4 = param_1_00 + 1;
  for (iVar1 = 0x26; iVar1 != 0; iVar1 = iVar1 + -1) {
    *piVar4 = *piVar3;
    piVar3 = piVar3 + 1;
    piVar4 = piVar4 + 1;
  }
  param_1_00[0x30] = (int)(((float)param_1_00[3] - (float)param_1_00[9]) * (float)param_1_00[0xc]);
  uVar2 = *(ushort *)(param_1 + 2) & 0x3ff;
  param_1_00[0xc5] = uVar2;
  if (((*(byte *)(param_1_00 + 0xc9) & 0x10) == 0) ||
     (iVar1 = FUN_005ceb90(uVar2,param_1_00[0xc6]), 0x24 < iVar1)) {
    iVar1 = FUN_005cebb0(param_1_00[0xc5] + -0x24);
    param_1_00[0xc6] = iVar1;
  }
  param_1_00[0xc9] = param_1_00[0xc9] | 7;
  param_1_00[0xca] = *(int *)(param_1 + 0x3c) >> 0x1f;
  return;
}

