/* NR2003.exe @ 0047f260 FUN_0047f260 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_0047f260(int param_1_00,int param_1,int param_2,int param_3,int param_4,int param_5,int param_6,
            int param_7)

{
  float fVar1;
  float fVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  undefined4 uVar6;
  int local_11c;
  undefined local_108 [64];
  undefined auStack_c8 [64];
  undefined auStack_88 [132];
  
  iVar4 = FUN_00432cf0(param_1_00 + 0x13d3);
  if (param_1 != 0) {
    cVar3 = FUN_005fbf80();
    if (cVar3 == '\x01') {
      iVar5 = FUN_00557ee0(0x3f);
      fVar1 = _DAT_006f07a8 * *(float *)(iVar4 + 0xc);
      fVar2 = _DAT_006ea44c * fVar1 - (float)iVar5;
      fVar1 = (fVar2 / fVar1) * _DAT_006ed00c;
      FUN_006c4f81(local_108,&DAT_00739878,(int)ROUND(fVar2 + _DAT_006ea4cc));
      FUN_006c4f81(auStack_c8,s__2_1f_0073987c,(double)ABS(fVar1));
      FUN_005f9900(&DAT_00f72794,0x291c,auStack_88,0x40,local_108,auStack_c8);
      if (**(int ***)(local_11c + 0x1ae) != (int *)0x0) {
        (**(code **)(***(int ***)(local_11c + 0x1ae) + 0x68))(auStack_88);
      }
    }
  }
  if (param_2 != 0) {
    cVar3 = FUN_005fbf80();
    if (cVar3 == '\x01') {
      iVar5 = FUN_00557ee0(0x3e);
      fVar1 = _DAT_006f07a8 * *(float *)(iVar4 + 0xc);
      fVar2 = _DAT_006ea44c * fVar1 + (float)iVar5;
      fVar1 = (fVar2 / fVar1) * _DAT_006ed00c;
      FUN_006c4f81(local_108,&DAT_00739884,(int)ROUND(fVar2 + _DAT_006ea4cc));
      FUN_006c4f81(auStack_c8,s__2_1f_00739888,(double)ABS(fVar1));
      FUN_005f9900(&DAT_00f72794,0x291c,auStack_88,0x40,local_108,auStack_c8);
      if (**(int ***)(local_11c + 0x1ae) != (int *)0x0) {
        (**(code **)(***(int ***)(local_11c + 0x1ae) + 0x68))(auStack_88);
      }
    }
  }
  if (param_3 != 0) {
    cVar3 = FUN_005fbf80();
    if (cVar3 == '\x01') {
      iVar4 = FUN_00557ee0(0x40);
      iVar5 = FUN_00432cf0(param_1_00 + 0x13d3);
      fVar1 = _DAT_006f07a8 * *(float *)(iVar5 + 0xc);
      fVar1 = (((float)iVar4 + fVar1) / (fVar1 + fVar1)) * _DAT_006ed00c;
      FUN_006c4f81(local_108,&DAT_00739890,iVar4);
      FUN_006c4f81(auStack_c8,s__2_1f_00739894,(double)ABS(fVar1));
      FUN_005f9900(&DAT_00f72794,0x291c,auStack_88,0x40,local_108,auStack_c8);
      if (**(int ***)(local_11c + 0x1ae) != (int *)0x0) {
        (**(code **)(***(int ***)(local_11c + 0x1ae) + 0x68))(auStack_88);
      }
    }
  }
  if (param_4 != 0) {
    cVar3 = FUN_005fbf80();
    if (cVar3 == '\x01') {
      uVar6 = 1;
      iVar4 = FUN_00557ee0();
      FUN_00435420(auStack_88,0x40,(double)iVar4,uVar6);
      if (**(int ***)(local_11c + 0x1ae) != (int *)0x0) {
        (**(code **)(***(int ***)(local_11c + 0x1ae) + 0x68))(auStack_88);
      }
    }
  }
  if (param_5 != 0) {
    cVar3 = FUN_005fbf80();
    if (cVar3 == '\x01') {
      uVar6 = 1;
      iVar4 = FUN_00557ee0();
      FUN_00435420(auStack_88,0x40,(double)iVar4,uVar6);
      if (**(int ***)(local_11c + 0x1ae) != (int *)0x0) {
        (**(code **)(***(int ***)(local_11c + 0x1ae) + 0x68))(auStack_88);
      }
    }
  }
  if (param_6 != 0) {
    cVar3 = FUN_005fbf80();
    if (cVar3 == '\x01') {
      uVar6 = 1;
      iVar4 = FUN_00557ee0();
      FUN_00435420(auStack_88,0x40,(double)iVar4,uVar6);
      if (**(int ***)(local_11c + 0x1ae) != (int *)0x0) {
        (**(code **)(***(int ***)(local_11c + 0x1ae) + 0x68))(auStack_88);
      }
    }
  }
  if (param_7 != 0) {
    cVar3 = FUN_005fbf80();
    if (cVar3 == '\x01') {
      uVar6 = 1;
      iVar4 = FUN_00557ee0();
      FUN_00435420(auStack_88,0x40,(double)iVar4,uVar6);
      if (**(int ***)(local_11c + 0x1ae) != (int *)0x0) {
        (**(code **)(***(int ***)(local_11c + 0x1ae) + 0x68))(auStack_88);
      }
    }
  }
  return;
}

