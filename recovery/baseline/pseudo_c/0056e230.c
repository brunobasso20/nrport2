/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e230 */

int FUN_0056e230(void)

{
  int iVar1;
  
  if ((DAT_0074ee98 < 0) || (DAT_00c5f420 < 0)) {
    iVar1 = CONCAT31((int3)((uint)DAT_0074ee98 >> 8),0xff);
  }
  else {
    iVar1 = DAT_0074ee98;
    if (10 < DAT_0074ee98) {
      DAT_0074ee98 = 10;
      return 10;
    }
  }
  return iVar1;
}


