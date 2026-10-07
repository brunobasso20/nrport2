/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00420a10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00420a10(int param_1_00,int param_1)

{
  undefined4 *puVar1;
  uint *puVar2;
  float fVar3;
  float fVar4;
  double dVar5;
  int iVar6;
  int *piVar7;
  int iVar8;
  int iVar9;
  undefined4 uVar10;
  uint uVar11;
  int *unaff_EBX;
  float10 fVar12;
  
  if (*(char *)(param_1_00 + 0xc4) == '\0') {
    return;
  }
  iVar6 = FUN_005099b0();
  if (iVar6 != 7) {
    return;
  }
  iVar6 = FUN_00413e20();
  if (param_1 < 0) {
    return;
  }
  if (0x2f < param_1) {
    return;
  }
  if (*(int *)(iVar6 + param_1 * 0xd + 0x18c) < 1) {
    return;
  }
  piVar7 = (int *)FUN_00413e20();
  iVar6 = (**(code **)(*piVar7 + 0x20))(param_1);
  iVar8 = FUN_00415210();
  dVar5 = *(double *)(iVar8 + 0x45c + param_1 * 8);
  fVar12 = (float10)FUN_00509a20();
  if ((float10)dVar5 + (float10)_DAT_006e9808 <= fVar12) {
    return;
  }
  if (iVar6 == -1) {
    return;
  }
  iVar8 = FUN_004f5970(param_1);
  if (iVar8 != 0) {
    iVar8 = FUN_004f5970(param_1);
    if (*(int *)(iVar8 + 0x5ae) == 0) {
      return;
    }
    iVar8 = FUN_004f5970(iVar6);
    if (iVar8 == 0) {
      return;
    }
    iVar8 = FUN_004f5970(iVar6);
    if (*(int *)(iVar8 + 0x5ae) == 0) {
      return;
    }
    iVar8 = FUN_004f5970(param_1);
    iVar8 = *(int *)(iVar8 + 0x5ae);
    iVar9 = FUN_004f5970(iVar6);
    iVar9 = *(int *)(iVar9 + 0x5ae);
    iVar6 = FUN_004f5970(iVar6);
    fVar3 = *(float *)(iVar8 + 0x3c);
    fVar4 = *(float *)(iVar9 + 0x3c);
    iVar6 = *(int *)(iVar6 + 0x1a8a);
    fVar12 = (float10)FUN_00516e1a();
    iVar8 = FUN_004f5970(param_1);
    fVar3 = (float)(*(int *)(iVar8 + 0x1a8a) - iVar6) + (float)((float10)(fVar3 - fVar4) / fVar12);
    if (_DAT_006ea454 < fVar3) {
      puVar1 = (undefined4 *)((int)unaff_EBX + param_1 * 0xc + 0xf7);
      if ((((*(int *)((int)unaff_EBX + param_1 * 0xc + 0xfb) != 0) ||
           (*(int *)((int)unaff_EBX + param_1 * 0xc + 0xff) != -0x40100000)) &&
          ((fVar12 = (float10)(**(code **)*puVar1)(),
           (float10)*(double *)((int)unaff_EBX + param_1 * 0xc + 0xfb) < fVar12 ||
           (fVar12 = (float10)(**(code **)*puVar1)(),
           (float10)*(double *)((int)unaff_EBX + param_1 * 0xc + 0xfb) - fVar12 ==
           (float10)_DAT_006ea4b0)))) &&
         (((char)param_1 != '\0' &&
          (puVar2 = (uint *)(unaff_EBX + param_1 + 1), (unaff_EBX[param_1 + 1] & 0xfff0U) == 0)))) {
        if (((&DAT_0086c89c)[param_1 * 4] & 0xf) == 0) {
          uVar10 = FUN_006c5018();
          FUN_00535220(puVar2,4,uVar10);
          uVar11 = (**(code **)(*unaff_EBX + 0x30))(param_1);
          *puVar2 = (uVar11 & 1) << 0x11 ^ *puVar2 & 0xfffdffff;
        }
        else {
          FUN_004205d0(param_1,_DAT_00b8fa5c * fVar3 * _DAT_006ed070 + _DAT_006e97d8);
        }
        *(undefined4 *)((int)unaff_EBX + param_1 * 0xc + 0xfb) = 0;
        *(undefined4 *)((int)unaff_EBX + param_1 * 0xc + 0xff) = 0xbff00000;
        return;
      }
      if ((*(int *)((int)unaff_EBX + param_1 * 0xc + 0xfb) == 0) &&
         (*(int *)((int)unaff_EBX + param_1 * 0xc + 0xff) == -0x40100000)) {
        fVar12 = (float10)(**(code **)*puVar1)();
        *(double *)((int)unaff_EBX + param_1 * 0xc + 0xfb) =
             (double)(fVar12 + (float10)_DAT_006e9808);
        return;
      }
      return;
    }
    *(undefined4 *)((int)unaff_EBX + param_1 * 0xc + 0xfb) = 0;
    *(undefined4 *)((int)unaff_EBX + param_1 * 0xc + 0xff) = 0xbff00000;
    return;
  }
  return;
}


