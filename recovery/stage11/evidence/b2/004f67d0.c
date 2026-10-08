/* NR2003.exe @ 004f67d0 FUN_004f67d0 */

void FUN_004f67d0(void)

{
  int iVar1;
  int iVar2;
  undefined4 *puVar3;
  
  if (DAT_00f7212a == '\0') {
    iVar2 = 0;
    DAT_00f6eafc = 4;
    DAT_00f6eb04 = &DAT_00f70918;
    DAT_00f6eb00 = 5;
    iVar1 = 0;
    do {
      iVar2 = iVar2 + 1;
      *(undefined4 *)(iVar1 + (int)DAT_00f6eb04) = 0xffffffff;
      *(undefined4 *)(iVar1 + 8 + (int)DAT_00f6eb04) = 0;
      *(undefined4 *)(iVar1 + 4 + (int)DAT_00f6eb04) = 0;
      iVar1 = iVar1 + 0xc;
    } while (iVar2 < DAT_00f6eb00);
    iVar1 = 0;
    iVar2 = (int)(0x17c4 / (longlong)DAT_00f6eafc) * DAT_00f6eafc;
    puVar3 = &DAT_00f70954;
    while (puVar3 < (undefined4 *)((int)&DAT_00f70954 + iVar2)) {
      *puVar3 = DAT_00f6eb04[iVar1 * 3 + 2];
      DAT_00f6eb04[iVar1 * 3 + 2] = puVar3;
      DAT_00f6eb04[iVar1 * 3 + 1] = DAT_00f6eb04[iVar1 * 3 + 1] + 1;
      puVar3 = (undefined4 *)((int)puVar3 + DAT_00f6eafc);
      iVar1 = iVar1 + 1;
      if (iVar1 == DAT_00f6eb00) {
        iVar1 = 0;
      }
    }
    DAT_00f7212a = '\x01';
    DAT_00f72118 = FUN_005cfcfc();
  }
  return;
}

