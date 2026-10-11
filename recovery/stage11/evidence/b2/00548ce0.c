/* NR2003.exe @ 00548ce0 FUN_00548ce0 */

undefined4 FUN_00548ce0(int param_1,byte param_2)

{
  uint uVar1;
  
  uVar1 = 1 << (param_2 & 0x1f);
  return CONCAT31((int3)(uVar1 >> 8),(*(uint *)(param_1 + 0xc) >> 0x1d & uVar1 & 3) != 0);
}

