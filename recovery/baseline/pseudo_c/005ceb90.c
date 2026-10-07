/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005ceb90 */

uint FUN_005ceb90(int param_1,int param_2)

{
  uint uVar1;
  
  uVar1 = param_1 - param_2;
  if ((uVar1 & 0x200) != 0) {
    return uVar1 | 0xfffffc00;
  }
  return uVar1 & 0x3ff;
}


