/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00572380 */

uint FUN_00572380(undefined4 param_1)

{
  uint uVar1;
  
  uVar1 = FUN_006c4ac9(param_1,&DAT_0074f4d0,&DAT_00c721cc);
  if (uVar1 == 1) {
    return (uint)(DAT_00c721cc == 0);
  }
  return uVar1 & 0xffffff00;
}


