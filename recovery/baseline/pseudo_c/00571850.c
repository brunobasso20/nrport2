/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571850 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00571850(int param_1,undefined4 *param_2,int param_3)

{
  char cVar1;
  uint uVar2;
  uint uVar3;
  int iVar4;
  undefined4 *puVar5;
  
  cVar1 = FUN_005f8da0(&DAT_00c70d84);
  if (cVar1 == '\0') {
    return 0;
  }
  uVar2 = 0;
  do {
    if ((*(char *)(uVar2 + param_1) == '\0') &&
       ((uVar3 = uVar2, uVar2 == 0 || (*(char *)(uVar2 + 1 + param_1) == '\0')))) break;
    uVar3 = uVar2 + 1;
    (&DAT_00c63734)[uVar2] = *(char *)(uVar2 + param_1);
    uVar2 = uVar3;
  } while (uVar3 < 0x8002);
  (&DAT_00c63734)[uVar3] = 0;
  (&DAT_00c63735)[uVar3] = 0;
  puVar5 = &DAT_00c5f730;
  for (iVar4 = param_3; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar5 = *param_2;
    param_2 = param_2 + 1;
    puVar5 = puVar5 + 1;
  }
  _DAT_00c63730 = param_3;
  FUN_005f8e20(&DAT_00c70d84);
  return 1;
}


