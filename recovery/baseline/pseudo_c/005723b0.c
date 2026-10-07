/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005723b0 */

uint FUN_005723b0(undefined4 param_1)

{
  uint uVar1;
  int local_104;
  undefined1 local_100 [256];
  
  uVar1 = FUN_006c4ac9(param_1,s__d__s_0074f4d4,&local_104,local_100);
  if (uVar1 != 2) {
    return uVar1 & 0xffffff00;
  }
  if (local_104 < 0x10) {
    if (-1 < local_104) {
      FUN_006c4b00(&DAT_00c70f10 + local_104 * 0x104,local_100,0xff);
    }
    if ((local_104 < 0x10) && (-1 < local_104)) {
      return 1;
    }
  }
  return 0;
}


