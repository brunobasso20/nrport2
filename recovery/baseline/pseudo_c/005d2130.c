/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005d2130 */

uint FUN_005d2130(undefined4 param_1)

{
  undefined4 in_EAX;
  int iVar1;
  uint uVar2;
  undefined1 local_4 [4];
  
  uVar2 = CONCAT31((int3)((uint)in_EAX >> 8),DAT_00f5e844);
  if (DAT_00f5e844 != '\0') {
    iVar1 = FUN_005d2370(local_4,&param_1,param_1);
    uVar2 = 0;
    if (iVar1 != 0) {
      uVar2 = FUN_005d2b90(param_1);
      return uVar2;
    }
  }
  return uVar2 & 0xffffff00;
}


