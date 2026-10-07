/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004606a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_004606a0(int *param_1)

{
  int iVar1;
  int *piVar2;
  bool bVar3;
  char cVar4;
  undefined4 uVar5;
  int *piVar6;
  float10 fVar7;
  float10 fVar8;
  int local_68;
  undefined1 auStack_50 [32];
  undefined1 local_30 [44];
  
  cVar4 = DAT_008b3088;
  if (*(char *)((int)param_1 + 0x327) == '\0') {
    if ((DAT_008b3088 != '\0') && ((char)param_1[0xca] == '\0')) {
      (**(code **)(*param_1 + 0x1c))();
      FUN_00462dd0();
    }
    *(char *)(param_1 + 0xca) = cVar4;
  }
  else if (*(char *)((int)param_1 + 0x329) == '\0') {
    FUN_00462dd0();
    cVar4 = DAT_008b3088;
    *(undefined1 *)((int)param_1 + 0x327) = 0;
    *(char *)(param_1 + 0xca) = cVar4;
  }
  else {
    *(undefined1 *)((int)param_1 + 0x329) = 0;
  }
  if (((DAT_008b30af == 7) || (DAT_008b30af == 4)) || (bVar3 = false, DAT_008b30af == 2)) {
    bVar3 = true;
  }
  piVar6 = (int *)((int)param_1 + 0x34a);
  local_68 = 0;
  do {
    if (piVar6[-8] != 0) {
      if (((local_68 == *(int *)((int)param_1 + 0x3ca)) && (bVar3)) && (DAT_008b33a6 == '\0')) {
        FUN_0060b360();
      }
      else {
        FUN_0060b400();
      }
    }
    iVar1 = *piVar6;
    if (iVar1 != 0) {
      FUN_006c5990(local_30,u___01f_00734b6c,(double)(float)(&DAT_008b3091)[local_68]);
      FUN_005f9730(0x4bd5,&DAT_008b4ef8,0x400);
      FUN_006c4f81(auStack_50,&DAT_00734b78,&DAT_008b4ef8,local_30);
      piVar2 = (int *)**(int **)(iVar1 + 0x1ae);
      if (piVar2 != (int *)0x0) {
        (**(code **)(*piVar2 + 0x6c))();
      }
      if (DAT_008b33a6 == '\0') {
        if (local_68 == *(int *)((int)param_1 + 0x3ca)) {
          FUN_00613d40();
        }
        else {
          FUN_00613d00();
        }
      }
      else {
        FUN_00613d80();
      }
    }
    iVar1 = piVar6[-4];
    if (iVar1 != 0) {
      fVar7 = (float10)FUN_00557e40();
      if (fVar7 == (float10)_DAT_006ea454) {
        piVar2 = (int *)**(undefined4 **)(iVar1 + 0x1ae);
      }
      else {
        fVar7 = (float10)FUN_00557e40();
        FUN_006c5990(local_30,u___01f_00734b80,(double)fVar7);
        FUN_005f9730(0x4bd6,&DAT_008b4ef8,0x400);
        FUN_006c4f81(auStack_50,&DAT_00734b8c,&DAT_008b4ef8,local_30);
        piVar2 = (int *)**(undefined4 **)(iVar1 + 0x1ae);
      }
      if (piVar2 != (int *)0x0) {
        (**(code **)(*piVar2 + 0x6c))();
      }
    }
    FUN_00460510();
    if (piVar6[4] != 0) {
      if ((*(char *)(local_68 + 0x3ce + (int)param_1) == '\0') || (!bVar3)) {
        FUN_0060b400();
      }
      else {
        FUN_0060b360();
      }
    }
    piVar2 = (int *)piVar6[8];
    if (piVar2 != (int *)0x0) {
      fVar7 = (float10)FUN_00557e40();
      if (*(int **)((int)piVar2 + 0x12) != (int *)0x0) {
        iVar1 = **(int **)((int)piVar2 + 0x12);
        uVar5 = FUN_006c5018();
        (**(code **)(iVar1 + 0x24))(uVar5);
      }
      fVar8 = (float10)FUN_00557e40();
      if (fVar8 == (float10)_DAT_006ea454) {
        (**(code **)(*piVar2 + 0x4c))();
        (**(code **)(*(int *)piVar6[0x1c] + 0x4c))();
      }
      else if ((float)fVar7 <= _DAT_006efe38) {
        (**(code **)(*piVar2 + 0x50))();
        (**(code **)(*(int *)piVar6[0x1c] + 0x4c))();
        piVar2 = *(int **)((int)piVar2 + 0x12);
        if ((float)fVar7 <= _DAT_006efe34) {
          if (piVar2 != (int *)0x0) {
            (**(code **)(*piVar2 + 0x68))();
          }
        }
        else if (piVar2 != (int *)0x0) {
          (**(code **)(*piVar2 + 0x68))();
        }
      }
      else {
        (**(code **)(*piVar2 + 0x4c))();
        (**(code **)(*(int *)piVar6[0x1c] + 0x50))();
      }
    }
    local_68 = local_68 + 1;
    piVar6 = piVar6 + 1;
  } while (local_68 < 4);
  return;
}


