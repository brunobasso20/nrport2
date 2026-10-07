/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0041a760 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_0041a760(int param_1_00,char param_1,double param_3)

{
  undefined4 *puVar1;
  char cVar2;
  int iVar3;
  int *piVar4;
  double *pdVar5;
  float10 fVar6;
  int iVar7;
  undefined4 uVar8;
  int iStack_1c;
  int iStack_18;
  undefined4 uStack_10;
  undefined4 uStack_c;
  
  puVar1 = (undefined4 *)(param_1_00 + 0x4055);
  if ((((*(int *)(param_1_00 + 0x4059) != 0) || (*(int *)(param_1_00 + 0x405d) != -0x40100000)) &&
      (fVar6 = (float10)(**(code **)*puVar1)(), fVar6 <= (float10)*(double *)(param_1_00 + 0x4059)))
     && (fVar6 = (float10)(**(code **)*puVar1)(),
        (float10)_DAT_006ea4b0 < (float10)*(double *)(param_1_00 + 0x4059) - fVar6)) {
    return 0;
  }
  fVar6 = (float10)(**(code **)*puVar1)();
  *(double *)(param_1_00 + 0x4059) = (double)(fVar6 + (float10)_DAT_006e9830);
  iVar3 = FUN_005099b0();
  if (((iVar3 != 6) || (iVar3 = FUN_00509b60(0xffffffff), iVar3 != 5)) &&
     ((iVar3 = FUN_005099b0(), iVar3 != 7 || (iVar3 = FUN_00509b60(0xffffffff), iVar3 != 4)))) {
    return 0;
  }
  iStack_18 = 0;
  iVar3 = 0;
  do {
    iVar7 = iVar3;
    FUN_00538ac0(iVar3);
    cVar2 = FUN_0053b6a0(iVar7);
    if (cVar2 != '\0') {
      iStack_18 = iStack_18 + 1;
    }
    iVar3 = iVar3 + 1;
  } while (iVar3 < 0x30);
  iStack_1c = 0;
  piVar4 = &DAT_00acca34;
  pdVar5 = (double *)(param_1_00 + 0x75c);
  do {
    iVar3 = iStack_1c;
    FUN_00538ac0(iStack_1c);
    cVar2 = FUN_0053b6a0(iVar3);
    if ((cVar2 != '\0') && (*piVar4 == 0)) {
      if (pdVar5[-0xc0] <= *pdVar5) {
        uStack_10 = *(undefined4 *)pdVar5;
        uStack_c = *(undefined4 *)((int)pdVar5 + 4);
      }
      else {
        uStack_10 = *(undefined4 *)(pdVar5 + -0xc0);
        uStack_c = *(undefined4 *)((int)pdVar5 + -0x5fc);
      }
      if (((param_1 == '\0') || (*(char *)(iStack_1c + 300 + param_1_00) != '\0')) &&
         (fVar6 = (float10)FUN_00509a20(),
         (float10)param_3 < fVar6 - (float10)(double)CONCAT44(uStack_c,uStack_10))) {
        iStack_18 = iStack_18 + -1;
      }
    }
    piVar4 = piVar4 + 0x885;
    iStack_1c = iStack_1c + 1;
    pdVar5 = pdVar5 + 1;
  } while ((int)piVar4 < 0xb32df4);
  if (iStack_18 < 1) {
    iVar3 = 0;
    do {
      iVar7 = iVar3;
      FUN_00538ac0(iVar3);
      FUN_0053b530(iVar7);
      iVar3 = iVar3 + 1;
    } while (iVar3 < 0x30);
  }
  cVar2 = FUN_0056e2b0();
  if (cVar2 != '\0') {
    uVar8 = *(undefined4 *)(param_1_00 + 0x43db);
    FUN_00538ac0(uVar8);
    FUN_0053b530(uVar8);
  }
  return 1;
}


