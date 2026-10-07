/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004d8e50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004d8e50(int param_1_00,int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int *piVar4;
  int *piVar5;
  float fVar6;
  char cVar7;
  undefined4 uVar8;
  undefined4 uStack_5c;
  int iStack_50;
  int iStack_4c;
  int iStack_48;
  int iStack_44;
  undefined1 local_40 [64];
  
  if (((*(char *)(param_1_00 + 4) == '\0') || (param_1 == 0)) ||
     (iVar1 = *(int *)(param_1 + 0x30), iVar1 < 0)) {
    if (*(int **)(param_1_00 + 5) == (int *)0x0) {
      return;
    }
    (**(code **)(**(int **)(param_1_00 + 5) + 0x4c))();
    return;
  }
  if (*(int **)(param_1_00 + 5) != (int *)0x0) {
    (**(code **)(**(int **)(param_1_00 + 5) + 0x50))();
  }
  if (*(int **)(param_1_00 + 0x29) != (int *)0x0) {
    (**(code **)(**(int **)(param_1_00 + 0x29) + 0x50))();
  }
  iVar2 = *(int *)(param_1_00 + 0x2d);
  if ((iVar2 != 0) && (iVar3 = *(int *)(param_1 + 0x4c), iVar3 != *(int *)(param_1_00 + 0x31))) {
    *(int *)(param_1_00 + 0x31) = iVar3;
    switch(iVar3) {
    case 0:
      uVar8 = 0x3aa7;
      break;
    case 1:
      uVar8 = 0x3aa6;
      break;
    case 2:
      uVar8 = 0x3aa8;
      break;
    case 3:
      uVar8 = 0x3aa9;
      break;
    case 4:
      uVar8 = 0x3aaa;
      break;
    case 5:
      uVar8 = 0x3aab;
      break;
    case 6:
      uVar8 = 0x3aac;
      break;
    case 7:
      uVar8 = 0x3aad;
      break;
    default:
      if ((int *)**(int **)(iVar2 + 0x1ae) != (int *)0x0) {
        (**(code **)(*(int *)**(int **)(iVar2 + 0x1ae) + 0x68))(&DAT_008b99d8);
      }
      goto LAB_004d8f13;
    }
    if ((int *)**(int **)(iVar2 + 0x1ae) != (int *)0x0) {
      (**(code **)(*(int *)**(int **)(iVar2 + 0x1ae) + 0x70))(uVar8);
    }
  }
LAB_004d8f13:
  if (*(int **)(param_1_00 + 0x21) != (int *)0x0) {
    (**(code **)(**(int **)(param_1_00 + 0x21) + 0x50))();
  }
  iVar2 = *(int *)(param_1_00 + 0x25);
  if (iVar2 != 0) {
    FUN_00435150(local_40,0x20,(double)*(float *)(param_1 + 0x38),0,1,0);
    piVar4 = (int *)**(int **)(iVar2 + 0x1ae);
    if (piVar4 != (int *)0x0) {
      (**(code **)(*piVar4 + 0x68))(local_40);
    }
  }
  cVar7 = FUN_0055ab10(iVar1);
  piVar4 = *(int **)(param_1_00 + 9);
  if (cVar7 == '\0') {
    if (piVar4 != (int *)0x0) {
      (**(code **)(*piVar4 + 0x4c))();
    }
    if (*(int **)(param_1_00 + 0x15) != (int *)0x0) {
      (**(code **)(**(int **)(param_1_00 + 0x15) + 0x4c))();
      return;
    }
  }
  else {
    if (piVar4 != (int *)0x0) {
      (**(code **)(*piVar4 + 0x50))();
    }
    piVar4 = *(int **)(param_1_00 + 0xd);
    if ((piVar4 != (int *)0x0) && (piVar5 = *(int **)(param_1_00 + 0x11), piVar5 != (int *)0x0)) {
      (**(code **)(*piVar4 + 0x50))();
      (**(code **)(*piVar5 + 0x50))();
      fVar6 = *(float *)(param_1 + 0x50);
      uStack_5c = 0xff00ff00;
      if ((fVar6 < _DAT_006ea454) || ((fVar6 <= _DAT_006e97d8 && (fVar6 < _DAT_006ea67c)))) {
        uStack_5c = 0xff000000;
      }
      iStack_44 = 0;
      iStack_48 = 0;
      iStack_50 = 0;
      iStack_4c = 0;
      (**(code **)(*piVar5 + 100))(&iStack_50);
      if (*(int **)((int)piVar4 + 0x12) != (int *)0x0) {
        iVar1 = **(int **)((int)piVar4 + 0x12);
        uVar8 = FUN_006c5018((iStack_44 - iStack_4c) + 1);
        (**(code **)(iVar1 + 0x24))(uVar8);
      }
      FUN_004d9240(uStack_5c);
    }
    if (*(int **)(param_1_00 + 0x15) != (int *)0x0) {
      (**(code **)(**(int **)(param_1_00 + 0x15) + 0x50))();
    }
    piVar4 = *(int **)(param_1_00 + 0x19);
    if ((piVar4 != (int *)0x0) && (piVar5 = *(int **)(param_1_00 + 0x1d), piVar5 != (int *)0x0)) {
      (**(code **)(*piVar4 + 0x50))();
      (**(code **)(*piVar5 + 0x50))();
      iStack_48 = 0;
      iStack_50 = 0;
      iStack_44 = 0;
      iStack_4c = 0;
      (**(code **)(*piVar5 + 100))(&iStack_50);
      piVar4 = *(int **)((int)piVar4 + 0x12);
      if (piVar4 != (int *)0x0) {
        iVar1 = *piVar4;
        uVar8 = FUN_006c5018((iStack_48 - iStack_50) + 1);
        (**(code **)(iVar1 + 0x24))(uVar8);
        if (piVar4 != (int *)0x0) {
          (**(code **)(*piVar4 + 0x68))();
          return;
        }
      }
    }
  }
  return;
}


