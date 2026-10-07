/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e2f0 */

void FUN_0056e2f0(void)

{
  int iVar1;
  undefined4 *puVar2;
  int iVar3;
  
  iVar3 = DAT_0074ee84;
  if (DAT_0074ee84 == -1) {
    iVar3 = 0;
    puVar2 = &DAT_00c5cb20;
    do {
      iVar1 = FUN_005954d0(puVar2);
      if (iVar1 == -1) {
        DAT_0074ee84 = iVar3;
        return;
      }
      puVar2 = puVar2 + 8;
      iVar3 = iVar3 + 1;
    } while ((int)puVar2 < 0xc5d320);
  }
  DAT_0074ee84 = iVar3;
  return;
}


