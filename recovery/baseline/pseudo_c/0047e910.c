/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0047e910 */

void __thiscall
FUN_0047e910(int param_1_00,int param_1,int param_2,int param_3,int param_5,int param_6,int param_7,
            int param_8,int param_9,int param_10,int param_11,int param_12,int param_13,int param_14
            )

{
  char cVar1;
  int iVar2;
  int *piVar3;
  float10 fVar4;
  undefined4 uVar5;
  int *local_808;
  int *piStack_804;
  undefined1 local_800 [2048];
  
  if ((param_2 != 0) && (cVar1 = FUN_005fbf80(&local_808,param_2), cVar1 == '\x01')) {
    uVar5 = 1;
    fVar4 = (float10)FUN_00557e40(param_1);
    FUN_00435d70(local_800,0x400,(double)fVar4,uVar5);
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
  }
  if ((param_3 != 0) && (cVar1 = FUN_005fbf80(), cVar1 == '\x01')) {
    uVar5 = FUN_00557ee0(param_1 + 4);
    FUN_006c5990(local_800,&DAT_0073975c,uVar5);
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
    iVar2 = FUN_005582d0(param_1 + 4);
    if (iVar2 == 0) {
      (**(code **)(*local_808 + 0x48))();
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
    }
    else if (*(char *)(param_1_00 + 0x3245) == '\0') {
      (**(code **)(*local_808 + 0x44))();
    }
  }
  if ((param_5 != 0) && (cVar1 = FUN_005fbf80(), cVar1 == '\x01')) {
    FUN_00557ee0(param_1 + 8);
  }
  if ((param_6 != 0) && (cVar1 = FUN_005fbf80(), cVar1 == '\x01')) {
    uVar5 = FUN_00557ee0(param_1 + 0xc);
    FUN_006c5990(local_800,&DAT_007397c4,uVar5);
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
    iVar2 = FUN_005582d0(param_1 + 0xc);
    if (iVar2 == 0) {
      (**(code **)(*local_808 + 0x48))();
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
    }
    else if (*(char *)(param_1_00 + 0x3245) == '\0') {
      (**(code **)(*local_808 + 0x44))();
    }
  }
  if ((param_7 != 0) && (cVar1 = FUN_005fbf80(), cVar1 == '\x01')) {
    FUN_00557ee0(param_1 + 0x10);
  }
  if ((param_8 != 0) && (cVar1 = FUN_005fbf80(), cVar1 == '\x01')) {
    uVar5 = 2;
    piStack_804 = (int *)FUN_00557ee0();
    FUN_00435420(local_800,0x400,(double)(int)piStack_804,uVar5);
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
    iVar2 = FUN_005582d0(param_1 + 0x14);
    if (iVar2 == 0) {
      (**(code **)(*local_808 + 0x48))();
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
      cVar1 = FUN_005fbec0();
      if (cVar1 != '\0') {
        (**(code **)(*piStack_804 + 0x48))();
      }
    }
    else if (*(char *)(param_1_00 + 0x3245) == '\0') {
      (**(code **)(*local_808 + 0x44))();
    }
  }
  if ((param_9 != 0) && (cVar1 = FUN_005fbf80(&local_808,param_9), cVar1 == '\x01')) {
    FUN_00557e40(param_1 + 0x18);
    FUN_006c5990();
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
  }
  if ((param_10 != 0) && (cVar1 = FUN_005fbf80(&local_808,param_10), cVar1 == '\x01')) {
    uVar5 = 2;
    fVar4 = (float10)FUN_00557e40(param_1 + 0x1c);
    FUN_004352c0(local_800,0x400,(double)fVar4,uVar5);
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
  }
  if ((param_11 != 0) && (cVar1 = FUN_005fbf80(&local_808,param_11), cVar1 == '\x01')) {
    uVar5 = 2;
    fVar4 = (float10)FUN_00557e40(param_1 + 0x20);
    FUN_00435f20(local_800,0x400,(double)fVar4,uVar5);
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
  }
  if ((((param_12 != 0) && (-1 < param_1)) && (param_1 < 2)) &&
     (cVar1 = FUN_005fbf80(&local_808,param_12), cVar1 == '\x01')) {
    uVar5 = 2;
    fVar4 = (float10)FUN_00557e40(param_1 + 0x43);
    FUN_00435f20(local_800,0x400,(double)fVar4,uVar5);
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
  }
  if ((param_13 != 0) && (cVar1 = FUN_005fbf80(&local_808,param_13), cVar1 == '\x01')) {
    uVar5 = 2;
    fVar4 = (float10)FUN_00557e40(param_1 + 0x24);
    FUN_004352c0(local_800,0x400,(double)fVar4,uVar5);
    if ((int *)**(int **)((int)local_808 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)((int)local_808 + 0x1ae) + 0x68))(local_800);
    }
  }
  if (param_14 == 0) {
    return;
  }
  if (param_1 == 2) {
    cVar1 = FUN_005fbf80(&local_808,param_14);
    if (cVar1 != '\x01') {
      return;
    }
    uVar5 = 2;
    fVar4 = (float10)FUN_00557e40(0x2d);
    FUN_004352c0(local_800,0x400,(double)fVar4,uVar5);
    piVar3 = (int *)**(undefined4 **)((int)local_808 + 0x1ae);
  }
  else {
    if (param_1 != 3) {
      return;
    }
    cVar1 = FUN_005fbf80(&local_808,param_14);
    if (cVar1 != '\x01') {
      return;
    }
    uVar5 = 2;
    fVar4 = (float10)FUN_00557e40(0x2e);
    FUN_004352c0(local_800,0x400,(double)fVar4,uVar5);
    piVar3 = (int *)**(undefined4 **)((int)local_808 + 0x1ae);
  }
  if (piVar3 != (int *)0x0) {
    (**(code **)(*piVar3 + 0x68))(local_800);
  }
  return;
}


