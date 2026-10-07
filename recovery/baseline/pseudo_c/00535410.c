/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00535410 */

uint FUN_00535410(int param_1)

{
  uint uVar1;
  
  uVar1 = 0;
  if ((*(int *)(param_1 + 0x5ae) != 0) &&
     ((uVar1 = *(uint *)(*(int *)(param_1 + 0x5ae) + 0x50), uVar1 == 2 || (uVar1 == 4)))) {
    return CONCAT31((int3)(uVar1 >> 8),1);
  }
  return uVar1 & 0xffffff00;
}


