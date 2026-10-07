/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e260 */

uint FUN_0056e260(void)

{
  uint uVar1;
  
  if (((int)DAT_0074ee9c < 0) || (DAT_0074ee9c == 0)) {
    uVar1 = DAT_0074ee9c & 0xffffff00;
  }
  else {
    if ((int)DAT_0074ee9c < 1) {
      DAT_0074ee9c = 1;
      return 1;
    }
    uVar1 = DAT_0074ee9c;
    if (0xff < (int)DAT_0074ee9c) {
      DAT_0074ee9c = 0xff;
      return 0xff;
    }
  }
  return uVar1;
}


