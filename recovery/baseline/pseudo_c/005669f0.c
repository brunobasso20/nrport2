/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005669f0 */

uint FUN_005669f0(uint *param_1)

{
  uint uVar1;
  
  if (*param_1 == 0) {
    *param_1 = (uint)&DAT_00c12030;
    uVar1 = 0;
  }
  else {
    uVar1 = *param_1 + 0x15b8;
    *param_1 = uVar1;
    if (0xc532af < uVar1) {
      *param_1 = 0;
      return uVar1 & 0xffffff00;
    }
  }
  return CONCAT31((int3)(uVar1 >> 8),1);
}


