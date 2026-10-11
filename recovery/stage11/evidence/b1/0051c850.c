/* NR2003.exe @ 0051c850 FUN_0051c850 */

undefined4 * FUN_0051c850(undefined4 *param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  int iVar3;
  int *piVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  undefined4 *puVar8;
  
  if (DAT_00f7212b == '\0') {
    iVar6 = 0;
    DAT_00f6f108 = 8;
    DAT_00f6f110 = &DAT_00f6f118;
    DAT_00f6f10c = 5;
    iVar3 = 0;
    do {
      iVar6 = iVar6 + 1;
      *(undefined4 *)(iVar3 + (int)DAT_00f6f110) = 0xffffffff;
      *(undefined4 *)(iVar3 + 8 + (int)DAT_00f6f110) = 0;
      *(undefined4 *)(iVar3 + 4 + (int)DAT_00f6f110) = 0;
      iVar3 = iVar3 + 0xc;
    } while (iVar6 < DAT_00f6f10c);
    iVar3 = 0;
    iVar6 = (int)(0x17c4 / (longlong)DAT_00f6f108) * DAT_00f6f108;
    puVar8 = &DAT_00f6f154;
    while (puVar8 < (undefined4 *)((int)&DAT_00f6f154 + iVar6)) {
      *puVar8 = DAT_00f6f110[iVar3 * 3 + 2];
      DAT_00f6f110[iVar3 * 3 + 2] = puVar8;
      DAT_00f6f110[iVar3 * 3 + 1] = DAT_00f6f110[iVar3 * 3 + 1] + 1;
      puVar8 = (undefined4 *)((int)puVar8 + DAT_00f6f108);
      iVar3 = iVar3 + 1;
      if (iVar3 == DAT_00f6f10c) {
        iVar3 = 0;
      }
    }
    DAT_00f7212b = '\x01';
    FUN_0040c050(&DAT_00f72120,8);
  }
  puVar8 = (undefined4 *)0x0;
  iVar3 = 0;
  uVar1 = *param_1;
  uVar2 = param_1[1];
  if (0 < DAT_00f6f10c) {
    iVar6 = 0;
    do {
      piVar4 = (int *)(iVar6 + (int)DAT_00f6f110);
      LOCK();
      *piVar4 = *piVar4 + 1;
      UNLOCK();
      if ((*piVar4 == 0) && (*(int *)(iVar6 + 8 + (int)DAT_00f6f110) != 0)) {
        puVar8 = (undefined4 *)DAT_00f6f110[iVar3 * 3 + 2];
        DAT_00f6f110[iVar3 * 3 + 2] = *(undefined4 *)DAT_00f6f110[iVar3 * 3 + 2];
        DAT_00f6f110[iVar3 * 3 + 1] = DAT_00f6f110[iVar3 * 3 + 1] + -1;
        LOCK();
        DAT_00f6f110[iVar3 * 3] = DAT_00f6f110[iVar3 * 3] + -1;
        UNLOCK();
        break;
      }
      LOCK();
      *(int *)(iVar6 + (int)DAT_00f6f110) = *(int *)(iVar6 + (int)DAT_00f6f110) + -1;
      UNLOCK();
      iVar3 = iVar3 + 1;
      iVar6 = iVar6 + 0xc;
    } while (iVar3 < DAT_00f6f10c);
  }
  iVar7 = 0;
  iVar6 = 0;
  iVar3 = 0x300;
  if (0 < DAT_00f6f10c) {
    iVar5 = 0;
    do {
      piVar4 = (int *)((int)DAT_00f6f110 + iVar5);
      LOCK();
      *piVar4 = *piVar4 + 1;
      UNLOCK();
      if ((*piVar4 == 0) && (*(int *)(iVar5 + 4 + (int)DAT_00f6f110) < iVar3)) {
        iVar3 = *(int *)(iVar5 + 4 + (int)DAT_00f6f110);
        iVar6 = iVar7;
      }
      LOCK();
      *(int *)((int)DAT_00f6f110 + iVar5) = *(int *)((int)DAT_00f6f110 + iVar5) + -1;
      UNLOCK();
      iVar7 = iVar7 + 1;
      iVar5 = iVar5 + 0xc;
    } while (iVar7 < DAT_00f6f10c);
  }
  while( true ) {
    piVar4 = DAT_00f6f110 + iVar6 * 3;
    LOCK();
    *piVar4 = *piVar4 + 1;
    UNLOCK();
    if (*piVar4 == 0) break;
    LOCK();
    DAT_00f6f110[iVar6 * 3] = DAT_00f6f110[iVar6 * 3] + -1;
    UNLOCK();
    iVar6 = (iVar6 + 1) % DAT_00f6f10c;
  }
  *param_1 = DAT_00f6f110[iVar6 * 3 + 2];
  DAT_00f6f110[iVar6 * 3 + 2] = param_1;
  DAT_00f6f110[iVar6 * 3 + 1] = DAT_00f6f110[iVar6 * 3 + 1] + 1;
  LOCK();
  DAT_00f6f110[iVar6 * 3] = DAT_00f6f110[iVar6 * 3] + -1;
  UNLOCK();
  puVar8[1] = uVar2;
  *puVar8 = uVar1;
  return puVar8;
}

