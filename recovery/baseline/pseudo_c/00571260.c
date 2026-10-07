/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571260 */

undefined4 FUN_00571260(undefined4 param_1)

{
  int iVar1;
  char cVar2;
  
  cVar2 = FUN_005f8da0(&DAT_00c6b498 + DAT_00c70e00 * 0x11);
  iVar1 = DAT_00c70e00;
  if (cVar2 != '\0') {
    *(undefined4 *)(&DAT_00c6775c + DAT_00c70e00 * 4) = param_1;
    FUN_005f8e20(&DAT_00c6b498 + iVar1 * 0x11);
    DAT_00c70e00 = DAT_00c70e00 + 1;
    if (7 < DAT_00c70e00) {
      DAT_00c70e00 = 0;
    }
    return 1;
  }
  return 0;
}


