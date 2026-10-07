/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c340 */

uint FUN_0056c340(undefined4 param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  
  iVar3 = 0;
  if (0 < *DAT_00c5ca24) {
    iVar2 = 0;
    do {
      iVar1 = FUN_006c6530(param_1,*(undefined4 *)(iVar2 + 1 + DAT_00c5c2e8));
      if (iVar1 == 0) {
        return 1;
      }
      iVar3 = iVar3 + 1;
      iVar2 = iVar2 + 5;
    } while (iVar3 < *DAT_00c5ca24);
  }
  return (uint)DAT_00c5ca24 & 0xffffff00;
}


