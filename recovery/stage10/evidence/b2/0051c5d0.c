/* NR2003.exe @ 0051c5d0 FUN_0051c5d0 */

undefined4 * FUN_0051c5d0(undefined4 *param_1)

{
  undefined4 uVar1;
  int iVar2;
  int *piVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  undefined4 *puVar7;
  
  if (DAT_00f7212a == '\0') {
    iVar5 = 0;
    DAT_00f6eafc = 4;
    DAT_00f6eb04 = &DAT_00f70918;
    DAT_00f6eb00 = 5;
    iVar2 = 0;
    do {
      iVar5 = iVar5 + 1;
      *(undefined4 *)(iVar2 + (int)DAT_00f6eb04) = 0xffffffff;
      *(undefined4 *)(iVar2 + 8 + (int)DAT_00f6eb04) = 0;
      *(undefined4 *)(iVar2 + 4 + (int)DAT_00f6eb04) = 0;
      iVar2 = iVar2 + 0xc;
    } while (iVar5 < DAT_00f6eb00);
    iVar2 = 0;
    iVar5 = (int)(0x17c4 / (longlong)DAT_00f6eafc) * DAT_00f6eafc;
    puVar7 = &DAT_00f70954;
    while (puVar7 < (undefined4 *)((int)&DAT_00f70954 + iVar5)) {
      *puVar7 = DAT_00f6eb04[iVar2 * 3 + 2];
      DAT_00f6eb04[iVar2 * 3 + 2] = puVar7;
      DAT_00f6eb04[iVar2 * 3 + 1] = DAT_00f6eb04[iVar2 * 3 + 1] + 1;
      puVar7 = (undefined4 *)((int)puVar7 + DAT_00f6eafc);
      iVar2 = iVar2 + 1;
      if (iVar2 == DAT_00f6eb00) {
        iVar2 = 0;
      }
    }
    DAT_00f7212a = '\x01';
    FUN_004f68c0(&DAT_00f72118,4);
  }
  puVar7 = (undefined4 *)0x0;
  iVar2 = 0;
  uVar1 = *param_1;
  if (0 < DAT_00f6eb00) {
    iVar5 = 0;
    do {
      piVar3 = (int *)(iVar5 + (int)DAT_00f6eb04);
      LOCK();
      *piVar3 = *piVar3 + 1;
      UNLOCK();
      if ((*piVar3 == 0) && (*(int *)(iVar5 + 8 + (int)DAT_00f6eb04) != 0)) {
        puVar7 = (undefined4 *)DAT_00f6eb04[iVar2 * 3 + 2];
        DAT_00f6eb04[iVar2 * 3 + 2] = *(undefined4 *)DAT_00f6eb04[iVar2 * 3 + 2];
        DAT_00f6eb04[iVar2 * 3 + 1] = DAT_00f6eb04[iVar2 * 3 + 1] + -1;
        LOCK();
        DAT_00f6eb04[iVar2 * 3] = DAT_00f6eb04[iVar2 * 3] + -1;
        UNLOCK();
        break;
      }
      LOCK();
      *(int *)(iVar5 + (int)DAT_00f6eb04) = *(int *)(iVar5 + (int)DAT_00f6eb04) + -1;
      UNLOCK();
      iVar2 = iVar2 + 1;
      iVar5 = iVar5 + 0xc;
    } while (iVar2 < DAT_00f6eb00);
  }
  iVar6 = 0;
  iVar5 = 0;
  iVar2 = 0x600;
  if (0 < DAT_00f6eb00) {
    iVar4 = 0;
    do {
      piVar3 = (int *)((int)DAT_00f6eb04 + iVar4);
      LOCK();
      *piVar3 = *piVar3 + 1;
      UNLOCK();
      if ((*piVar3 == 0) && (*(int *)(iVar4 + 4 + (int)DAT_00f6eb04) < iVar2)) {
        iVar2 = *(int *)(iVar4 + 4 + (int)DAT_00f6eb04);
        iVar5 = iVar6;
      }
      LOCK();
      *(int *)((int)DAT_00f6eb04 + iVar4) = *(int *)((int)DAT_00f6eb04 + iVar4) + -1;
      UNLOCK();
      iVar6 = iVar6 + 1;
      iVar4 = iVar4 + 0xc;
    } while (iVar6 < DAT_00f6eb00);
  }
  while( true ) {
    piVar3 = DAT_00f6eb04 + iVar5 * 3;
    LOCK();
    *piVar3 = *piVar3 + 1;
    UNLOCK();
    if (*piVar3 == 0) break;
    LOCK();
    DAT_00f6eb04[iVar5 * 3] = DAT_00f6eb04[iVar5 * 3] + -1;
    UNLOCK();
    iVar5 = (iVar5 + 1) % DAT_00f6eb00;
  }
  *param_1 = DAT_00f6eb04[iVar5 * 3 + 2];
  DAT_00f6eb04[iVar5 * 3 + 2] = param_1;
  DAT_00f6eb04[iVar5 * 3 + 1] = DAT_00f6eb04[iVar5 * 3 + 1] + 1;
  LOCK();
  DAT_00f6eb04[iVar5 * 3] = DAT_00f6eb04[iVar5 * 3] + -1;
  UNLOCK();
  *puVar7 = uVar1;
  return puVar7;
}

