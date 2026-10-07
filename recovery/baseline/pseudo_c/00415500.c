/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00415500 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00415500(int param_1)

{
  uint uVar1;
  undefined4 uVar2;
  int *piVar3;
  int iVar4;
  int iVar5;
  float *pfVar6;
  undefined1 *puVar7;
  undefined4 *puVar8;
  undefined2 *puVar9;
  byte *pbVar10;
  float10 fVar11;
  float fStack_c;
  
  FUN_0053d050();
  uVar1 = (uint)((byte)(DAT_00bebd84 >> 0x19) & 1);
  uVar2 = FUN_005099b0(uVar1);
  FUN_00534e40(uVar2,uVar1);
  piVar3 = (int *)FUN_00413e30(0);
  iVar4 = FUN_00413e20();
  iVar5 = *piVar3;
  *(int **)(iVar4 + 0x3f8) = piVar3;
  uVar2 = (**(code **)(iVar5 + 4))();
  *(undefined4 *)(iVar4 + 0x3f4) = uVar2;
  piVar3 = (int *)FUN_00413e20();
  (**(code **)(*piVar3 + 4))();
  *(undefined4 *)(param_1 + 0x4333) = 2;
  *(undefined4 *)(param_1 + 0x4337) = 2;
  *(undefined4 *)(param_1 + 0x436b) = 0x201;
  iVar5 = FUN_005099b0();
  if (iVar5 != 7) goto LAB_004156c4;
  FUN_00538ab0();
  iVar5 = FUN_00539880();
  piVar3 = (int *)FUN_00413e20();
  (**(code **)(*piVar3 + 8))(iVar5);
  iVar4 = 0;
  pbVar10 = (byte *)(iVar5 + 9);
  do {
    uVar1 = (uint)*pbVar10;
    if (*pbVar10 < 0x30) {
      if (uVar1 == *(uint *)(DAT_00760b38 + 0x5b2)) {
        pfVar6 = (float *)FUN_005360b0();
        fStack_c = *pfVar6;
      }
      else {
        pfVar6 = (float *)FUN_00536080(iVar4);
        fStack_c = *pfVar6;
      }
      if (((DAT_00bebd84 & 0x1000000) == 0) ||
         (fVar11 = (float10)FUN_00516e1a(), (float10)fStack_c < fVar11 * (float10)_DAT_006ea44c)) {
        iVar5 = FUN_004f5970(uVar1);
        *(undefined4 *)(iVar5 + 0x1a8a) = 0;
      }
      else {
        iVar5 = FUN_004f5970(uVar1);
        *(undefined4 *)(iVar5 + 0x1a8a) = 0xffffffff;
      }
    }
    iVar4 = iVar4 + 1;
    pbVar10 = pbVar10 + 10;
  } while (iVar4 < 0x30);
  if ((-1 < *(int *)(DAT_00760b38 + 0x5b2)) && (*(int *)(DAT_00760b38 + 0x5b2) < 0x30)) {
    if ((DAT_00bebd84 & 0x1000000) != 0) {
      pfVar6 = (float *)FUN_005360b0();
      fVar11 = (float10)FUN_00516e1a();
      if (fVar11 * (float10)_DAT_006ea44c <= (float10)*pfVar6) {
        iVar5 = FUN_004f5970(*(undefined4 *)(DAT_00760b38 + 0x5b2));
        *(undefined4 *)(iVar5 + 0x1a8a) = 0xffffffff;
        goto LAB_004156b6;
      }
    }
    iVar5 = FUN_004f5970(*(undefined4 *)(DAT_00760b38 + 0x5b2));
    *(undefined4 *)(iVar5 + 0x1a8a) = 0;
  }
LAB_004156b6:
  *(undefined4 *)(param_1 + 0x4333) = 0;
  *(undefined4 *)(param_1 + 0x4337) = 0;
LAB_004156c4:
  (**(code **)*DAT_00bdb9d8)();
  fVar11 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x4055))();
  puVar7 = (undefined1 *)(param_1 + 0x42d1);
  puVar8 = (undefined4 *)(param_1 + 0x4095);
  puVar9 = (undefined2 *)(param_1 + 0x436f);
  *(double *)(param_1 + 0x4059) = (double)(fVar11 + (float10)_DAT_006e9830);
  do {
    *puVar9 = 0;
    puVar7[-0x270] = 0;
    *puVar8 = 0;
    puVar8[1] = 0xbff00000;
    *puVar7 = 0;
    puVar7[0x30] = 1;
    puVar7[-0x2ac] = 0;
    puVar9 = puVar9 + 1;
    puVar8 = puVar8 + 3;
    puVar7 = puVar7 + 1;
  } while ((int)(puVar7 + (-0x42d1 - param_1)) < 0x30);
  *(undefined4 *)(param_1 + 0x3f50) = 0xffffffff;
  *(undefined4 *)(param_1 + 0x3f58) = 0xffffffff;
  *(undefined4 *)(param_1 + 0x3f60) = 0xffffffff;
  *(undefined4 *)(param_1 + 0x43d3) = 0xffffffff;
  *(undefined4 *)(param_1 + 0x43d7) = 0xffffffff;
  *(undefined4 *)(param_1 + 0x9d4) = 0xfffffff6;
  *(undefined4 *)(param_1 + 0x3f54) = 5;
  *(undefined4 *)(param_1 + 0x3f5c) = 0xbf800000;
  *(undefined4 *)(param_1 + 0x43df) = 0;
  *(undefined4 *)(param_1 + 0x43e3) = 0;
  puVar8 = (undefined4 *)(param_1 + 0x3f65);
  for (iVar5 = 0x30; iVar5 != 0; iVar5 = iVar5 + -1) {
    *puVar8 = 0;
    puVar8 = puVar8 + 1;
  }
  FUN_00535570();
  return;
}


