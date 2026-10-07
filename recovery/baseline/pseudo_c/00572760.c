/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00572760 */

undefined4 FUN_00572760(undefined4 param_1)

{
  undefined4 uVar1;
  int iVar2;
  
  uVar1 = FUN_005cfd1a();
  iVar2 = FUN_005cfd14(uVar1);
  if (iVar2 != 0) {
    iVar2 = FUN_005cfd14(s_tracks_0074f4ec);
    if (iVar2 != 0) {
      iVar2 = FUN_005cfd14(param_1);
      if (iVar2 != 0) {
        return 1;
      }
    }
  }
  return 0;
}


