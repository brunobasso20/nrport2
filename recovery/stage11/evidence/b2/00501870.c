/* NR2003.exe @ 00501870 FUN_00501870 */

void FUN_00501870(undefined2 param_1)

{
  char cVar1;
  int iVar2;
  
  if ((DAT_00b8e58a != 0) && (cVar1 = FUN_005056a0(), cVar1 == '\0')) {
    DAT_00b8e592 = (undefined2 *)FUN_00501b80(4);
    if (DAT_00b8e592 == (undefined2 *)0x0) {
      return;
    }
    *DAT_00b8e592 = param_1;
    DAT_00b8e592[1] = 4;
    DAT_00b8e58a = 3;
    return;
  }
  cVar1 = FUN_005056a0();
  if (cVar1 != '\0') {
    DAT_00b715c8 = DAT_00b8e58e;
    DAT_00b715cc = DAT_00b8e596;
    DAT_00b71dd0 = 0;
    iVar2 = FUN_005ad630(&DAT_00b715d0);
    DAT_00b8e58e = (undefined2 *)(&DAT_00b715d0 + iVar2);
    *(ushort *)(&DAT_00b715d4 + iVar2) =
         (*(ushort *)(DAT_00b8e59e + 4) ^ *(ushort *)(&DAT_00b715d4 + iVar2)) & 0x3ff ^
         *(ushort *)(&DAT_00b715d4 + iVar2);
    DAT_00b8e58e[3] = 0xc;
    *(byte *)((int)DAT_00b8e58e + 5) = *(byte *)((int)DAT_00b8e58e + 5) & 3;
    *DAT_00b8e58e = 8;
    DAT_00b8e58e[1] = 0;
    DAT_00b8e596 = DAT_00b8e58e + 4;
    DAT_00b8e58a = 2;
    DAT_00b8e592 = (undefined2 *)FUN_00501b80(4);
    if (DAT_00b8e592 != (undefined2 *)0x0) {
      *DAT_00b8e592 = param_1;
      DAT_00b8e592[1] = 4;
      DAT_00b8e58a = 3;
      return;
    }
    DAT_00b8e58e = (undefined2 *)DAT_00b715c8;
    DAT_00b8e596 = (undefined2 *)DAT_00b715cc;
    DAT_00b715c8 = 0;
    DAT_00b715cc = 0;
    DAT_00b8e58a = 0;
    DAT_00b8e592 = (undefined2 *)0x0;
  }
  return;
}

