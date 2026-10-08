/* NR2003.exe @ 004f6320 FUN_004f6320 */

uint ** __fastcall FUN_004f6320(uint **param_1)

{
  int *piVar1;
  uint *puVar2;
  uint uVar3;
  int iVar4;
  uint *puVar5;
  int iVar6;
  
  if (DAT_00f7212a == '\0') {
    FUN_004f6a80(&DAT_00f70918,0x1800,5);
    DAT_00f7212a = '\x01';
    DAT_00f72118 = FUN_005cfcfc();
  }
  iVar6 = 0;
  if (0 < DAT_00f6eb00) {
    iVar4 = 0;
    do {
      piVar1 = (int *)(iVar4 + DAT_00f6eb04);
      LOCK();
      *piVar1 = *piVar1 + 1;
      UNLOCK();
      if ((*piVar1 == 0) && (*(int *)(iVar4 + 8 + DAT_00f6eb04) != 0)) {
        iVar6 = iVar6 * 0xc;
        puVar5 = *(uint **)(iVar6 + 8 + DAT_00f6eb04);
        *(undefined4 *)(iVar6 + 8 + DAT_00f6eb04) = **(undefined4 **)(iVar6 + 8 + DAT_00f6eb04);
        *(int *)(iVar6 + 4 + DAT_00f6eb04) = *(int *)(iVar6 + 4 + DAT_00f6eb04) + -1;
        LOCK();
        *(int *)(iVar6 + DAT_00f6eb04) = *(int *)(iVar6 + DAT_00f6eb04) + -1;
        UNLOCK();
        goto LAB_004f63b3;
      }
      LOCK();
      *(int *)(iVar4 + DAT_00f6eb04) = *(int *)(iVar4 + DAT_00f6eb04) + -1;
      UNLOCK();
      iVar6 = iVar6 + 1;
      iVar4 = iVar4 + 0xc;
    } while (iVar6 < DAT_00f6eb00);
  }
  puVar5 = (uint *)0x0;
LAB_004f63b3:
  param_1[2] = puVar5;
  iVar6 = 0;
  if (0 < DAT_00f6eb00) {
    iVar4 = 0;
    do {
      piVar1 = (int *)(iVar4 + DAT_00f6eb04);
      LOCK();
      *piVar1 = *piVar1 + 1;
      UNLOCK();
      if ((*piVar1 == 0) && (*(int *)(iVar4 + 8 + DAT_00f6eb04) != 0)) {
        iVar6 = iVar6 * 0xc;
        puVar5 = *(uint **)(iVar6 + 8 + DAT_00f6eb04);
        *(undefined4 *)(iVar6 + 8 + DAT_00f6eb04) = **(undefined4 **)(iVar6 + 8 + DAT_00f6eb04);
        *(int *)(iVar6 + 4 + DAT_00f6eb04) = *(int *)(iVar6 + 4 + DAT_00f6eb04) + -1;
        LOCK();
        *(int *)(iVar6 + DAT_00f6eb04) = *(int *)(iVar6 + DAT_00f6eb04) + -1;
        UNLOCK();
        goto LAB_004f6484;
      }
      LOCK();
      *(int *)(iVar4 + DAT_00f6eb04) = *(int *)(iVar4 + DAT_00f6eb04) + -1;
      UNLOCK();
      iVar6 = iVar6 + 1;
      iVar4 = iVar4 + 0xc;
    } while (iVar6 < DAT_00f6eb00);
  }
  puVar5 = (uint *)0x0;
LAB_004f6484:
  *param_1 = puVar5;
  iVar6 = 0;
  if (0 < DAT_00f6eb00) {
    iVar4 = 0;
    do {
      piVar1 = (int *)(iVar4 + DAT_00f6eb04);
      LOCK();
      *piVar1 = *piVar1 + 1;
      UNLOCK();
      if ((*piVar1 == 0) && (*(int *)(iVar4 + 8 + DAT_00f6eb04) != 0)) {
        iVar6 = iVar6 * 0xc;
        puVar5 = *(uint **)(iVar6 + 8 + DAT_00f6eb04);
        *(undefined4 *)(iVar6 + 8 + DAT_00f6eb04) = **(undefined4 **)(iVar6 + 8 + DAT_00f6eb04);
        *(int *)(iVar6 + 4 + DAT_00f6eb04) = *(int *)(iVar6 + 4 + DAT_00f6eb04) + -1;
        LOCK();
        *(int *)(iVar6 + DAT_00f6eb04) = *(int *)(iVar6 + DAT_00f6eb04) + -1;
        UNLOCK();
        goto LAB_004f64df;
      }
      LOCK();
      *(int *)(iVar4 + DAT_00f6eb04) = *(int *)(iVar4 + DAT_00f6eb04) + -1;
      UNLOCK();
      iVar6 = iVar6 + 1;
      iVar4 = iVar4 + 0xc;
    } while (iVar6 < DAT_00f6eb00);
  }
  puVar5 = (uint *)0x0;
LAB_004f64df:
  puVar2 = param_1[2];
  param_1[1] = puVar5;
  uVar3 = FUN_005cfcfc();
  *puVar2 = uVar3;
  **param_1 = *param_1[2];
  *param_1[1] = **param_1 ^ DAT_00f72118;
  FUN_005f5870(param_1 + 3,0x20);
  return param_1;
}

