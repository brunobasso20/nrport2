/* NR2003.exe @ 005bcd40 FUN_005bcd40 */

undefined4 FUN_005bcd40(undefined4 param_1,int param_2)

{
  int iVar1;
  
  iVar1 = 0;
  if (0 < DAT_00b8faa0) {
    do {
      iVar1 = iVar1 + 1;
      *(undefined4 *)(param_2 + -4 + iVar1 * 4) = *(undefined4 *)(DAT_00b8faac + -4 + iVar1 * 4);
    } while (iVar1 < DAT_00b8faa0);
  }
  return 1;
}

