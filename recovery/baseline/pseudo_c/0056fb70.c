/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056fb70 */

undefined4 FUN_0056fb70(undefined4 *param_1,undefined1 param_2)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c5f500);
  if (cVar1 != '\0') {
    puVar3 = &DAT_00c6f750;
    for (iVar2 = 0x40; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = *param_1;
      param_1 = param_1 + 1;
      puVar3 = puVar3 + 1;
    }
    DAT_00c6f850 = param_2;
    FUN_005f8e20(&DAT_00c5f500);
    return 1;
  }
  return 0;
}


