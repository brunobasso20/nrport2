/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0047e2a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0047e2a0(int param_1)

{
  float fVar1;
  float10 fVar2;
  float fVar3;
  float fVar4;
  char cVar5;
  int iVar6;
  float10 fVar7;
  undefined4 uVar8;
  undefined8 uVar9;
  float local_314;
  int *local_310;
  int *local_30c;
  undefined1 local_300 [256];
  undefined1 local_200 [256];
  undefined1 local_100 [256];
  
  local_314 = *(float *)(param_1 + 0x3239) * _DAT_006ecfd8;
  if (local_314 < _DAT_006ea67c) {
    local_314 = 0.001;
  }
  fVar7 = (float10)FUN_00557e40(0x5b);
  fVar1 = (float)(((float10)_DAT_006e97d8 / (float10)local_314) * fVar7);
  if (*(short *)(param_1 + 0x4de) == 2) {
    iVar6 = FUN_00557ee0(0x31);
  }
  else {
    iVar6 = FUN_00557de0(0x31);
  }
  cVar5 = FUN_005fbf80();
  if (cVar5 == '\x01') {
    FUN_00435fb0(local_200,0x80,(double)iVar6,0);
    fVar3 = (float)iVar6 * fVar1;
    fVar4 = _DAT_006ea454;
    if ((_DAT_006ea454 <= fVar3) && (fVar4 = fVar3, _DAT_006efe54 < fVar3)) {
      fVar4 = _DAT_006efe54;
    }
    fVar4 = fVar4 + _DAT_006ea4cc;
    if ((int)ROUND(fVar4) == 1) {
      uVar8 = 0x4c80;
    }
    else {
      uVar8 = 0x4c7f;
    }
    FUN_005f9730(uVar8,CONCAT44(0x80,local_300));
    FUN_006c5990(local_100,u__s__ld__s_007396f0,local_200,(int)ROUND(fVar4),local_300);
    if ((int *)**(int **)((int)local_30c + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_30c + 0x1ae) + 0x68))(local_100);
    }
  }
  cVar5 = FUN_005fbf80();
  if (cVar5 == '\x01') {
    uVar8 = 0;
    fVar7 = (float10)FUN_00557e40();
    FUN_00435fb0(local_200,0x80,(double)fVar7,uVar8);
    fVar7 = (float10)FUN_00557e40(0x5c);
    fVar7 = fVar7 * (float10)fVar1;
    if ((float10)_DAT_006ea454 <= fVar7) {
      if ((float10)_DAT_006efe54 < fVar7) {
        fVar7 = (float10)_DAT_006efe54;
      }
    }
    else {
      fVar7 = (float10)_DAT_006ea454;
    }
    fVar2 = (float10)_DAT_006ea4cc;
    if ((int)ROUND((float)(fVar7 + fVar2)) == 1) {
      uVar9 = CONCAT44(local_300,0x4c80);
    }
    else {
      uVar9 = CONCAT44(local_300,0x4c7f);
    }
    FUN_005f9730(uVar9,0x80);
    FUN_006c5990(local_100,u__s__ld__s_00739704,local_200,(int)ROUND((float)(fVar7 + fVar2)),
                 local_300);
    if ((int *)**(int **)((int)local_310 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_310 + 0x1ae) + 0x68))(local_100);
    }
  }
  cVar5 = FUN_005fbf80();
  if (cVar5 == '\x01') {
    (**(code **)(*local_30c + 0x4c))();
  }
  cVar5 = FUN_005fbf80();
  if (cVar5 == '\x01') {
    (**(code **)(*local_310 + 0x4c))();
  }
  return;
}


