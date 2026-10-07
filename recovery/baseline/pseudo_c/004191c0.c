/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004191c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_004191c0(int param_1)

{
  float *pfVar1;
  char cVar2;
  int *piVar3;
  int iVar4;
  undefined4 uVar5;
  int iVar6;
  float10 fVar7;
  undefined8 uVar8;
  uint local_14;
  float fStack_10;
  
  local_14 = local_14 & 0xffffff00;
  piVar3 = (int *)FUN_00538ab0();
  (**(code **)(*piVar3 + 0x30))();
  iVar4 = FUN_005443e0();
  FUN_004188e0();
  FUN_00418b00();
  if (*(int *)(param_1 + 0x3f54) == 7) {
    cVar2 = FUN_00417f50();
    if (cVar2 == '\0') {
      uVar5 = 0xffffffff;
      *(undefined4 *)(param_1 + 0x43d3) = 0xffffffff;
      goto LAB_00419255;
    }
    FUN_00420330(*(undefined4 *)(param_1 + 0x43d3),*(undefined4 *)(param_1 + 0x43d7));
  }
  else {
    piVar3 = (int *)FUN_00413e20();
    uVar5 = (**(code **)(*piVar3 + 0x24))();
    *(undefined4 *)(param_1 + 0x43d3) = uVar5;
    piVar3 = (int *)FUN_00413e20();
    uVar5 = (**(code **)(*piVar3 + 0x24))(1);
LAB_00419255:
    *(undefined4 *)(param_1 + 0x43d7) = uVar5;
  }
  switch(*(undefined4 *)(param_1 + 0x3f54)) {
  case 2:
    if (*(int *)(DAT_00760b38 + 0x1a8a) <= *(int *)(param_1 + 0x3f60)) {
      return;
    }
    cVar2 = FUN_004185f0(&local_14,1);
    if (cVar2 != '\0') goto LAB_004193a8;
    uVar8 = 3;
    goto LAB_00419392;
  case 3:
    iVar6 = FUN_00509a00();
    if (iVar6 <= iVar4 + 2) {
      return;
    }
    if (*(int *)(DAT_00760b38 + 0x1a8a) <= *(int *)(param_1 + 0x3f60) + 1) {
      FUN_00538ab0();
      iVar4 = FUN_005398d0();
      if (iVar4 != 5) {
        return;
      }
      if (*(float *)(DAT_00760b38 + 0x186a) <= _DAT_00bde260) {
        return;
      }
      if (_DAT_00bde260 + _DAT_006ed00c <= *(float *)(DAT_00760b38 + 0x186a)) {
        return;
      }
LAB_00419337:
      cVar2 = FUN_004185f0(CONCAT44(1,&local_14));
      if (cVar2 != '\0') {
        return;
      }
      FUN_00417fd0(5,0);
      return;
    }
    goto LAB_00419383;
  case 4:
    iVar6 = FUN_00509a00();
    if (iVar6 <= iVar4 + 2) {
      return;
    }
    if (*(int *)(DAT_00760b38 + 0x1a8a) <= *(int *)(param_1 + 0x3f60) + 1) {
      FUN_00538ab0();
      iVar4 = FUN_005398d0();
      if (iVar4 != 5) {
        return;
      }
      if (*(float *)(DAT_00760b38 + 0x186a) <= _DAT_00bde260) {
        return;
      }
      if (_DAT_00bde260 + _DAT_006ed00c <= *(float *)(DAT_00760b38 + 0x186a)) {
        return;
      }
      goto LAB_00419337;
    }
LAB_00419383:
    cVar2 = FUN_004185f0(CONCAT44(1,&local_14));
    if (cVar2 != '\0') {
LAB_004193a8:
      *(int *)(param_1 + 0x3f60) = *(int *)(param_1 + 0x3f60) + 1;
      return;
    }
    uVar8 = 5;
LAB_00419392:
    FUN_00417fd0(uVar8);
    FUN_004184f0();
    return;
  case 5:
    fVar7 = (float10)FUN_00516e1a();
    fStack_10 = (float)(fVar7 * (float10)_DAT_006ea504);
    if ((float10)DAT_0074b068 < fVar7 * (float10)_DAT_006ea504) {
      fStack_10 = DAT_0074b068;
    }
    iVar6 = FUN_00509a00();
    if (iVar4 + 1 < iVar6) {
      cVar2 = FUN_004185f0(&local_14,1);
      if ((cVar2 != '\0') && ((DAT_00bebd84 & 0x100000) != 0)) {
        *(int *)(param_1 + 0x3f60) = *(int *)(DAT_00760b38 + 0x1a8a) + -1;
        FUN_00417fd0(4,0);
        return;
      }
      pfVar1 = (float *)(DAT_00760b38 + 0x186a);
      if ((fStack_10 < *(float *)(DAT_00760b38 + 0x186a)) &&
         (fVar7 = (float10)FUN_00516e1a(), (float10)*pfVar1 < fVar7 * (float10)_DAT_006ed020)) {
        FUN_00417fd0(6,0);
        return;
      }
    }
    break;
  case 6:
    iVar6 = FUN_00509a00();
    if (iVar4 + 1 < iVar6) {
      cVar2 = FUN_004190d0();
      if (((cVar2 != '\0') && (*(int *)(param_1 + 0x4d) == 0)) &&
         (*(int *)(param_1 + 0x51) == -0x40100000)) {
        fVar7 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x49))();
        *(double *)(param_1 + 0x4d) = (double)(fVar7 + (float10)_DAT_006e9830);
        return;
      }
      if ((DAT_00bebd84 & 0x100000) != 0) {
        if (*(int *)(param_1 + 0x4d) != 0) {
          return;
        }
        if ((*(int *)(param_1 + 0x51) == -0x40100000) &&
           (((cVar2 = FUN_004185f0(&local_14,1), cVar2 != '\0' ||
             (cVar2 = FUN_00419030(), cVar2 != '\0')) || (cVar2 = FUN_00419120(), cVar2 != '\0'))))
        {
          *(int *)(param_1 + 0x3f60) = *(int *)(DAT_00760b38 + 0x1a8a) + -1;
          FUN_00417fd0(4,0);
          return;
        }
      }
      if (((*(int *)(param_1 + 0x4d) == 0) && (*(int *)(param_1 + 0x51) == -0x40100000)) &&
         (cVar2 = FUN_00419140(), cVar2 != '\0')) {
        fVar7 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x49))();
        *(double *)(param_1 + 0x4d) = (double)(fVar7 + (float10)_DAT_006e9830);
        return;
      }
    }
    break;
  case 7:
    cVar2 = FUN_004185f0(&local_14,0);
    if (cVar2 != '\0') {
      FUN_00417fd0(0,local_14);
      return;
    }
    fVar7 = (float10)FUN_00509a20();
    if ((float10)_DAT_006e9808 < fVar7 - (float10)*(double *)(param_1 + 0x43df)) {
      fVar7 = (float10)FUN_00509a20();
      FUN_006c503f((double)(fVar7 - (float10)*(double *)(param_1 + 0x43df)));
      fStack_10 = (float)FUN_006c5018();
      *(double *)(param_1 + 0x43df) = (double)(int)fStack_10 + *(double *)(param_1 + 0x43df);
      FUN_00418590();
    }
  }
  return;
}


