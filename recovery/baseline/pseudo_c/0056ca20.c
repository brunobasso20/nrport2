/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056ca20 */

undefined4 FUN_0056ca20(int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  
  if (param_1 == 0) {
    return *(undefined4 *)(DAT_00c5c2e8 + 1);
  }
  iVar2 = 0;
  if (0 < *DAT_00c5ca24) {
    iVar3 = 0;
    do {
      iVar1 = FUN_006c6530(param_1,*(undefined4 *)(iVar3 + 1 + DAT_00c5c2e8));
      if (iVar1 == 0) {
        return *(undefined4 *)(iVar2 * 5 + 1 + DAT_00c5c2e8);
      }
      iVar2 = iVar2 + 1;
      iVar3 = iVar3 + 5;
    } while (iVar2 < *DAT_00c5ca24);
  }
  return 0;
}


