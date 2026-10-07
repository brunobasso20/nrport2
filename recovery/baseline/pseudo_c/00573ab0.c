/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573ab0 */

undefined4 FUN_00573ab0(void)

{
  int iVar1;
  
  if (DAT_0074f3d8 == '\0') {
    return 1;
  }
  iVar1 = FUN_005d4050(&DAT_00c72164);
  if (iVar1 == 1) {
    (**(code **)(*DAT_00c72160 + 0x2c))(DAT_00c72164);
    return 1;
  }
  return 0;
}


