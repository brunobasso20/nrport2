/* NR2003.exe @ 005a02b0 FUN_005a02b0 */

void __thiscall

FUN_005a02b0(int *param_1_00,undefined4 param_1,int *param_2,int param_3,int param_4)


{

  int iVar1;

  int *piVar2;



  if (param_1_00[0xca] != param_4) {

    (**(code **)(*param_1_00 + 4))(param_1);

  }

  param_1_00[0x31] = 0;

  param_1_00[0x32] = 0;

  param_1_00[0x2d] = 0;

  param_1_00[0x2e] = 0;

  param_1_00[0x2f] = 0;

  param_1_00[0x27] = param_2[3];

  param_1_00[0x28] = param_2[4];

  param_1_00[0x29] = param_2[5];

  param_1_00[0x2a] = param_2[0x23];

  param_1_00[0x2b] = param_2[0x24];

  param_1_00[0x2c] = param_2[0x25];

  piVar2 = param_1_00 + 1;

  for (iVar1 = 0x26; iVar1 != 0; iVar1 = iVar1 + -1) {

    *piVar2 = *param_2;

    param_2 = param_2 + 1;

    piVar2 = piVar2 + 1;

  }

  param_1_00[0xc5] = param_3;

  param_1_00[0x30] = (int)(((float)param_1_00[3] - (float)param_1_00[9]) * (float)param_1_00[0xc]);

  iVar1 = FUN_005cebb0(param_3 + -0x24);

  param_1_00[0xc6] = iVar1;

  param_1_00[0xca] = param_4;

  param_1_00[0xc9] = param_1_00[0xc9] | 0x27;

  return;

}
