/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005a0760 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_005a0760(int *param_1_00,undefined4 param_1,undefined4 param_2,undefined4 param_3,
            undefined4 param_4,int param_5,undefined4 param_7,int param_8)

{
  float10 fVar1;
  float fVar2;
  bool bVar3;
  int iVar4;
  int *piVar5;
  int *piVar6;
  float10 fVar7;
  float local_c4;
  undefined4 local_c0;
  undefined4 local_bc;
  undefined4 local_b8;
  undefined4 local_b4;
  float local_b0;
  float local_ac;
  float local_a8;
  float local_a4;
  float local_a0;
  int local_98 [9];
  undefined1 local_74 [48];
  undefined4 local_44;
  
  FUN_005a2c80(&local_b4,&local_b8,&local_c4,param_2,param_3,param_4);
  bVar3 = inBackground();
  if (bVar3) {
    iVar4 = FUN_00562f70();
  }
  else {
    iVar4 = FUN_004f5970(param_1);
  }
  if (*(int *)(iVar4 + 0x5ae) == 0) {
    local_44 = 0;
    fVar2 = _DAT_006e97d8;
  }
  else {
    local_44 = *(undefined4 *)(*(int *)(iVar4 + 0x5ae) + 0x54);
    fVar2 = *(float *)(*(int *)(iVar4 + 0x5ae) + 0x2c);
  }
  FUN_005f5a40(local_98,local_b4,local_b8,_DAT_006f6ea8 / fVar2);
  local_b0 = local_c4;
  fVar1 = (float10)fcos((float10)local_c4);
  fVar7 = (float10)fsin((float10)local_c4);
  local_ac = (float)fVar1;
  local_a8 = (float)fVar7;
  local_a4 = local_ac;
  local_a0 = local_a8;
  FUN_005f5d60(&local_c4,&local_c0,&local_bc,&local_a4,local_74);
  FUN_005f5a90(local_98,local_c4,local_c0,local_bc);
  if (param_1_00[0xca] != param_8) {
    (**(code **)(*param_1_00 + 4))(param_1);
    FUN_0059fa90();
  }
  if ((*(byte *)(param_1_00 + 0xc9) & 1) != 0) {
    iVar4 = FUN_005ceb90(param_5,param_1_00[0xc5]);
    param_1_00[200] = iVar4;
    if ((iVar4 < 1) || (0x24 < iVar4)) {
      if (iVar4 < -0x24) {
        FUN_0059fa90();
      }
      else if (iVar4 < 1) {
        return;
      }
    }
    else {
      FUN_0059fad0(iVar4,local_98,param_7,0);
    }
  }
  piVar5 = local_98;
  piVar6 = param_1_00;
  for (iVar4 = 0x26; piVar6 = piVar6 + 1, iVar4 != 0; iVar4 = iVar4 + -1) {
    *piVar6 = *piVar5;
    piVar5 = piVar5 + 1;
  }
  param_1_00[0xc5] = param_5;
  param_1_00[0x30] = (int)(((float)param_1_00[3] - (float)param_1_00[9]) * (float)param_1_00[0xc]);
  if (((*(byte *)(param_1_00 + 0xc9) & 0x10) == 0) ||
     (iVar4 = FUN_005ceb90(param_5,param_1_00[0xc6]), 0x24 < iVar4)) {
    iVar4 = FUN_005cebb0(param_1_00[0xc5] + -0x24);
    param_1_00[0xc6] = iVar4;
  }
  param_1_00[0xca] = param_8;
  param_1_00[0xc9] = param_1_00[0xc9] | 1;
  return;
}


