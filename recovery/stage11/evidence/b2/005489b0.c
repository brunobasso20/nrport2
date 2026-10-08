/* NR2003.exe @ 005489b0 FUN_005489b0 */

undefined4 FUN_005489b0(int param_1,byte param_2)

{
  int iVar1;
  
  iVar1 = 1 << (param_2 & 0x1f);
  return CONCAT31((int3)((uint)iVar1 >> 8),(*(byte *)(param_1 + 0xe) & (byte)iVar1) != 0);
}

