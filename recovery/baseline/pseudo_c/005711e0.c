/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005711e0 */

undefined4 FUN_005711e0(undefined4 *param_1)

{
  int iVar1;
  int iVar2;
  char cVar3;
  
  if (param_1 != (undefined4 *)0x0) {
    cVar3 = FUN_005f8da0(&DAT_00c6f868 + DAT_00c70dfc * 0x11);
    iVar2 = DAT_00c70dfc;
    if (cVar3 != '\0') {
      iVar1 = DAT_00c70dfc * 0xc;
      *(undefined4 *)(&DAT_00c68038 + iVar1) = *param_1;
      *(undefined4 *)(&DAT_00c6803c + iVar1) = param_1[1];
      *(undefined4 *)(&DAT_00c68040 + iVar1) = param_1[2];
      FUN_005f8e20(&DAT_00c6f868 + iVar2 * 0x11);
      DAT_00c70dfc = DAT_00c70dfc + 1;
      if (7 < DAT_00c70dfc) {
        DAT_00c70dfc = 0;
      }
      return 1;
    }
  }
  return 0;
}


