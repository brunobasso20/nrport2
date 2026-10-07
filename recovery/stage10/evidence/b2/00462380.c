/* NR2003.exe @ 00462380 FUN_00462380 */

void __fastcall FUN_00462380(int *param_1)

{
  int *piVar1;
  int *piVar2;
  char cVar3;
  undefined4 uVar4;
  int iVar5;
  int iVar6;
  float10 fVar7;
  undefined *puVar8;
  undefined4 uVar9;
  
  cVar3 = DAT_008b3088;
  if (*(char *)((int)param_1 + 0x327) == '\0') {
    if ((DAT_008b3088 != '\0') && (*(char *)(param_1 + 0xca) == '\0')) {
      (**(code **)(*param_1 + 0x1c))();
      FUN_00462dd0();
    }
    *(char *)(param_1 + 0xca) = cVar3;
  }
  else if (*(char *)((int)param_1 + 0x329) == '\0') {
    FUN_00462dd0();
    cVar3 = DAT_008b3088;
    *(undefined *)((int)param_1 + 0x327) = 0;
    *(char *)(param_1 + 0xca) = cVar3;
  }
  else {
    *(undefined *)((int)param_1 + 0x329) = 0;
  }
  uVar9 = 0x400;
  puVar8 = &DAT_008b4ef8;
  uVar4 = FUN_0045f2b0(DAT_008b3089);
  FUN_005f9730(uVar4,puVar8,uVar9);
  piVar1 = **(int ***)(*(int *)((int)param_1 + 0x32a) + 0x1ae);
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 0x68))(&DAT_008b4ef8);
  }
  uVar9 = 0x400;
  puVar8 = &DAT_008b4ef8;
  uVar4 = FUN_00460650(DAT_008b308d);
  FUN_005f9730(uVar4,puVar8,uVar9);
  piVar1 = **(int ***)(*(int *)((int)param_1 + 0x32e) + 0x1ae);
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 0x68))(&DAT_008b4ef8);
  }
  FUN_005f9730(0x2714,&DAT_008b4ef8,0x400);
  piVar1 = **(int ***)(*(int *)((int)param_1 + 0x332) + 0x1ae);
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 0x68))(&DAT_008b4ef8);
  }
  piVar1 = **(int ***)(*(int *)((int)param_1 + 0x336) + 0x1ae);
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 0x6c))(&DAT_008b572a);
  }
  piVar1 = **(int ***)(*(int *)((int)param_1 + 0x33a) + 0x1ae);
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 0x6c))(&DAT_008b572b);
  }
  piVar1 = **(int ***)(*(int *)((int)param_1 + 0x33e) + 0x1ae);
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 0x6c))(&DAT_008b572c);
  }
  iVar6 = 0;
  iVar5 = 0;
  do {
    fVar7 = (float10)FUN_00557e40(iVar5);
    if ((NAN(fVar7) || NAN((float10)(float)(&DAT_008b3091)[iVar5])) ==
        (fVar7 == (float10)(float)(&DAT_008b3091)[iVar5])) {
      FUN_005f9730(0x3cd7,&DAT_008b4ef8,0x400);
      iVar6 = 1;
      piVar1 = **(int ***)(*(int *)((int)param_1 + 0x332) + 0x1ae);
      if (piVar1 != (int *)0x0) {
        (**(code **)(*piVar1 + 0x68))(&DAT_008b4ef8);
      }
      break;
    }
    iVar5 = iVar5 + 1;
  } while (iVar5 < 4);
  iVar5 = FUN_00557ee0(0x40);
  if (DAT_008b30a1 != iVar5) {
    FUN_005f9730(0x3cd8,&DAT_008b4ef8,0x400);
    iVar5 = iVar6 * 4;
    iVar6 = iVar6 + 1;
    piVar1 = **(int ***)(*(int *)((int)param_1 + iVar5 + 0x332) + 0x1ae);
    if (piVar1 != (int *)0x0) {
      (**(code **)(*piVar1 + 0x68))(&DAT_008b4ef8);
    }
  }
  fVar7 = (float10)FUN_00557e40(0x2e);
  if ((NAN(fVar7) || NAN((float10)DAT_008b30a5)) == (fVar7 == (float10)DAT_008b30a5)) {
    FUN_005f9730(0x3cd9,&DAT_008b4ef8,0x400);
    iVar5 = iVar6 * 4;
    iVar6 = iVar6 + 1;
    piVar1 = **(int ***)(*(int *)((int)param_1 + iVar5 + 0x332) + 0x1ae);
    if (piVar1 != (int *)0x0) {
      (**(code **)(*piVar1 + 0x68))(&DAT_008b4ef8);
    }
  }
  iVar5 = FUN_00557ee0(0x3b);
  if (DAT_008b30a9 != iVar5) {
    FUN_005f9730(0x3cda,&DAT_008b4ef8,0x400);
    piVar1 = **(int ***)(*(int *)((int)param_1 + iVar6 * 4 + 0x332) + 0x1ae);
    if (piVar1 != (int *)0x0) {
      (**(code **)(*piVar1 + 0x68))(&DAT_008b4ef8);
    }
  }
  if (DAT_008b30ae == '\0') {
    (**(code **)(**(int **)((int)param_1 + 0x346) + 0x4c))();
                    /* WARNING: Could not recover jumptable at 0x004626b5. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (**(code **)(**(int **)((int)param_1 + 0x342) + 0x4c))();
    return;
  }
  uVar4 = 0x3f2;
  if (DAT_008b30ad != '\0') {
    uVar4 = 0x3f1;
  }
  FUN_005f9730(uVar4,&DAT_008b4ef8,0x400);
  piVar1 = *(int **)((int)param_1 + 0x342);
  piVar2 = **(int ***)((int)piVar1 + 0x1ae);
  if (piVar2 != (int *)0x0) {
    (**(code **)(*piVar2 + 0x68))(&DAT_008b4ef8);
  }
  FUN_00613d40();
  (**(code **)(**(int **)((int)param_1 + 0x346) + 0x50))();
                    /* WARNING: Could not recover jumptable at 0x0046269d. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **)(*piVar1 + 0x50))();
  return;
}

