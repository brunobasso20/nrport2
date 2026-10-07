/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b54f0 */

void FUN_005b54f0(void)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  undefined1 auStack_4 [4];
  
  cVar1 = FUN_00502460();
  if (cVar1 != '\0') {
    DAT_00eab1c4 = DAT_00eab1c8;
    DAT_007522b4 = DAT_007522b0;
    DAT_00eab1d0 = 1;
    (**(code **)(*DAT_00c72160 + 0x70))();
    FUN_005b56c0();
    if (DAT_007522b8 != '\0') {
      iVar2 = FUN_005b51b0(auStack_4);
      while (iVar2 != 0) {
        puVar3 = (undefined4 *)FUN_005b56a0();
        if (puVar3 != (undefined4 *)0x0) {
          FUN_005b53e0(puVar3 + 1,iVar2);
          *puVar3 = *(undefined4 *)(iVar2 + 0x1f);
          puVar3[0xf] = 0;
          FUN_005b5700(puVar3);
        }
        iVar2 = FUN_005b51f0(auStack_4);
      }
    }
    return;
  }
  DAT_00eab1c4 = DAT_00eab1cc + -1;
  DAT_007522b4 = 0xffffffff;
  if (DAT_00eab1d0 == '\0') {
    cVar1 = FUN_005b5250();
    if (cVar1 != '\0') {
      (**(code **)(*DAT_00c72160 + 0x70))();
      FUN_005b56c0();
    }
    iVar2 = FUN_005b5310();
    while (iVar2 != 0) {
      puVar3 = (undefined4 *)FUN_005b56a0();
      if (puVar3 != (undefined4 *)0x0) {
        FUN_005b53e0(puVar3 + 1,iVar2);
        *puVar3 = *(undefined4 *)(iVar2 + 0x1b);
        puVar3[0xf] = 0;
        FUN_005b5700(puVar3);
      }
      iVar2 = FUN_005b5310();
    }
    DAT_00eab1d0 = 0;
    return;
  }
  (**(code **)(*DAT_00c72160 + 0x70))();
  FUN_005b56c0();
  iVar2 = FUN_005b5350(auStack_4);
  while (iVar2 != 0) {
    puVar3 = (undefined4 *)FUN_005b56a0();
    if (puVar3 != (undefined4 *)0x0) {
      FUN_005b53e0(puVar3 + 1,iVar2);
      *puVar3 = *(undefined4 *)(iVar2 + 0x1b);
      puVar3[0xf] = 0;
      FUN_005b5700(puVar3);
    }
    iVar2 = FUN_005b5390(auStack_4);
  }
  FUN_005b5270();
  DAT_00eab1d0 = 0;
  return;
}


