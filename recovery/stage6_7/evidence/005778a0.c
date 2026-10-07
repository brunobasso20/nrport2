/* NR2003.exe @ 005778a0 FUN_005778a0 */

void __fastcall FUN_005778a0(int **param_1)

{
  int **ppiVar1;
  int **ppiVar2;
  float fVar3;
  float fVar4;
  int *piVar5;
  char cVar6;
  int *piVar7;
  int iVar8;
  int **local_1c [4];
  undefined local_c [12];
  
  ppiVar1 = param_1 + 10;
  local_1c[0] = ppiVar1;
  cVar6 = (**(code **)(**param_1 + 8))(param_1[1],param_1 + 4,local_c);
  if (cVar6 == '\0') {
    piVar7 = param_1[2];
    while (piVar7 != (int *)0x0) {
      piVar5 = (int *)piVar7[3];
      FUN_00577860();
      FUN_00577ad0(piVar7);
      piVar7 = piVar5;
    }
    param_1[2] = (int *)0x0;
    *ppiVar1 = (int *)0x0;
    return;
  }
  if (param_1[2] == (int *)0x0) {
    iVar8 = param_1[1][3];
    if (iVar8 == 0) {
      for (iVar8 = (*param_1)[3]; iVar8 != 0; iVar8 = *(int *)(iVar8 + 8)) {
        piVar7 = (int *)FUN_00577a80(iVar8,param_1[1]);
        if (piVar7 != (int *)0x0) {
          piVar7[3] = (int)param_1[2];
          param_1[2] = piVar7;
        }
      }
    }
    else {
      do {
        piVar7 = (int *)FUN_00577a80(*param_1,iVar8);
        if (piVar7 != (int *)0x0) {
          piVar7[3] = (int)param_1[2];
          param_1[2] = piVar7;
        }
        iVar8 = *(int *)(iVar8 + 8);
      } while (iVar8 != 0);
    }
  }
  piVar7 = param_1[2];
  if (piVar7 != (int *)0x0) {
    do {
      FUN_005778a0();
      piVar7 = (int *)piVar7[3];
    } while (piVar7 != (int *)0x0);
    return;
  }
  if (param_1[0xb] == (int *)0x0) {
    ppiVar2 = param_1 + 5;
    FUN_005f6d20(ppiVar2,DAT_00d358f4,local_1c);
    fVar3 = *(float *)(DAT_00d358f4 + 0x28);
    fVar4 = *(float *)(DAT_00d358f4 + 0x2c);
    *ppiVar2 = (int *)(*(float *)(DAT_00d358f4 + 0x24) + (float)*ppiVar2);
    param_1[6] = (int *)(fVar3 + (float)param_1[6]);
    param_1[7] = (int *)(fVar4 + (float)param_1[7]);
    param_1[8] = (int *)0x0;
    param_1[9] = (int *)0x0;
    param_1[0xb] = (int *)0x1;
  }
  (**(code **)(**param_1 + 0x14))(param_1[1],param_1[4],local_1c,*ppiVar1,param_1 + 5);
  return;
}

