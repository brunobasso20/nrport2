/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004173b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004173b0(int param_1_00,int param_1)

{
  float fVar1;
  char cVar2;
  int iVar3;
  int *piVar4;
  int iVar5;
  undefined4 uVar6;
  float unaff_EBP;
  undefined4 uVar7;
  float10 fVar8;
  
  FUN_004f5970(param_1);
  iVar3 = taskGetRate();
  fVar1 = (float)iVar3 * _DAT_0074b080 * _DAT_006e9810;
  iVar3 = FUN_00413e20();
  uVar6 = 0xffffffff;
  if (((param_1 == -1) || (iVar5 = param_1 * 0xd, *(int *)(iVar5 + 0x18c + iVar3) == -1)) ||
     (*(int *)(iVar5 + 0x188 + iVar3) == -1)) {
    *(undefined1 *)(param_1 + 0x4061 + param_1_00) = 1;
    return;
  }
  iVar3 = FUN_00413e20();
  if ((-1 < param_1) && (param_1 < 0x30)) {
    uVar6 = *(undefined4 *)(iVar5 + 0x18c + iVar3);
  }
  iVar3 = FUN_00413e20();
  if ((param_1 < 0) || (0x2f < param_1)) {
    uVar7 = 0xffffffff;
  }
  else {
    uVar7 = *(undefined4 *)(iVar5 + 0x188 + iVar3);
  }
  piVar4 = (int *)FUN_00413e20();
  iVar3 = (**(code **)(*piVar4 + 0x1c))(uVar6,uVar7);
  if (iVar3 == -1) {
    if ((*(char *)(param_1 + 0x4301 + param_1_00) != '\0') ||
       ((cVar2 = FUN_004172e0(param_1), cVar2 != '\0' &&
        (unaff_EBP * _DAT_006ea44c <= *(float *)(*(int *)((int)fVar1 + 0x5ae) + 0x44))))) {
      *(undefined4 *)(param_1_00 + 0x4095 + param_1 * 0xc) = 0;
      *(undefined4 *)(param_1_00 + 0x4099 + param_1 * 0xc) = 0xbff00000;
      return;
    }
    param_1_00 = param_1_00 + param_1 * 0xc;
    if (*(int *)(param_1_00 + 0x4095) != 0) {
      return;
    }
    if (*(int *)(param_1_00 + 0x4099) != -0x40100000) {
      return;
    }
    fVar8 = (float10)(*(code *)**(undefined4 **)(param_1_00 + 0x4091))();
    *(double *)(param_1_00 + 0x4095) = (double)(fVar8 + (float10)_DAT_006ecfe0);
    return;
  }
  iVar3 = FUN_004f5970(iVar3);
  if ((iVar3 != 0) && (*(int *)(iVar3 + 0x5ae) != 0)) {
    piVar4 = (int *)FUN_00413e20();
    cVar2 = (**(code **)(*piVar4 + 0x40))(iVar3,fVar1,0x41b40000);
    if ((cVar2 != '\0') &&
       ((unaff_EBP * _DAT_006ea44c < *(float *)(*(int *)(iVar3 + 0x5ae) + 0x44) &&
        (*(float *)(*(int *)((int)fVar1 + 0x5ae) + 0x44) < unaff_EBP * _DAT_006ea44c))))
    goto LAB_004174cb;
  }
  cVar2 = FUN_004172e0(param_1);
  if (cVar2 != '\0') {
    piVar4 = (int *)FUN_00413e20();
    cVar2 = (**(code **)(*piVar4 + 0x40))(fVar1,DAT_00760b38,0);
    if ((cVar2 == '\0') || (iVar3 = FUN_00417fc0(), iVar3 == 1)) {
      *(undefined4 *)(param_1_00 + 0x4095 + param_1 * 0xc) = 0;
      *(undefined4 *)(param_1_00 + 0x4099 + param_1 * 0xc) = 0xbff00000;
      return;
    }
  }
LAB_004174cb:
  iVar3 = param_1_00 + param_1 * 0xc;
  if ((*(int *)(param_1_00 + 0x4095 + param_1 * 0xc) == 0) &&
     (*(int *)(iVar3 + 0x4099) == -0x40100000)) {
    iVar5 = FUN_004f5970(param_1);
    cVar2 = FUN_00535510(*(undefined4 *)(iVar5 + 0x5ae));
    if (cVar2 != '\0') {
      fVar8 = (float10)(*(code *)**(undefined4 **)(iVar3 + 0x4091))();
      *(double *)(iVar3 + 0x4095) = (double)(fVar8 + (float10)_DAT_006ecfe0);
      return;
    }
    fVar8 = (float10)(*(code *)**(undefined4 **)(iVar3 + 0x4091))();
    *(double *)(iVar3 + 0x4095) = (double)(fVar8 + (float10)_DAT_006e9830);
    return;
  }
  return;
}


