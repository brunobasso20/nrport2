/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00420680 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00420680(int *param_1_00,int param_1,char param_3)

{
  undefined4 *puVar1;
  uint *puVar2;
  float fVar3;
  float fVar4;
  double dVar5;
  int iVar6;
  int iVar7;
  undefined4 uVar8;
  uint uVar9;
  float10 fVar10;
  
  if (((char)param_1_00[0x31] != '\0') &&
     (iVar6 = FUN_00415210(), *(char *)(iVar6 + 0x3ef0 + param_1) == '\0')) {
    iVar6 = FUN_00415210();
    dVar5 = *(double *)(iVar6 + 0x45c + param_1 * 8);
    fVar10 = (float10)FUN_00509a20();
    if ((fVar10 < (float10)dVar5 + (float10)_DAT_006e9808) &&
       ((((iVar6 = FUN_004f5970(param_1), iVar6 != 0 &&
          (iVar6 = FUN_004f5970(param_1), *(int *)(iVar6 + 0x5ae) != 0)) && (DAT_00760b38 != 0)) &&
        (*(int *)(DAT_00760b38 + 0x5ae) != 0)))) {
      iVar7 = FUN_004f5970(param_1);
      iVar6 = DAT_00760b38;
      fVar3 = *(float *)(*(int *)(iVar7 + 0x5ae) + 0x3c);
      fVar4 = *(float *)(*(int *)(DAT_00760b38 + 0x5ae) + 0x3c);
      fVar10 = (float10)FUN_00516e1a();
      iVar7 = FUN_004f5970(param_1);
      fVar3 = (float)(*(int *)(iVar7 + 0x1a8a) - *(int *)(iVar6 + 0x1a8a)) +
              (float)((float10)(fVar3 - fVar4) / fVar10);
      if (fVar3 <= _DAT_006ea454) {
        *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0xfb) = 0;
        *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0xff) = 0xbff00000;
      }
      else {
        puVar1 = (undefined4 *)((int)param_1_00 + param_1 * 0xc + 0xf7);
        if ((((*(int *)((int)param_1_00 + param_1 * 0xc + 0xfb) != 0) ||
             (*(int *)((int)param_1_00 + param_1 * 0xc + 0xff) != -0x40100000)) &&
            ((fVar10 = (float10)(**(code **)*puVar1)(),
             (float10)*(double *)((int)param_1_00 + param_1 * 0xc + 0xfb) < fVar10 ||
             (fVar10 = (float10)(**(code **)*puVar1)(),
             (float10)*(double *)((int)param_1_00 + param_1 * 0xc + 0xfb) - fVar10 ==
             (float10)_DAT_006ea4b0)))) &&
           ((param_3 != '\0' &&
            (puVar2 = (uint *)(param_1_00 + param_1 + 1), (param_1_00[param_1 + 1] & 0xfff0U) == 0))
           )) {
          if (((&DAT_00870894)[param_1 * 4] & 0xf) == 0) {
            uVar8 = FUN_006c5018();
            FUN_00535220(puVar2,4,uVar8);
            uVar9 = (**(code **)(*param_1_00 + 0x30))(param_1);
            *puVar2 = (uVar9 & 1) << 0x11 ^ *puVar2 & 0xfffdffff;
          }
          else {
            FUN_00420960(param_1,_DAT_00b8fa5c * fVar3 * _DAT_006ed070 + _DAT_006e97d8);
          }
          *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0xfb) = 0;
          *(undefined4 *)((int)param_1_00 + param_1 * 0xc + 0xff) = 0xbff00000;
          return;
        }
        if ((*(int *)((int)param_1_00 + param_1 * 0xc + 0xfb) == 0) &&
           (*(int *)((int)param_1_00 + param_1 * 0xc + 0xff) == -0x40100000)) {
          fVar10 = (float10)(**(code **)*puVar1)();
          *(double *)((int)param_1_00 + param_1 * 0xc + 0xfb) =
               (double)(fVar10 + (float10)_DAT_006e9808);
          return;
        }
      }
    }
  }
  return;
}


