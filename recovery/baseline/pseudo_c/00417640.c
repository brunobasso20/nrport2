/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00417640 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00417640(float param_1_00,int param_1)

{
  float fVar1;
  char cVar2;
  int iVar3;
  int iVar4;
  int *piVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  int unaff_EBX;
  int unaff_EBP;
  
  FUN_004f5970(param_1);
  taskGetRate();
  iVar3 = FUN_00413e20();
  if ((param_1 < 0) || (0x2f < param_1)) {
    iVar3 = -1;
  }
  else {
    iVar3 = *(int *)(iVar3 + param_1 * 0xd + 0x18c);
  }
  iVar4 = FUN_00413e20();
  if ((param_1 < 0) || (0x2f < param_1)) {
    iVar4 = -1;
  }
  else {
    iVar4 = *(int *)(iVar4 + param_1 * 0xd + 0x188);
  }
  piVar5 = (int *)FUN_00413e20();
  iVar6 = (**(code **)(*piVar5 + 0x1c))(iVar3,iVar4);
  iVar7 = FUN_00413e20();
  if ((iVar4 < 0) || (*(int *)(iVar7 + 0x3f4) <= iVar4)) {
    iVar7 = -1;
  }
  else {
    iVar7 = *(int *)(iVar7 + 0xc + (iVar4 + iVar3 * 2) * 4);
  }
  iVar8 = FUN_00413e20();
  if (iVar4 < *(int *)(iVar8 + 0x3f4)) {
    iVar9 = 0x2f;
    piVar5 = (int *)(iVar8 + 0x17c + iVar4 * 4);
    do {
      if (*piVar5 != -1) break;
      iVar9 = iVar9 + -1;
      piVar5 = piVar5 + -2;
    } while (-1 < iVar9);
    iVar9 = iVar9 + 1;
  }
  else {
    iVar9 = -1;
  }
  if (iVar3 == iVar9) {
    *(undefined1 *)(param_1 + 0x4061 + unaff_EBP) = 0;
  }
  if (((iVar3 == 0) || (iVar6 == -1)) || (iVar6 == *(int *)(DAT_00760b38 + 0x5b2))) {
    cVar2 = FUN_004172e0(param_1);
    if ((cVar2 != '\0') &&
       (param_1_00 * (float)_DAT_006ecfe8 < *(float *)(*(int *)(unaff_EBX + 0x5ae) + 0x44))) {
      piVar5 = (int *)FUN_00413e20();
      cVar2 = (**(code **)(*piVar5 + 0x40))(unaff_EBX,DAT_00760b38,0);
      if (cVar2 == '\0') {
        *(undefined1 *)(param_1 + 0x4061 + unaff_EBP) = 0;
      }
    }
  }
  else {
    cVar2 = FUN_00416850();
    if ((cVar2 != '\0') && (iVar7 != -1)) {
      cVar2 = FUN_004172e0(param_1);
      if (cVar2 != '\0') {
        iVar3 = *(int *)(unaff_EBX + 0x5ae);
        if (iVar3 != 0) {
          iVar4 = FUN_004f5970(iVar6);
          if (iVar4 != 0) {
            iVar4 = FUN_004f5970(iVar6);
            if (*(int *)(iVar4 + 0x5ae) != 0) {
              fVar1 = *(float *)(iVar3 + 0x44);
              iVar3 = FUN_004f5970(iVar6);
              if (*(float *)(*(int *)(iVar3 + 0x5ae) + 0x44) * (float)_DAT_006ecfe8 < fVar1) {
                iVar3 = FUN_004f5970(iVar7);
                if (iVar3 != 0) {
                  iVar3 = FUN_004f5970(iVar7);
                  if (*(int *)(iVar3 + 0x5ae) != 0) {
                    piVar5 = (int *)FUN_00413e20();
                    iVar3 = *piVar5;
                    iVar4 = FUN_004f5970(iVar7,0);
                    cVar2 = (**(code **)(iVar3 + 0x40))(unaff_EBX);
                    if (cVar2 != '\0') {
                      piVar5 = (int *)FUN_00413e20();
                      cVar2 = (**(code **)(*piVar5 + 0x40))(unaff_EBX,DAT_00760b38,0);
                      if (cVar2 == '\0') {
                        *(undefined1 *)(param_1 + 0x4061 + iVar4) = 0;
                        return;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return;
}


