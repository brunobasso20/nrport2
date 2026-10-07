/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571e50 */

uint FUN_00571e50(undefined4 param_1)

{
  uint uVar1;
  
  uVar1 = FUN_006c4ac9(param_1,&DAT_0074f47c,&DAT_00c721cc);
  if (uVar1 != 1) {
    return uVar1 & 0xffffff00;
  }
  if ((-1 < DAT_00c721cc) && (DAT_00c721cc < 3)) {
    return 1;
  }
  return 0;
}


