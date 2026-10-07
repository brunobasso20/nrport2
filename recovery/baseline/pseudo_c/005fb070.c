/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005fb070 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_005fb070(void)

{
  float fVar1;
  char cVar2;
  int iVar3;
  int *piVar4;
  undefined4 *puVar5;
  int iVar6;
  uint unaff_EBX;
  int unaff_ESI;
  int unaff_EDI;
  float10 fVar7;
  float10 extraout_ST0;
  float10 extraout_ST1;
  undefined4 *puVar8;
  float fVar9;
  uint uStack_20;
  float fStack_1c;
  undefined4 uStack_18;
  undefined4 uStack_14;
  undefined4 uStack_10;
  undefined4 auStack_c [3];
  
  if (DAT_00f727b0 == (int *)0x0) {
    return 0;
  }
  if (DAT_00f727b0[8] != 0) {
    if (((DAT_00f727b4 == 0) || (DAT_00f727b4 == 2)) &&
       (iVar3 = (**(code **)(*DAT_00f727b0 + 0x70))(), iVar3 == 0)) {
      return 0;
    }
    piVar4 = DAT_00f727b0;
    *(undefined1 *)((int)DAT_00f727b0 + 0x32) = 0;
    *(int **)(piVar4[8] + 0x3d) = piVar4;
    FUN_005fba00();
    uStack_10 = 800;
    auStack_c[0] = 600;
    uStack_14 = 800;
    uStack_18 = 600;
    uStack_20 = 0xffffffff;
    piVar4 = (int *)FUN_005d35f0();
    puVar8 = &uStack_18;
    (**(code **)(*DAT_00f727b0 + 100))(&uStack_10,auStack_c,&uStack_14,puVar8,&uStack_20);
    cVar2 = FUN_0060e2a0();
    if ((cVar2 == '\0') &&
       (((iVar3 = (**(code **)*piVar4)(), iVar3 != unaff_ESI ||
         (iVar3 = (**(code **)(*piVar4 + 4))(), iVar3 != unaff_EDI)) ||
        ((puVar8 != (undefined4 *)0xffffffff &&
         (puVar5 = (undefined4 *)(**(code **)(*piVar4 + 8))(), puVar5 != puVar8)))))) {
      FUN_0060ebc0(unaff_ESI,unaff_EDI,puVar8);
      iVar3 = FUN_0060edd0(unaff_ESI,unaff_EDI,puVar8);
      if (iVar3 != 1) {
        return 0;
      }
    }
    piVar4 = (int *)FUN_005d35f0();
    iVar3 = 0;
    fStack_1c = (float)(**(code **)*piVar4)();
    uStack_18 = 0;
    fVar9 = (float)(uint)fStack_1c;
    fStack_1c = (float)(**(code **)(*piVar4 + 4))();
    uStack_18 = 0;
    fVar7 = (float10)(uint)fStack_1c;
    if ((float10)_DAT_006f8e34 <= (float10)fVar9 / fVar7) {
      iVar3 = FUN_006c5018();
      iVar6 = FUN_006c5018();
      fVar9 = (float)extraout_ST0;
      iVar3 = DAT_00754638 * ((iVar6 - iVar3) / 2);
      fVar7 = extraout_ST1;
    }
    uStack_18 = 0;
    fVar9 = fVar9 / (float)unaff_EBX;
    fStack_1c = (float)(fVar7 / (float10)uStack_20);
    iVar6 = FUN_0060ebc0();
    fVar1 = _DAT_006e97d8 / fVar9;
    *(float *)(iVar6 + 0x16) = fVar9;
    piVar4 = DAT_00f727b0;
    *(float *)(iVar6 + 0x1a) = fStack_1c;
    *(int *)(iVar6 + 0x26) = iVar3;
    *(float *)(iVar6 + 0x1e) = fVar1;
    *(float *)(iVar6 + 0x22) = _DAT_006e97d8 / fStack_1c;
    iVar3 = (**(code **)(*piVar4 + 0x20))();
    if (iVar3 != 0) {
      DAT_00f7279c = DAT_00f727b0;
    }
    return iVar3;
  }
  return 0;
}


