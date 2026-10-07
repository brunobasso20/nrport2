/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005fa480 */

int FUN_005fa480(undefined4 param_1)

{
  uint uVar1;
  int iVar2;
  undefined1 local_1c [28];
  
  FUN_005fa1a0(local_1c,param_1);
  uVar1 = FUN_006c5018();
  iVar2 = (int)(uVar1 + ((int)uVar1 >> 0x1f & 3U)) >> 2;
  if ((uVar1 & 3) != 0) {
    iVar2 = iVar2 + 1;
  }
  return iVar2;
}


