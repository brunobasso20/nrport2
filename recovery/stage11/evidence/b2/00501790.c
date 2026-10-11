/* NR2003.exe @ 00501790 FUN_00501790 */

void FUN_00501790(void)

{
  undefined2 *puVar1;
  ushort uVar2;
  int iVar3;
  
  puVar1 = DAT_00b8e58e;
  if (DAT_00b8e58a != 0) {
    DAT_00b8e58e = (undefined2 *)FUN_00501b80(8);
    iVar3 = getBGCount();
    uVar2 = FUN_005cebb0(iVar3);
    DAT_00b8e58e[2] = (DAT_00b8e58e[2] ^ uVar2) & 0x3ff ^ DAT_00b8e58e[2];
    DAT_00b8e58e[3] = 0;
    *(byte *)((int)DAT_00b8e58e + 5) = *(byte *)((int)DAT_00b8e58e + 5) & 3;
    *DAT_00b8e58e = 8;
    if (puVar1 == (undefined2 *)0x0) {
      DAT_00b8e58e[1] = 0;
    }
    else {
      DAT_00b8e58e[1] = *puVar1;
    }
    DAT_00b8e592 = 0;
    DAT_00b8e58a = 2;
    if (DAT_00b70dbc == (undefined2 *)0x0) {
      DAT_00b70dbc = DAT_00b8e58e;
    }
    FUN_005ab390();
    return;
  }
  return;
}

