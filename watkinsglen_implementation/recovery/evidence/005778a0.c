/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005778a0 */

void __fastcall FUN_005778a0(int *param_1)

{
  int *piVar1;
  float *pfVar2;
  float fVar3;
  float fVar4;
  char cVar5;
  int iVar6;
  int iVar7;
  int *local_1c [4];
  undefined1 local_c [12];

  piVar1 = param_1 + 10;
  local_1c[0] = piVar1;
  cVar5 = (**(code **)(*(int *)*param_1 + 8))(param_1[1],param_1 + 4,local_c);
  if (cVar5 == '\0') {
    iVar7 = param_1[2];
    while (iVar7 != 0) {
      iVar6 = *(int *)(iVar7 + 0xc);
      FUN_00577860();
      FUN_00577ad0(iVar7);
      iVar7 = iVar6;
    }
    param_1[2] = 0;
    *piVar1 = 0;
    return;
  }
  if (param_1[2] == 0) {
    iVar7 = *(int *)(param_1[1] + 0xc);
    if (iVar7 == 0) {
      for (iVar7 = *(int *)(*param_1 + 0xc); iVar7 != 0; iVar7 = *(int *)(iVar7 + 8)) {
        iVar6 = FUN_00577a80(iVar7,param_1[1]);
        if (iVar6 != 0) {
          *(int *)(iVar6 + 0xc) = param_1[2];
          param_1[2] = iVar6;
        }
      }
    }
    else {
      do {
        iVar6 = FUN_00577a80(*param_1,iVar7);
        if (iVar6 != 0) {
          *(int *)(iVar6 + 0xc) = param_1[2];
          param_1[2] = iVar6;
        }
        iVar7 = *(int *)(iVar7 + 8);
      } while (iVar7 != 0);
    }
  }
  iVar7 = param_1[2];
  if (iVar7 != 0) {
    do {
      FUN_005778a0();
      iVar7 = *(int *)(iVar7 + 0xc);
    } while (iVar7 != 0);
    return;
  }
  if (param_1[0xb] == 0) {
    pfVar2 = (float *)(param_1 + 5);
    FUN_005f6d20(pfVar2,DAT_00d358f4,local_1c);
    fVar3 = *(float *)(DAT_00d358f4 + 0x28);
    fVar4 = *(float *)(DAT_00d358f4 + 0x2c);
    *pfVar2 = *(float *)(DAT_00d358f4 + 0x24) + *pfVar2;
    param_1[6] = (int)(fVar3 + (float)param_1[6]);
    param_1[7] = (int)(fVar4 + (float)param_1[7]);
    param_1[8] = 0;
    param_1[9] = 0;
    param_1[0xb] = 1;
  }
  (**(code **)(*(int *)*param_1 + 0x14))(param_1[1],param_1[4],local_1c,*piVar1,param_1 + 5);
  return;
}
