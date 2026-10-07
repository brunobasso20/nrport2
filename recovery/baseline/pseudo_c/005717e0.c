/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005717e0 */

undefined4 FUN_005717e0(int param_1)

{
  char cVar1;
  uint uVar2;
  uint uVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c5f6fc);
  if (cVar1 == '\0') {
    return 0;
  }
  uVar2 = 0;
  do {
    if ((*(char *)(uVar2 + param_1) == '\0') &&
       ((uVar3 = uVar2, uVar2 == 0 || (*(char *)(uVar2 + 1 + param_1) == '\0')))) break;
    uVar3 = uVar2 + 1;
    (&DAT_00c6b688)[uVar2] = *(char *)(uVar2 + param_1);
    uVar2 = uVar3;
  } while (uVar3 < 0x3ffe);
  (&DAT_00c6b688)[uVar3] = 0;
  (&DAT_00c6b689)[uVar3] = 0;
  FUN_005f8e20(&DAT_00c5f6fc);
  return 1;
}


