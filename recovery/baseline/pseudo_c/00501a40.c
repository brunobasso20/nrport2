/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00501a40 */

void FUN_00501a40(void)

{
  char cVar1;
  uint uVar2;
  undefined4 *puVar3;
  uint uVar4;
  
  if (DAT_00b8e58a != 0) {
    uVar2 = FUN_005ad630(DAT_00b8e596);
    DAT_00b8e58a = 2;
    if (0 < (int)uVar2) {
      puVar3 = (undefined4 *)FUN_00501b80(uVar2);
      if (puVar3 != (undefined4 *)0x0) {
        for (uVar4 = uVar2 >> 2; uVar4 != 0; uVar4 = uVar4 - 1) {
          *puVar3 = 0;
          puVar3 = puVar3 + 1;
        }
        for (uVar2 = uVar2 & 3; uVar2 != 0; uVar2 = uVar2 - 1) {
          *(undefined1 *)puVar3 = 0;
          puVar3 = (undefined4 *)((int)puVar3 + 1);
        }
      }
    }
    DAT_00b8e592 = 0;
    cVar1 = FUN_005056a0();
    if (cVar1 != '\0') {
      DAT_00b71dd0 = 1;
      DAT_00b8e58e = DAT_00b715c8;
      DAT_00b8e596 = DAT_00b715cc;
      DAT_00b715c8 = 0;
      DAT_00b715cc = 0;
      DAT_00b8e58a = 0;
    }
  }
  return;
}


