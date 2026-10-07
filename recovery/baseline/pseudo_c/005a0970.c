/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005a0970 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_005a0970(int *param_1_00,undefined4 param_1,undefined4 param_2,undefined4 param_3,int param_4,
            undefined4 param_6,int param_7)

{
  float fVar1;
  bool bVar2;
  int iVar3;
  int *piVar4;
  int *piVar5;
  undefined4 local_a0;
  undefined4 local_9c;
  int local_98 [21];
  undefined4 local_44;
  
  FUN_005a2c50(&local_a0,&local_9c,param_2,param_3);
  bVar2 = inBackground();
  if (bVar2) {
    iVar3 = FUN_00562f70();
  }
  else {
    iVar3 = FUN_004f5970(param_1);
  }
  if (*(int *)(iVar3 + 0x5ae) == 0) {
    local_44 = 0;
    fVar1 = _DAT_006e97d8;
  }
  else {
    local_44 = *(undefined4 *)(*(int *)(iVar3 + 0x5ae) + 0x54);
    fVar1 = *(float *)(*(int *)(iVar3 + 0x5ae) + 0x2c);
  }
  FUN_005f5a40(local_98,local_a0,local_9c,_DAT_006f6ea8 / fVar1);
  if (param_1_00[0xca] != param_7) {
    (**(code **)(*param_1_00 + 4))(param_1);
    FUN_0059fa90();
  }
  if ((*(byte *)(param_1_00 + 0xc9) & 1) != 0) {
    iVar3 = FUN_005ceb90(param_4,param_1_00[0xc5]);
    param_1_00[200] = iVar3;
    if ((iVar3 < 1) || (0x24 < iVar3)) {
      if (iVar3 < -0x24) {
        FUN_0059fa90();
      }
      else if (iVar3 < 1) {
        return;
      }
    }
    else {
      FUN_0059fad0(iVar3,local_98,param_6,1);
    }
  }
  piVar4 = local_98;
  piVar5 = param_1_00;
  for (iVar3 = 0x26; piVar5 = piVar5 + 1, iVar3 != 0; iVar3 = iVar3 + -1) {
    *piVar5 = *piVar4;
    piVar4 = piVar4 + 1;
  }
  param_1_00[0xc5] = param_4;
  param_1_00[0x30] = (int)(((float)param_1_00[3] - (float)param_1_00[9]) * (float)param_1_00[0xc]);
  if (((*(byte *)(param_1_00 + 0xc9) & 0x10) == 0) ||
     (iVar3 = FUN_005ceb90(param_4,param_1_00[0xc6]), 0x24 < iVar3)) {
    iVar3 = FUN_005cebb0(param_1_00[0xc5] + -0x24);
    param_1_00[0xc6] = iVar3;
  }
  param_1_00[0xca] = param_7;
  param_1_00[0xc9] = param_1_00[0xc9] | 1;
  return;
}


