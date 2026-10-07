/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00433610 */

undefined4 FUN_00433610(int param_1)

{
  int iVar1;
  
  if ((&DAT_00890490)[param_1] == 0) {
    iVar1 = FUN_00433660();
    (&DAT_00890490)[param_1] = iVar1;
    if (iVar1 == 0) {
      return 0;
    }
    iVar1 = 0;
    do {
      if (iVar1 != param_1) {
        (&DAT_00890490)[iVar1] = (&DAT_00890490)[param_1];
      }
      iVar1 = iVar1 + 1;
    } while (iVar1 < 6);
  }
  return 1;
}


