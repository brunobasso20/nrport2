/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00420330 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00420330(int *param_1_00,int param_1,int param_2)

{
  undefined4 *puVar1;
  uint *puVar2;
  double dVar3;
  char cVar4;
  int iVar5;
  int *piVar6;
  undefined4 uVar7;
  uint uVar8;
  float10 fVar9;
  
  if ((char)param_1_00[0x31] == '\0') {
    return;
  }
  iVar5 = FUN_005099b0();
  if (iVar5 != 7) {
    return;
  }
  FUN_00415210();
  iVar5 = FUN_00417fc0();
  if (iVar5 != 7) {
    return;
  }
  iVar5 = FUN_00415210();
  dVar3 = *(double *)(iVar5 + 0x45c + param_2 * 8);
  fVar9 = (float10)FUN_00509a20();
  if (((((fVar9 < (float10)dVar3 + (float10)_DAT_006e9808) &&
        (iVar5 = FUN_00415210(), *(char *)(iVar5 + 0x4061 + param_1) == '\0')) && (param_1 != -1))
      && ((param_2 != -1 && (iVar5 = FUN_004f5970(param_1), iVar5 != 0)))) &&
     ((iVar5 = FUN_004f5970(param_1), *(int *)(iVar5 + 0x5ae) != 0 &&
      ((iVar5 = FUN_004f5970(param_2), iVar5 != 0 &&
       (iVar5 = FUN_004f5970(param_2), *(int *)(iVar5 + 0x5ae) != 0)))))) {
    piVar6 = (int *)FUN_00413e20();
    iVar5 = *piVar6;
    uVar7 = FUN_004f5970(param_1,0x4120cec4);
    uVar7 = FUN_004f5970(param_2,uVar7);
    cVar4 = (**(code **)(iVar5 + 0x40))(uVar7);
    if (cVar4 == '\0') {
      iVar5 = FUN_00413e20();
      if ((*(int *)(iVar5 + param_2 + 0x18c + param_2 * 0xc) != -1) &&
         (*(int *)(iVar5 + param_2 + param_2 * 0xc + 0x188) != -1)) goto LAB_00420523;
    }
    puVar1 = (undefined4 *)((int)param_1_00 + 0xf7);
    if (((*(int *)((int)param_1_00 + 0xfb) != 0) ||
        (*(int *)((int)param_1_00 + 0xff) != -0x40100000)) &&
       ((fVar9 = (float10)(**(code **)*puVar1)(),
        (float10)*(double *)((int)param_1_00 + 0xfb) < fVar9 ||
        (fVar9 = (float10)(**(code **)*puVar1)(),
        (float10)*(double *)((int)param_1_00 + 0xfb) - fVar9 == (float10)_DAT_006ea4b0)))) {
      puVar2 = (uint *)(param_1_00 + param_2 + 1);
      FUN_005351e0(puVar2,3,1);
      uVar8 = (**(code **)(*param_1_00 + 0x30))(param_2);
      *puVar2 = (uVar8 & 1) << 0x11 ^ *puVar2 & 0xfffdffff;
      *(undefined4 *)((int)param_1_00 + 0xff) = 0xbff00000;
      *(undefined4 *)((int)param_1_00 + 0xfb) = 0;
      return;
    }
    if (*(int *)((int)param_1_00 + 0xfb) != 0) {
      return;
    }
    if (*(int *)((int)param_1_00 + 0xff) != -0x40100000) {
      return;
    }
    fVar9 = (float10)(**(code **)*puVar1)();
    *(double *)((int)param_1_00 + 0xfb) = (double)(fVar9 + (float10)_DAT_006e9808);
    return;
  }
LAB_00420523:
  *(undefined4 *)((int)param_1_00 + 0xff) = 0xbff00000;
  *(undefined4 *)((int)param_1_00 + 0xfb) = 0;
  return;
}


