/* NR2003.exe @ 0053faa0 FUN_0053faa0 */

void FUN_0053faa0(undefined4 *param_1)

{
  undefined2 uVar1;
  undefined4 uVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  uint uVar5;
  int iVar6;
  int iVar7;
  uint *puVar8;
  float10 fVar9;
  undefined8 uVar10;
  undefined4 uVar11;
  undefined4 uVar12;
  
  if (param_1 == (undefined4 *)0x0) {
    param_1 = &DAT_00be0d18;
  }
  uVar1 = FUN_00573cb0();
  *(undefined2 *)((int)param_1 + 0xd6) = uVar1;
  uVar1 = FUN_00573cc0();
  *(undefined2 *)(param_1 + 0x35) = uVar1;
  *param_1 = DAT_00bdbd00;
  param_1[1] = DAT_00bddde0;
  uVar2 = FUN_004233a0();
  param_1[2] = uVar2;
  param_1[3] = DAT_00bdc4d0;
  param_1[4] = DAT_00bdbcf8;
  param_1[5] = DAT_00bdbd04;
  fVar9 = (float10)FUN_00510080();
  param_1[0x1a] = (float)fVar9;
  fVar9 = (float10)FUN_00510090();
  param_1[0x1b] = (float)fVar9;
  fVar9 = (float10)FUN_005100a0();
  param_1[0x1c] = (float)fVar9;
  fVar9 = (float10)FUN_005100b0();
  param_1[0x1d] = (float)fVar9;
  puVar3 = &DAT_0074fb30;
  puVar4 = param_1 + 6;
  do {
    uVar2 = *puVar3;
    puVar3 = puVar3 + 1;
    *puVar4 = uVar2;
    puVar4 = puVar4 + 1;
  } while ((int)puVar3 < 0x74fb80);
  puVar4 = &DAT_00bddd24;
  puVar3 = param_1 + 0x1e;
  for (iVar6 = 7; iVar6 != 0; iVar6 = iVar6 + -1) {
    *puVar3 = *puVar4;
    puVar4 = puVar4 + 1;
    puVar3 = puVar3 + 1;
  }
  iVar7 = 0;
  iVar6 = FUN_00536160();
  if (0 < iVar6) {
    puVar8 = param_1 + 0x26;
    do {
      iVar6 = FUN_00536260(iVar7);
      puVar8[-1] = *(uint *)(iVar6 + 0x2b);
      iVar6 = FUN_00536260(iVar7);
      *puVar8 = (uint)(*(char *)(iVar6 + 8) != '\0');
      iVar6 = FUN_00536260(iVar7);
      puVar8[1] = (uint)(*(char *)(iVar6 + 9) != '\0');
      iVar6 = FUN_00536260(iVar7);
      puVar8[2] = *(uint *)(iVar6 + 0xb);
      iVar6 = FUN_00536260(iVar7);
      puVar8[3] = *(uint *)(iVar6 + 0xf);
      iVar6 = FUN_00536260(iVar7);
      puVar8[4] = *(uint *)(iVar6 + 0x13);
      iVar6 = FUN_00536260(iVar7);
      puVar8[5] = *(uint *)(iVar6 + 0x17);
      iVar7 = iVar7 + 1;
      puVar8 = puVar8 + 7;
      iVar6 = FUN_00536160();
    } while (iVar7 < iVar6);
    if (1 < iVar7) goto LAB_0053fc3a;
  }
  iVar6 = 2 - iVar7;
  puVar4 = param_1 + iVar7 * 7 + 0x26;
  do {
    puVar4[-1] = 0xbf800000;
    *puVar4 = 0;
    puVar4[1] = 0;
    puVar4[2] = 0xbf800000;
    puVar4[3] = 0xbf800000;
    puVar4[4] = 0xbf800000;
    puVar4[5] = 0xbf800000;
    puVar4 = puVar4 + 7;
    iVar6 = iVar6 + -1;
  } while (iVar6 != 0);
LAB_0053fc3a:
  *(undefined2 *)(param_1 + 0x33) = 0xffff;
  iVar6 = 0;
  uVar10 = FUN_00536170();
  uVar2 = (undefined4)((ulonglong)uVar10 >> 0x20);
  if (0 < (int)uVar10) {
    do {
      uVar12 = CONCAT22((short)((uint)uVar2 >> 0x10),*(undefined2 *)(param_1 + 0x33));
      uVar11 = 0xc;
      uVar2 = FUN_00536280(iVar6);
      uVar1 = FUN_005f7610(uVar2,uVar11,uVar12);
      *(undefined2 *)(param_1 + 0x33) = uVar1;
      iVar6 = iVar6 + 1;
      uVar10 = FUN_00536170();
      uVar2 = (undefined4)((ulonglong)uVar10 >> 0x20);
    } while (iVar6 < (int)uVar10);
  }
  uVar2 = FUN_005f7610(&DAT_00bddf28,4,0xffff);
  *(short *)((int)param_1 + 0xce) = (short)uVar2;
  uVar1 = FUN_005f7610(&DAT_00bddcd8,4,uVar2);
  *(undefined2 *)((int)param_1 + 0xce) = uVar1;
  *(undefined2 *)(param_1 + 0x34) = 0xffff;
  iVar7 = 0;
  iVar6 = FUN_00536050();
  if (0 < iVar6) {
    do {
      uVar5 = (uint)*(ushort *)(param_1 + 0x34);
      uVar12 = 0xc;
      uVar2 = FUN_00536080(iVar7);
      uVar1 = FUN_005f7610(uVar2,uVar12,uVar5);
      *(undefined2 *)(param_1 + 0x34) = uVar1;
      iVar7 = iVar7 + 1;
      iVar6 = FUN_00536050();
    } while (iVar7 < iVar6);
  }
  uVar1 = FUN_005f7610(&DAT_00bdba78,DAT_00bde2a8 * 0x14,0xffff);
  *(undefined2 *)((int)param_1 + 0xd2) = uVar1;
  *(ushort *)(param_1 + 0x36) = (ushort)DAT_00be0c34;
  return;
}

